ARG UPSTREAM_VERSION
## Use original image to copy files from
## ref: https://github.com/open-telemetry/opentelemetry-operator/blob/v0.63.1/Dockerfile

FROM public.ecr.aws/sumologic/opentelemetry-operator:${UPSTREAM_VERSION} as builder

## Build RedHat compliant image
FROM registry.access.redhat.com/ubi9/ubi:9.5
ARG UPSTREAM_VERSION
ARG RELEASE

WORKDIR /
COPY --from=builder  /manager .

ENV SUMMARY="UBI based OpenTelemetry Operator image" \
    DESCRIPTION="OpenTelemetry Operator manages OpenTelemetry Collector and auto-instrumentation of the workloads using OpenTelemetry instrumentation libraries"

LABEL name="OpenTelemetry Operator" \
    vendor="Sumo Logic" \
    version="${UPSTREAM_VERSION}" \
    release="${RELEASE}" \
    summary="$SUMMARY" \
    description="$DESCRIPTION" \
    io.k8s.description="$DESCRIPTION" \
    maintainer="opensource-collection-team@sumologic.com"

ADD https://raw.githubusercontent.com/open-telemetry/opentelemetry-operator/v${UPSTREAM_VERSION}/LICENSE \
    /licenses/LICENSE

USER 65532:65532

ENTRYPOINT ["/manager"]
