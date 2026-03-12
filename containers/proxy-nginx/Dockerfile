FROM nginx:1.27.1-alpine AS builder

ARG CONNECT_MODULE_COMMIT=4f0b6c2297862148c59a0d585d6c46ccb7e58a39

RUN apk add --no-cache --virtual .build-deps \
        gcc libc-dev make openssl-dev pcre2-dev zlib-dev \
        linux-headers patch curl

RUN mkdir -p /usr/src && cd /usr/src && \
    curl -fSL "http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz" -o nginx.tar.gz && \
    curl -fSL "https://github.com/chobits/ngx_http_proxy_connect_module/archive/${CONNECT_MODULE_COMMIT}.tar.gz" -o ngx_http_proxy_connect_module.tar.gz && \
    tar zxf nginx.tar.gz && \
    tar zxf ngx_http_proxy_connect_module.tar.gz && \
    mv ngx_http_proxy_connect_module-${CONNECT_MODULE_COMMIT} ngx_http_proxy_connect_module && \
    cd /usr/src/nginx-${NGINX_VERSION} && \
    patch -p1 < ../ngx_http_proxy_connect_module/patch/proxy_connect_rewrite_102101.patch && \
    CONFARGS=$(nginx -V 2>&1 | sed -n -e 's/^.*arguments: //p') && \
    echo $CONFARGS && \
    eval ./configure --with-compat $CONFARGS --add-dynamic-module=../ngx_http_proxy_connect_module/ && \
    make -j1 && make install && \
    strip /usr/sbin/nginx

FROM alpine:3.21

RUN apk add --no-cache pcre2 zlib libssl3 tzdata ca-certificates \
    && addgroup -S nginx \
    && adduser -D -S -h /var/cache/nginx -s /sbin/nologin -G nginx nginx \
    && mkdir -p /var/log/nginx /var/cache/nginx /etc/nginx/conf.d /etc/nginx/modules \
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

COPY --from=builder /etc/nginx/modules/ngx_http_proxy_connect_module.so /etc/nginx/modules/
COPY --from=builder /usr/sbin/nginx /usr/sbin/nginx
COPY --from=builder /etc/nginx/mime.types /etc/nginx/mime.types
COPY conf/nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

STOPSIGNAL SIGTERM

CMD ["nginx", "-g", "daemon off;"]
