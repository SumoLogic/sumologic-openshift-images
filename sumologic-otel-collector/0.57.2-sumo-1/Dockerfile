## Use original image to copy files from
## ref: https://github.com/SumoLogic/sumologic-otel-collector/blob/v0.57.2-sumo-1/Dockerfile
FROM public.ecr.aws/sumologic/sumologic-otel-collector:0.57.2-sumo-1 as builder

## Build RedHat compliant image
FROM registry.access.redhat.com/ubi8/ubi-minimal:8.6

ENV SUMMARY="UBI based sumologic-otel-collector" \
    DESCRIPTION="Sumo Logic Distribution for OpenTelemetry Collector is a Sumo Logic-supported distribution of the OpenTelemetry Collector. It is a single agent to send logs, metrics and traces to Sumo Logic."

LABEL name="sumologic-otel-collector" \
      vendor="Sumo Logic" \
      version="0.57.2-sumo-1" \
      release="4" \
      summary="$SUMMARY" \
      description="$DESCRIPTION" \
      io.k8s.description="$DESCRIPTION" \
      maintainer="collection@sumologic.com"

ADD https://raw.githubusercontent.com/SumoLogic/sumologic-otel-collector/v0.57.2-sumo-1/LICENSE \
    /licenses/LICENSE

ARG USER_UID=10001
USER ${USER_UID}
ENV HOME /etc/otel/

# copy journalctl and it's dependencies as base structure
COPY --from=builder / /
COPY --from=builder --chown=${USER_UID}:${USER_UID} /etc/otel/ /etc/otel/
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=builder /otelcol-sumo /otelcol-sumo
ENTRYPOINT ["/otelcol-sumo"]
CMD ["--config", "/etc/otel/config.yaml"]
