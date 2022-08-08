package main

import (
	"context"
	"flag"
	"fmt"
	"log"
	"net/http"
	"net/url"
	"os"
	"sync"
	// "time"
)

type uploader struct {
	url          string
	fileCount    int
	httpClient   *http.Client
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
	var path, url string
	flag.StringVar(&url, "url", "", "Upload destination URL.")
	flag.StringVar(&path, "path", "", "Directory or file to upload.")
	flag.Parse()

	uploader := newUploader(url)
	// go func() {
	// 	time.Sleep(1000 * time.Millisecond)
	// 	uploader.cancel()
	// }()

	if err := uploader.uploadFiles(path); err != nil {
		os.Exit(1)
	}
	log.Printf("finished without errors")
}

func newUploader(url string) *uploader {
	ctx, cancel := context.WithCancel(context.Background())
	return &uploader{
		url:        url,
		httpClient: &http.Client{},
		ctx:        ctx,
		cancel:     cancel,
	}
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
		log.Fatalf("error %+v", err)
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
	} else {
		log.Printf("upload file '%s'", path)
		go v.putFile(v.newUploadStatus(path))
	}
	return nil
}

func (v *uploader) putFile(status *uploadStatus) {
	data, err := os.Open(status.path)
	if err != nil {
		status.addStatus(err)
		return
	}

	url := fmt.Sprintf("%s/%s", v.url, url.PathEscape(status.path))
	req, err := http.NewRequestWithContext(v.ctx, http.MethodPut, url, data)
	if err != nil {
		status.addStatus(err)
		return
	}
	log.Printf("uploading '%s' -> '%s'", status.path, url)

	resp, err := v.httpClient.Do(req)
	defer resp.Body.Close()
	if err != nil {
		status.addStatus(err)
		return
	}
	switch resp.StatusCode {
	case 200:
		log.Printf("%s", resp.Status)
		status.addStatus(nil)
		return
	}
	// log.Printf("%s", resp.Status)
	status.addStatus(fmt.Errorf(resp.Status))
}
