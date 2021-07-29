## Use original image to copy files from
## ref: https://github.com/SumoLogic/sumologic-kubernetes-fluentd/blob/2d2b7693b87f9a0c175740e9674455051c709409/Dockerfile
FROM public.ecr.aws/sumologic/kubernetes-fluentd:1.12.2-sumo-0 as sumo-image

## Build RedHat compliant image for fluentd
## ref: https://github.com/fluent/fluentd-docker-image/blob/4e0810850460c7669d7a8ad15d5a3c8ddf28652c/v1.12/debian/Dockerfile
FROM registry.access.redhat.com/ubi8/ruby-26:1 as fluentd

ENV TINI_VERSION=0.18.0

USER root
# NOTE: resolv v0.2.1 includes the fix for CPU spike issue due to DNS resolver.
# This hack is needed for Ruby 2.6.7, 2.7.3 and 3.0.1.
# Do not split this into multiple RUN!
# Docker creates a layer for every RUN-Statement
# therefore an 'apt-get purge' has no effect
RUN gem install oj -v 3.10.18 \
 && gem install json -v 2.4.1 \
 && gem install resolv -v 0.2.1 \
 && gem install async-http -v 0.54.0 \
 && gem install ext_monitor -v 0.1.2 \
 && gem install fluentd -v 1.12.2 \
 && wget -O /usr/local/bin/tini "https://github.com/krallin/tini/releases/download/v$TINI_VERSION/tini-amd64" \
 && wget -O /usr/local/bin/tini.asc "https://github.com/krallin/tini/releases/download/v$TINI_VERSION/tini-amd64.asc" \
 && export GNUPGHOME="$(mktemp -d)" \
 && rm -r /usr/local/bin/tini.asc \
 && chmod +x /usr/local/bin/tini \
 && tini -h \
 && wget -O /tmp/jemalloc-4.5.0.tar.bz2 https://github.com/jemalloc/jemalloc/releases/download/4.5.0/jemalloc-4.5.0.tar.bz2 \
 && cd /tmp && tar -xjf jemalloc-4.5.0.tar.bz2 && cd jemalloc-4.5.0/ \
 && ./configure && make \
 && mv lib/libjemalloc.so.2 /usr/lib \
 && rm -rf /var/lib/apt/lists/* \
 && rm -rf /tmp/* /var/tmp/* /usr/lib/ruby/gems/*/cache/*.gem /usr/lib/ruby/gems/2.*/gems/fluentd-*/test

RUN groupadd -r fluent && useradd -r -g fluent fluent \
    # for log storage (maybe shared with host)
    && mkdir -p /fluentd/log \
    # configuration/plugins path (default: copied from .)
    && mkdir -p /fluentd/etc /fluentd/plugins \
    && chown -R fluent /fluentd && chgrp -R fluent /fluentd

COPY --from=sumo-image /fluentd/etc/fluent.conf /fluentd/etc/
COPY --from=sumo-image /bin/entrypoint.sh /bin/

ENV FLUENTD_CONF="fluent.conf"

ENV LD_PRELOAD="/usr/lib/libjemalloc.so.2"
# NOTE: resolv v0.2.1 includes the fix for CPU spike issue due to DNS resolver.
# Forcing to load specific version of resolv (instead of bundled by default) is needed for Ruby 2.6.7, 2.7.3 and 3.0.1.
ENV RUBYLIB="/usr/local/bundle/gems/resolv-0.2.1/lib"
EXPOSE 24224 5140

USER fluent
ENTRYPOINT ["tini",  "--", "/bin/entrypoint.sh"]
CMD ["fluentd"]

FROM fluentd

LABEL name="Kubernetes-fluentd" \
      vendor="Sumo Logic" \
      version="1.12.2-sumo-0" \
      release="1" \
      summary="UBI based kubernetes-fluentd" \
      description="Kubernetes-fluentd is a custom Fluentd build with plugins used by Sumo Logic Kubernetes Collection." \
      maintainer="collection@sumologic.com"

ADD https://raw.githubusercontent.com/SumoLogic/sumologic-kubernetes-fluentd/2d2b7693b87f9a0c175740e9674455051c709409/LICENSE \
    /licenses/LICENSE

## ref: https://github.com/yashoza19/sumologic-kubernetes-fluentd/blob/c22a932b22ffc591bbc6f2a0ac624c323c1b5006/Dockerfile
USER root
RUN yum install -y jq \
 && gem install rdoc -v 6.3.1 \
 && gem cleanup
COPY --from=sumo-image --chown=fluent:fluent /usr/local/bundle /usr/local/share/gems
COPY --from=sumo-image /bin/./entrypoint.sh /bin/
COPY ./snappy.rpm .
COPY ./snappy-devel.rpm .
RUN rpm -i snappy.rpm \
 && rpm -i snappy-devel.rpm \
 && rm snappy.rpm snappy-devel.rpm \
 && gem pristine ffi -v 1.15.0 \
 && gem pristine http-parser --version 1.2.3 \
 && gem pristine snappy --version 0.0.17 \
 && gem pristine unf_ext --version 0.0.7.7
USER 999:999
