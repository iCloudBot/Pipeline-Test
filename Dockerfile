FROM nginx:stable-alpine-slim as base

RUN apk upgrade --no-cache && \
    apk add libcap tzdata curl --no-cache && \
    cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime  && \
    sed -i '/default_type/a\    server_tokens off;' /etc/nginx/nginx.conf && \
    setcap 'cap_net_bind_service=+ep' /usr/sbin/nginx && \
    chown nginx:nginx /var/cache/nginx /var/run

FROM scratch
COPY --from=base / /
WORKDIR /usr/share/nginx/html
ENV NGINX_VERSION=1.24.0
# USER nginx

CMD ["nginx", "-g", "daemon off;"]
