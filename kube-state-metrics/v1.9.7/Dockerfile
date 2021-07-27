## This is copy of the source/Dockerfile
## with additional clean up of the git submodule state
## ref: https://github.com/kubernetes/kube-state-metrics/blob/b3fa5852d755c912c2601c53781a58567c822b81/Dockerfile
ARG GOVERSION=1.16
FROM golang:${GOVERSION} as builder
ARG GOARCH
ENV GOARCH=${GOARCH}
WORKDIR /go/src/k8s.io/kube-state-metrics/
COPY source /go/src/k8s.io/kube-state-metrics/

RUN rm .git && git init && make build-local

## Build RedHat compliant image
FROM registry.access.redhat.com/ubi8/ubi:8.4

LABEL name="Kube-state-metrics" \
      vendor="SumoLogic" \
      version="1.9.7" \
      release="1" \
      summary="UBI based kube-state-metrics" \
      description="kube-state-metrics is a simple service that listens to the Kubernetes API server and generates metrics about the state of the objects."

COPY --from=builder \
    /go/src/k8s.io/kube-state-metrics/kube-state-metrics \
    /
COPY --from=builder \
    /go/src/k8s.io/kube-state-metrics/LICENSE \
    /licenses/LICENSE

USER nobody

ENTRYPOINT ["/kube-state-metrics", "--port=8080", "--telemetry-port=8081"]

EXPOSE 8080 8081
