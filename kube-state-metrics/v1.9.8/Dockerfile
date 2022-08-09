## Use original image to copy files from
## ref: https://github.com/kubernetes/kube-state-metrics/blob/v1.9.8/Dockerfile
FROM quay.io/coreos/kube-state-metrics:v1.9.8 as builder

## Build RedHat compliant image
FROM registry.access.redhat.com/ubi8/ubi:8.6

LABEL name="Kube-state-metrics" \
      vendor="Sumo Logic" \
      version="1.9.8" \
      release="2" \
      summary="UBI based kube-state-metrics" \
      description="kube-state-metrics is a simple service that listens to the Kubernetes API server and generates metrics about the state of the objects." \
      maintainer="collection@sumologic.com"

COPY --from=builder \
    /kube-state-metrics \
    /
ADD https://raw.githubusercontent.com/kubernetes/kube-state-metrics/v1.9.8/LICENSE \
    /licenses/LICENSE

USER nobody

ENTRYPOINT ["/kube-state-metrics", "--port=8080", "--telemetry-port=8081"]

EXPOSE 8080 8081
