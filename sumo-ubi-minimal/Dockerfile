ARG UPSTREAM_VERSION

FROM registry.access.redhat.com/ubi9/ubi-minimal:${UPSTREAM_VERSION}

ARG UPSTREAM_VERSION
ARG RELEASE

LABEL name="sumo-ubi9-minimal" \
      vendor="Sumo Logic" \
      version="${UPSTREAM_VERSION}" \
      release="${RELEASE}" \
      summary="Provides the latest release of the minimal Red Hat Universal Base Image 8 prepared by Sumo Logic." \
      description="The Universal Base Image Minimal is a stripped down image that uses microdnf as a package manager." \
      maintainer="opensource-collection-team@sumologic.com"

ADD https://www.apache.org/licenses/LICENSE-2.0.txt \
    /licenses/LICENSE
