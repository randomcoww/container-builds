package main

import (
	"context"
	"flag"
	"fmt"
	"github.com/minio/minio-go/v7"
	"github.com/minio/minio-go/v7/pkg/credentials"
	"log"
	"os"
	"sync"
)

type uploader struct {
	endpoint     string
	bucket       string
	minioClient  *minio.Client
	uploadStatus []*uploadStatus
	mu           sync.Mutex
	ctx          context.Context
	cancel       func()
}

type uploadStatus struct {
	path      string
	errorCh   chan error
	successCh chan struct{}
	cancel    func()
}

func main() {
	var path, endpoint, bucket, accessKeyID, secretAccessKey string
	flag.StringVar(&endpoint, "endpoint", "", "Minio endpoint.")
	flag.StringVar(&bucket, "bucket", "", "Minio bucket.")
	flag.StringVar(&path, "path", "", "Directory or file to upload.")
	flag.StringVar(&accessKeyID, "access-key-id", "", "Minio credentials.")
	flag.StringVar(&secretAccessKey, "secret-access-key", "", "Minio credentials.")
	flag.Parse()

	ctx, cancel := context.WithCancel(context.Background())
	minioClient, err := minio.New(endpoint, &minio.Options{
		Creds: credentials.NewStaticV4(accessKeyID, secretAccessKey, ""),
	})
	if err != nil {
		log.Fatalf("failed %+v", err)
		os.Exit(1)
	}
	v := &uploader{
		endpoint:    endpoint,
		bucket:      bucket,
		minioClient: minioClient,
		ctx:         ctx,
		cancel:      cancel,
	}
	if err = v.uploadFiles(path); err != nil {
		log.Fatalf("failed %+v", err)
		os.Exit(1)
	}
	log.Printf("finished without errors")
}

func (v *uploader) newUploadStatus(path string) *uploadStatus {
	u := &uploadStatus{
		path:      path,
		cancel:    v.cancel,
		errorCh:   make(chan error, 1),
		successCh: make(chan struct{}, 1),
	}
	v.mu.Lock()
	v.uploadStatus = append(v.uploadStatus, u)
	v.mu.Unlock()
	return u
}

func (v *uploadStatus) addStatus(err error) {
	if err != nil {
		v.errorCh <- err
		log.Fatalf("failed '%s' %+v", v.path, err)
		v.cancel()
		return
	}
	log.Printf("success %s", v.path)
	v.successCh <- struct{}{}
}

func (v *uploader) uploadFiles(path string) error {
	if err := v.uploadFilesFromPath(path); err != nil {
		return err
	}
	log.Printf("waiting for uploads")

	var errors []error
	for _, status := range v.uploadStatus {
		select {
		case err := <-status.errorCh:
			errors = append(errors, err)
		case <-status.successCh:
		}
	}
	if len(errors) > 0 {
		return fmt.Errorf("%+v", errors)
	}
	return nil
}

func (v *uploader) uploadFilesFromPath(path string) error {
	log.Printf("checking path '%s'", path)
	fi, err := os.Lstat(path)
	if err != nil {
		return err
	}
	if fi.IsDir() {
		subPaths, err := os.ReadDir(path)
		if err != nil {
			return err
		}
		for _, subPath := range subPaths {
			if err = v.uploadFilesFromPath(fmt.Sprintf("%s/%s", path, subPath.Name())); err != nil {
				return err
			}
		}
		return nil
	}
	log.Printf("upload file '%s'", path)
	go v.putFile(v.newUploadStatus(path))
	return nil
}

func (v *uploader) putFile(status *uploadStatus) {
	_, err := v.minioClient.FPutObject(v.ctx, v.bucket, status.path, status.path, minio.PutObjectOptions{})
	status.addStatus(err)
}
