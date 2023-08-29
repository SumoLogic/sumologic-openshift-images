## Use original image to copy files from
## ref: https://github.com/influxdata/telegraf-operator/blob/v1.3.10/Dockerfile
FROM quay.io/influxdb/telegraf-operator:v1.3.10 as builder

## Build RedHat compliant image
FROM registry.access.redhat.com/ubi8-minimal:8.8

ENV SUMMARY="UBI based telegraf-operator" \
    DESCRIPTION="The telegraf facilitates management of telegraf CRDs in Kubernetes."

LABEL name="telegraf-operator" \
      vendor="Sumo Logic" \
      version="1.3.10" \
      release="1" \
      summary="$SUMMARY" \
      description="$DESCRIPTION" \
      io.k8s.description="$DESCRIPTION" \
      maintainer="collection@sumologic.com"

WORKDIR /
COPY --from=builder /manager .

ADD https://raw.githubusercontent.com/influxdata/telegraf-operator/v1.3.10/LICENSE \
    /licenses/LICENSE

USER nobody
ENTRYPOINT ["/manager"]
