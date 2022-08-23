## Use original image to copy files from
## ref: https://github.com/prometheus-operator/prometheus-operator/blob/v0.44.0/Dockerfile
FROM quay.io/prometheus-operator/prometheus-operator:v0.44.0 as builder

## Build RedHat compliant image
FROM registry.access.redhat.com/ubi8/ubi:8.6

ENV SUMMARY="UBI based prometheus-operator" \
    DESCRIPTION="The Prometheus Operator provides Kubernetes native deployment and management of Prometheus and related monitoring components."

LABEL name="Prometheus-operator" \
      vendor="Sumo Logic" \
      version="0.44.0" \
      release="2" \
      summary="$SUMMARY" \
      description="$DESCRIPTION" \
      io.k8s.description="$DESCRIPTION" \
      maintainer="collection@sumologic.com"

COPY --from=builder \
    /bin/operator \
    /bin/operator
ADD https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/v0.44.0/LICENSE \
    /licenses/LICENSE

# On busybox 'nobody' has uid `65534'
USER 65534

ENTRYPOINT ["/bin/operator"]
