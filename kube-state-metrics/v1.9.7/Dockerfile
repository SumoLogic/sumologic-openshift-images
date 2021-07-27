## Use original image to copy files from
## ref: https://github.com/kubernetes/kube-state-metrics/blob/b3fa5852d755c912c2601c53781a58567c822b81/Dockerfile
FROM quay.io/coreos/kube-state-metrics:v1.9.7 as builder

## Build RedHat compliant image
FROM registry.access.redhat.com/ubi8/ubi:8.4

LABEL name="Kube-state-metrics" \
      vendor="SumoLogic" \
      version="1.9.7" \
      release="1" \
      summary="UBI based kube-state-metrics" \
      description="kube-state-metrics is a simple service that listens to the Kubernetes API server and generates metrics about the state of the objects." \
      maintainer="collection@sumologic.com"

COPY --from=builder \
    /kube-state-metrics \
    /
ADD https://raw.githubusercontent.com/kubernetes/kube-state-metrics/b3fa5852d755c912c2601c53781a58567c822b81/LICENSE \
    /licenses/LICENSE

USER nobody

ENTRYPOINT ["/kube-state-metrics", "--port=8080", "--telemetry-port=8081"]

EXPOSE 8080 8081
