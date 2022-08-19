## Use original image to copy files from
## ref: https://github.com/influxdata/telegraf-operator/blob/v1.3.5/Dockerfile
FROM quay.io/influxdb/telegraf-operator:v1.3.5 as builder

## Build RedHat compliant image
FROM registry.access.redhat.com/ubi8/ubi-minimal:8.6

ENV SUMMARY="UBI based telegraf-operator" \
    DESCRIPTION="The telegraf facilitates management of telegraf CRDs in Kubernetes."

LABEL name="telegraf-operator" \
      vendor="Sumo Logic" \
      version="1.3.5" \
      release="2" \
      summary="$SUMMARY" \
      description="$DESCRIPTION" \
      io.k8s.description="$DESCRIPTION" \
      maintainer="collection@sumologic.com"

WORKDIR /
COPY --from=builder /manager .

ADD https://raw.githubusercontent.com/influxdata/telegraf-operator/v1.3.5/LICENSE \
    /licenses/LICENSE

USER nobody
ENTRYPOINT ["/manager"]
