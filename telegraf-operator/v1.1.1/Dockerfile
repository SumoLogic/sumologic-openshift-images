## Use original image to copy files from
## ref: https://github.com/influxdata/telegraf-operator/blob/v1.1.1/Dockerfile
FROM quay.io/influxdb/telegraf-operator:v1.1.1 as builder

## Build RedHat compliant image
FROM registry.access.redhat.com/ubi8/ubi-minimal:latest

LABEL name="telegraf-operator" \
      vendor="Sumo Logic" \
      version="1.1.1" \
      release="1" \
      summary="UBI based telegraf-operator" \
      description="The telegraf facilitates management of telegraf CRDs in Kubernetes." \
      maintainer="collection@sumologic.com"

WORKDIR /
COPY --from=builder /manager .

ADD https://raw.githubusercontent.com/influxdata/telegraf-operator/79b6434e7a3655f9f65d9552d2c420a54026323d/LICENSE \
    /licenses/LICENSE

ENTRYPOINT ["/manager"]
