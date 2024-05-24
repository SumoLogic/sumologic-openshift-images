ARG UPSTREAM_VERSION
ARG UBI_IMAGE=registry.access.redhat.com/ubi8/ubi:8.6

## Use original image to copy files from
## ref: https://github.com/prometheus/node_exporter/blob/v1.3.1/Dockerfile
FROM public.ecr.aws/sumologic/node-exporter:v${UPSTREAM_VERSION} as builder

## Build RedHat compliant image
FROM ${UBI_IMAGE}
ARG UPSTREAM_VERSION
ARG RELEASE

ENV SUMMARY="UBI based node-exporter" \
    DESCRIPTION="Prometheus exporter for hardware and OS metrics exposed by *NIX kernels, written in Go with pluggable metric collectors."

LABEL name="Node-exporter" \
      vendor="Sumo Logic" \
      version="${UPSTREAM_VERSION}" \
      release="${RELEASE}" \
      summary="$SUMMARY" \
      description="$DESCRIPTION" \
      io.k8s.description="$DESCRIPTION" \
      maintainer="opensource-collection-team@sumologic.com"

COPY --from=builder \
    /bin/node_exporter \
    /bin/node_exporter
ADD https://raw.githubusercontent.com/prometheus/node_exporter/v${UPSTREAM_VERSION}/LICENSE \
    /licenses/LICENSE

EXPOSE      9100
USER        nobody
ENTRYPOINT  [ "/bin/node_exporter" ]
