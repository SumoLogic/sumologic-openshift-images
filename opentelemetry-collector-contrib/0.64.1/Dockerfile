## Use original image to copy files from
## ref: https://github.com/open-telemetry/opentelemetry-collector-releases/blob/v0.64.1/distributions/otelcol-contrib/Dockerfile

FROM otel/opentelemetry-collector-contrib:0.64.1 as builder

## Build RedHat compliant image
FROM registry.access.redhat.com/ubi8/ubi:8.8

WORKDIR /
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=builder /etc/otelcol-contrib/config.yaml /etc/otelcol-contrib/config.yaml
COPY --from=builder  /otelcol-contrib .

ENV SUMMARY="UBI based opentelemetry-collector-contrib" \
    DESCRIPTION="OpenTelemetry Collector - otelcol-contrib distribution"

LABEL name="opentelemetry-collector-contrib" \
      vendor="Sumo Logic" \
      version="0.64.1" \
      release="1" \
      summary="$SUMMARY" \
      description="$DESCRIPTION" \
      io.k8s.description="$DESCRIPTION" \
      maintainer="collection@sumologic.com"

ADD https://raw.githubusercontent.com/open-telemetry/opentelemetry-collector-releases/v0.64.1/LICENSE \
    /licenses/LICENSE

ENTRYPOINT ["/otelcol-contrib"]
CMD ["--config", "/etc/otelcol-contrib/config.yaml"]
EXPOSE 4317 55678 55679
