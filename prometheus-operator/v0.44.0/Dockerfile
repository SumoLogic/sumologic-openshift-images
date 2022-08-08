## Use original image to copy files from
## ref: https://github.com/prometheus-operator/prometheus-operator/blob/d8b7d3766225908d0239fd0d78258892cd0fc384/Dockerfile
FROM quay.io/prometheus-operator/prometheus-operator:v0.44.0 as builder

## Build RedHat compliant image
FROM registry.access.redhat.com/ubi8/ubi:8.6

LABEL name="Prometheus-operator" \
      vendor="Sumo Logic" \
      version="0.44.0" \
      release="2" \
      summary="UBI based prometheus-operator" \
      description="The Prometheus Operator provides Kubernetes native deployment and management of Prometheus and related monitoring components." \
      maintainer="collection@sumologic.com"

COPY --from=builder \
    /bin/operator \
    /bin/operator
ADD https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/b86ab77239f2a11ee69ad05b24122958d8b2df5b/LICENSE \
    /licenses/LICENSE

# On busybox 'nobody' has uid `65534'
USER 65534

ENTRYPOINT ["/bin/operator"]
