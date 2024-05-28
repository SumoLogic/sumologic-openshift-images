# This file has been build based on the following sources:
#  - images layers from https://hub.docker.com/layers/nginxinc/nginx-unprivileged/1.26.0-alpine/images/sha256-0904c0562547ece642e3541086bfb63c5cc79a5290f594328a82e7301b4cd451?context=explore
#  - installing nginx package from redhat
ARG UPSTREAM_VERSION

FROM public.ecr.aws/sumologic/nginx-unprivileged:${UPSTREAM_VERSION} as builder

## Build RedHat compliant image
FROM registry.access.redhat.com/ubi9/ubi-minimal:9.4
ARG UPSTREAM_VERSION
ARG RELEASE
ARG NGINX_UID=999
ARG NGINX_GID=999

ENV SUMMARY="UBI based Unprivileged NGINX" \
    DESCRIPTION="nginx is an HTTP and reverse proxy server, a mail proxy server, and a generic TCP/UDP proxy server"

LABEL name="Unprivileged NGINX" \
    vendor="Sumo Logic" \
    version="${UPSTREAM_VERSION}" \
    release="${RELEASE}" \
    summary="$SUMMARY" \
    description="$DESCRIPTION" \
    io.k8s.description="$DESCRIPTION" \
    maintainer="opensource-collection-team@sumologic.com"

RUN microdnf update -y \
    && microdnf install -y \
    ca-certificates \
    nginx && \
    microdnf clean all

RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

RUN sed -i 's,listen       80;,listen       8080;,' /etc/nginx/nginx.conf \
    && sed -i '/user  nginx;/d' /etc/nginx/nginx.conf && \sed -i 's,/var/run/nginx.pid,/tmp/nginx.pid,' /etc/nginx/nginx.conf \
    && sed -i "/^http {/a \    proxy_temp_path /tmp/proxy_temp;\n    client_body_temp_path /tmp/client_temp;\n    fastcgi_temp_path /tmp/fastcgi_temp;\n    uwsgi_temp_path /tmp/uwsgi_temp;\n    scgi_temp_path /tmp/scgi_temp;\n" /etc/nginx/nginx.conf \
    && chown -R $NGINX_UID:0 /etc/nginx \
    && chmod -R g+w /etc/nginx

COPY --from=builder docker-entrypoint.sh /
COPY --from=builder /docker-entrypoint.d /docker-entrypoint.d
ADD https://raw.githubusercontent.com/nginxinc/docker-nginx-unprivileged/main/LICENSE \
    /licenses

ENTRYPOINT ["/docker-entrypoint.sh"]
EXPOSE 8080
STOPSIGNAL SIGQUIT
USER 999
CMD ["nginx" "-g" "daemon off;"]
