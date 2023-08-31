## Use original image to copy files from
## ref: https://github.com/open-telemetry/opentelemetry-operator/blob/v0.63.1/Dockerfile

FROM ghcr.io/open-telemetry/opentelemetry-operator/opentelemetry-operator:0.63.1 as builder


## Build RedHat compliant image
FROM registry.access.redhat.com/ubi8/ubi:8.8

WORKDIR /
COPY --from=builder  /manager .

ENV SUMMARY="UBI based opentelemetry operator" \
    DESCRIPTION="OpenTelemetry Operator manages OpenTelemetry Collector and auto-instrumentation of the workloads using OpenTelemetry instrumentation libraries"

LABEL name="opentelemetry-operator" \
      vendor="Sumo Logic" \
      version="0.63.1" \
      release="1" \
      summary="$SUMMARY" \
      description="$DESCRIPTION" \
      io.k8s.description="$DESCRIPTION" \
      maintainer="collection@sumologic.com"

ADD https://raw.githubusercontent.com/open-telemetry/opentelemetry-operator/v0.63.1/LICENSE \
    /licenses/LICENSE

USER 65532:65532

ENTRYPOINT ["/manager"]
