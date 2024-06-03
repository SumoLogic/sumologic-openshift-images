ARG UPSTREAM_VERSION

## Use original image to copy files from
## ref: https://github.com/SumoLogic/opentelemetry-collector-contrib/blob/5fd8754cbf0b9d88309cba2c9fee4a5342f3ed95/cmd/otelcontribcol/Dockerfile
FROM public.ecr.aws/sumologic/autoinstrumentation-java:${UPSTREAM_VERSION} as builder

## Build RedHat compliant image
FROM registry.access.redhat.com/ubi9/ubi:9.4
ARG UPSTREAM_VERSION
ARG RELEASE

LABEL name="OpenTelemetry Java Automatic Instrumentation" \
    vendor="Sumo Logic" \
    version="${UPSTREAM_VERSION}" \
    release="${RELEASE}" \
    summary="UBI based OpenTelemetry Java Automatic Instrumentation image" \
    description="OpenTelemetry Java Automatic Instrumentation provides a Java agent JAR that can be attached to any Java 8+ application and dynamically injects bytecode to capture telemetry from a number of popular libraries and frameworks." \
    maintainer="opensource-collection-team@sumologic.com"

ADD https://raw.githubusercontent.com/open-telemetry/opentelemetry-java-instrumentation/v${UPSTREAM_VERSION}/LICENSE \
    /licenses/LICENSE

ARG USER_UID=10001
USER ${USER_UID}

COPY --from=builder /javaagent.jar /

CMD ["sh"]
