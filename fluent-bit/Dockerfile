ARG UPSTREAM_VERSION

FROM registry.access.redhat.com/ubi9/ubi:9.4 as builder
ARG UPSTREAM_VERSION

ARG BISON_VERSION=3.8.2
ARG FLEX_VERSION=2.6.4

RUN dnf update -y && \
    dnf install -y cmake \
    diffutils \
    gcc \
    gcc-c++ \
    libpq-devel \
    m4 \
    make \
    openssl-devel \
    systemd-devel \
    tar \
    unzip \
    wget \
    libyaml-devel && \
    dnf clean all

RUN wget http://ftp.gnu.org/gnu/bison/bison-${BISON_VERSION}.tar.gz && \
    tar -xzvf bison-${BISON_VERSION}.tar.gz && \
    cd bison*/ && \
    ./configure && \
    make && \
    make install

RUN wget https://github.com/westes/flex/files/981163/flex-${FLEX_VERSION}.tar.gz && \
    tar -xzvf flex-${FLEX_VERSION}.tar.gz && \
    cd flex*/ && \
    ./configure && \
    make && \
    make install

RUN mkdir -p /fluent-bit/bin /fluent-bit/etc /fluent-bit/log /tmp/src/

RUN wget https://github.com/fluent/fluent-bit/archive/refs/tags/v${UPSTREAM_VERSION}.tar.gz && \
    tar -xzvf v${UPSTREAM_VERSION}.tar.gz -C  /tmp/src/ --strip-components=1 && \
    rm v${UPSTREAM_VERSION}.tar.gz

WORKDIR /tmp/src/build/
RUN cmake -DFLB_DEBUG=Off \
    -DFLB_TRACE=Off \
    -DFLB_JEMALLOC=On \
    -DFLB_TLS=On \
    -DFLB_SHARED_LIB=Off \
    -DFLB_EXAMPLES=Off \
    -DFLB_HTTP_SERVER=On \
    -DFLB_IN_SYSTEMD=On \
    -DFLB_OUT_KAFKA=On \
    -DFLB_OUT_PGSQL=On ../

RUN make -j $(getconf _NPROCESSORS_ONLN)
RUN install bin/fluent-bit /fluent-bit/bin/

# Configuration files
RUN cp /tmp/src/conf/*.conf /fluent-bit/etc/

## Build RedHat compliant image
FROM registry.access.redhat.com/ubi9/ubi-minimal:9.4
ARG UPSTREAM_VERSION
ARG RELEASE

ENV SUMMARY="UBI based Fluent Bit image" \
    DESCRIPTION="Fluent Bit is a fast Log Processor and Forwarder"

LABEL name="Fluent Bit" \
    vendor="Sumo Logic" \
    version="${UPSTREAM_VERSION}" \
    release="${RELEASE}" \
    summary="$SUMMARY" \
    description="$DESCRIPTION" \
    io.k8s.description="$DESCRIPTION" \
    maintainer="opensource-collection-team@sumologic.com"

RUN microdnf update -y && microdnf install -y openssl libpq systemd && microdnf clean all

COPY --from=builder /fluent-bit /fluent-bit
COPY --from=builder /tmp/src/LICENSE /licenses/

EXPOSE 2020
USER nobody
CMD ["/fluent-bit/bin/fluent-bit", "-c", "/fluent-bit/etc/fluent-bit.conf"]
