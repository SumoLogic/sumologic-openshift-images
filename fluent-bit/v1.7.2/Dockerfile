FROM registry.access.redhat.com/ubi8/ubi:8.4 as builder

ARG BISON_VERSION=3.7
ARG FLEX_VERSION=2.6.4
ARG FLUENT_BIT_VERSION=1.7.2

RUN dnf update && \
    dnf install -y cmake diffutils gcc gcc-c++ libpq-devel m4 make openssl-devel systemd-devel tar unzip wget && \
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
 
RUN wget https://github.com/fluent/fluent-bit/archive/refs/tags/v${FLUENT_BIT_VERSION}.tar.gz && \
    mkdir -p /fluent-bit/bin /fluent-bit/etc /fluent-bit/log && \
    tar -xzvf v${FLUENT_BIT_VERSION}.tar.gz -C /fluent-bit/ && \
    rm v${FLUENT_BIT_VERSION}.tar.gz && \
    cd /fluent-bit/fluent-bit-${FLUENT_BIT_VERSION}/ && \
    cmake -DFLB_RELEASE=On -DFLB_TLS=On && make && install bin/fluent-bit /fluent-bit/bin/ && \
    cp /fluent-bit/fluent-bit-${FLUENT_BIT_VERSION}/conf/*.conf /fluent-bit/etc/ && \
    cp /fluent-bit/fluent-bit-${FLUENT_BIT_VERSION}/LICENSE /fluent-bit/ && \
    rm -rf /fluent-bit/fluent-bit-${FLUENT_BIT_VERSION}/

FROM registry.access.redhat.com/ubi8/ubi-minimal:8.4

LABEL name="Fluent Bit" \
      vendor="SumoLogic" \
      version="1.7.2" \
      release="1" \
      summary="UBI based Fluent Bit" \
      description="Fluent Bit is a fast Log Processor and Forwarder"

RUN microdnf update && microdnf install -y openssl libpq systemd && microdnf clean all

COPY --from=builder /fluent-bit /fluent-bit
COPY --from=builder /fluent-bit/LICENSE /licenses/

EXPOSE 2020
CMD ["/fluent-bit/bin/fluent-bit", "-c", "/fluent-bit/etc/fluent-bit.conf"]
