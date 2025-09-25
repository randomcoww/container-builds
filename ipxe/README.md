### Container for iPXE images with internal CA served over TFTP or HTTP

https://github.com/ipxe/ipxe

busybox also includes tftpd and may be started like this

```dockerfile
ENTRYPOINT [ "udpsvd", "-vE", "0.0.0.0", "69", "tftpd", "-r", "-u", "www-data", "/var/www" ]
```

```dockerfile
ENTRYPOINT [ "udpsvd", "-vE", "0.0.0.0", "1069", "tftpd", "-r", "/var/www" ]
```