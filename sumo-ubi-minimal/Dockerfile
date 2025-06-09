ARG UPSTREAM_VERSION='9.6-1745855087'

FROM registry.access.redhat.com/ubi9/ubi-minimal:${UPSTREAM_VERSION}

ARG UPSTREAM_VERSION
ARG RELEASE

LABEL name="Sumo Logic Universal Base Image Minimal" \
      vendor="Sumo Logic" \
      version="${UPSTREAM_VERSION}" \
      release="${RELEASE}" \
      summary="Sumo Logic Universal Base Image Minimal" \
      description="The Universal Base Image Minimal is a stripped down image that uses microdnf as a package manager." \
      maintainer="opensource-collection-team@sumologic.com"

ADD https://www.apache.org/licenses/LICENSE-2.0.txt \
      /licenses/LICENSE
