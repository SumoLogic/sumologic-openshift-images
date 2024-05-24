ARG UPSTREAM_VERSION
ARG UBI_IMAGE=registry.access.redhat.com/ubi8/ubi:8.6

## Use original image to copy files from
## ref: https://github.com/influxdata/telegraf-operator/blob/v1.3.10/Dockerfile
FROM public.ecr.aws/sumologic/telegraf-operator:v${UPSTREAM_VERSION} as builder

## Build RedHat compliant image
FROM ${UBI_IMAGE}
ARG UPSTREAM_VERSION
ARG RELEASE

ENV SUMMARY="UBI based telegraf-operator" \
    DESCRIPTION="The telegraf facilitates management of telegraf CRDs in Kubernetes."

LABEL name="telegraf-operator" \
    vendor="Sumo Logic" \
    version="${UPSTREAM_VERSION}" \
    release="${RELEASE}" \
    summary="$SUMMARY" \
    description="$DESCRIPTION" \
    io.k8s.description="$DESCRIPTION" \
    maintainer="opensource-collection-team@sumologic.com"

WORKDIR /
COPY --from=builder /manager .

ADD https://raw.githubusercontent.com/influxdata/telegraf-operator/v${UPSTREAM_VERSION}/LICENSE \
    /licenses/LICENSE

USER nobody
ENTRYPOINT ["/manager"]
