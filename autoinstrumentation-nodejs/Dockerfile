ARG UPSTREAM_VERSION

## Use original image to copy files from
## ref: https://github.com/SumoLogic/opentelemetry-collector-contrib/blob/5fd8754cbf0b9d88309cba2c9fee4a5342f3ed95/cmd/otelcontribcol/Dockerfile
FROM public.ecr.aws/sumologic/autoinstrumentation-nodejs:${UPSTREAM_VERSION} as builder

## Build RedHat compliant image
FROM registry.access.redhat.com/ubi9/ubi:9.6
ARG UPSTREAM_VERSION
ARG RELEASE

LABEL name="OpenTelemetry Node JS Automatic Instrumentation" \
    vendor="Sumo Logic" \
    version="${UPSTREAM_VERSION}" \
    release="${RELEASE}" \
    summary="UBI based OpenTelemetry Node JS Automatic Instrumentation image" \
    description="OpenTelemetry Node JS Automatic Instrumentation adds instrumentation to .NET applications without having to modify their source code." \
    maintainer="opensource-collection-team@sumologic.com"

ADD https://raw.githubusercontent.com/open-telemetry/opentelemetry-js-contrib/auto-instrumentations-node-v${UPSTREAM_VERSION}/LICENSE \
    /licenses/LICENSE

ARG USER_UID=10001
USER ${USER_UID}

COPY --from=builder /autoinstrumentation /autoinstrumentation

CMD ["sh"]
