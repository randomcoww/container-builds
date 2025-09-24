FROM busybox:stable-musl

WORKDIR /var/www
COPY --chown=www-data:www-data www/ .
USER www-data

ENTRYPOINT [ "httpd", "-f", "-v" ]