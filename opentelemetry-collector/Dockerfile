ARG UPSTREAM_VERSION

## Use original image to copy files from
## ref: https://github.com/SumoLogic/opentelemetry-collector-contrib/blob/5fd8754cbf0b9d88309cba2c9fee4a5342f3ed95/cmd/otelcontribcol/Dockerfile
FROM otel/opentelemetry-collector-contrib:${UPSTREAM_VERSION} as builder

## Build RedHat compliant image
FROM registry.access.redhat.com/ubi9/ubi:9.6
ARG UPSTREAM_VERSION
ARG RELEASE

LABEL name="Opentelemetry-collector" \
    vendor="Sumo Logic" \
    version="${UPSTREAM_VERSION}" \
    release="${RELEASE}" \
    summary="UBI based opentelemetry-collector" \
    description="The OpenTelemetry Collector offers a vendor-agnostic implementation on how to receive, process and export telemetry data." \
    maintainer="collection@sumologic.com"

ADD https://raw.githubusercontent.com/open-telemetry/opentelemetry-collector/v${UPSTREAM_VERSION}/LICENSE \
    /licenses/LICENSE

ARG USER_UID=10001
USER ${USER_UID}

COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=builder /otelcol-contrib /otelcontribcol
EXPOSE 55680 55679
ENTRYPOINT ["/otelcontribcol"]
CMD ["--config", "/etc/otel/config.yaml"]
