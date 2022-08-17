## Use original image to copy files from
## ref: https://github.com/open-telemetry/opentelemetry-operator/blob/v0.51.0/Dockerfile

FROM ghcr.io/open-telemetry/opentelemetry-operator/opentelemetry-operator:0.51.0 as builder


## Build RedHat compliant image
FROM registry.access.redhat.com/ubi8/ubi:8.6

WORKDIR /
COPY --from=builder  /manager .
LABEL name="opentelemetry-operator" \
      vendor="Sumo Logic" \
      version="0.51.0" \
      release="1" \
      summary="UBI based opentelemetry operator" \
      description="OpenTelemetry Operator manages OpenTelemetry Collector and auto-instrumentation of the workloads using OpenTelemetry instrumentation libraries" \
      maintainer="collection@sumologic.com"

ADD https://raw.githubusercontent.com/open-telemetry/opentelemetry-operator/v0.51.0/LICENSE \
    /licenses/LICENSE

USER 65532:65532

ENTRYPOINT ["/manager"]
