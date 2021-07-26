## Build prometheus-operator
ARG GOVERSION=1.16
FROM golang:${GOVERSION} as builder
ARG GOARCH
ENV GOARCH=${GOARCH}
WORKDIR /prometheus-operator
COPY source /prometheus-operator

RUN make operator

## Build RedHat compliant image
FROM registry.access.redhat.com/ubi8/ubi:8.4

LABEL name="Prometheus-operator" \
      vendor="SumoLogic" \
      version="0.43.2" \
      release="1" \
      summary="UBI based prometheus-operator" \
      description="The Prometheus Operator provides Kubernetes native deployment and management of Prometheus and related monitoring components."

COPY --from=builder \
    /prometheus-operator/operator \
    /bin/operator
COPY --from=builder \
    /prometheus-operator/LICENSE \
    /licenses/LICENSE

# On busybox 'nobody' has uid `65534'
USER 65534

ENTRYPOINT ["/bin/operator"]
