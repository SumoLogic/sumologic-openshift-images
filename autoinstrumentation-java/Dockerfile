ARG UPSTREAM_VERSION
ARG UBI_IMAGE=registry.access.redhat.com/ubi8/ubi:8.6

## Use original image to copy files from
## ref: https://github.com/SumoLogic/opentelemetry-collector-contrib/blob/5fd8754cbf0b9d88309cba2c9fee4a5342f3ed95/cmd/otelcontribcol/Dockerfile
FROM public.ecr.aws/sumologic/autoinstrumentation-java:${UPSTREAM_VERSION} as builder

## Build RedHat compliant image
FROM ${UBI_IMAGE}
ARG UPSTREAM_VERSION
ARG RELEASE

LABEL name="Autoinstrumentation-java" \
    vendor="Sumo Logic" \
    version="${UPSTREAM_VERSION}" \
    release="${RELEASE}" \
    summary="UBI based OpenTelemetry Java Automatic Instrumentation " \
    description="Kubernetes Operator for OpenTelemetry Collector" \
    maintainer="opensource-collection-team@sumologic.com"

ADD https://raw.githubusercontent.com/open-telemetry/opentelemetry-java-instrumentation/v${UPSTREAM_VERSION}/LICENSE \
    /licenses/LICENSE

ARG USER_UID=10001
USER ${USER_UID}

COPY --from=builder /javaagent.jar /

CMD ["sh"]
