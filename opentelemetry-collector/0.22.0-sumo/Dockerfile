## Use original image to copy files from
## ref: https://github.com/SumoLogic/opentelemetry-collector-contrib/blob/5fd8754cbf0b9d88309cba2c9fee4a5342f3ed95/cmd/otelcontribcol/Dockerfile
FROM public.ecr.aws/sumologic/opentelemetry-collector:0.22.0-sumo as builder

## Build RedHat compliant image
FROM registry.access.redhat.com/ubi8/ubi-minimal:8.4

LABEL name="Opentelemetry-collector" \
      vendor="Sumo Logic" \
      version="0.22.0-sumo" \
      release="1" \
      summary="UBI based opentelemetry-collector" \
      description="The OpenTelemetry Collector offers a vendor-agnostic implementation on how to receive, process and export telemetry data." \
      maintainer="collection@sumologic.com"

ADD https://raw.githubusercontent.com/SumoLogic/opentelemetry-collector-contrib/5fd8754cbf0b9d88309cba2c9fee4a5342f3ed95/LICENSE \
    /licenses/LICENSE

ARG USER_UID=10001
USER ${USER_UID}

COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=builder /otelcontribcol /otelcontribcol
EXPOSE 55680 55679
ENTRYPOINT ["/otelcontribcol"]
CMD ["--config", "/etc/otel/config.yaml"]
