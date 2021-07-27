## Use original image to copy files from
## ref: https://github.com/prometheus-operator/prometheus-operator/blob/b86ab77239f2a11ee69ad05b24122958d8b2df5b/Dockerfile
FROM quay.io/prometheus-operator/prometheus-operator:v0.43.2 as builder

## Build RedHat compliant image
FROM registry.access.redhat.com/ubi8/ubi:8.4

LABEL name="Prometheus-operator" \
      vendor="SumoLogic" \
      version="0.43.2" \
      release="1" \
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
