FROM registry.access.redhat.com/ubi9/ubi:9.6

LABEL name="Busybox Base image" \
    vendor="Sumo Logic" \
    version="1.37.0" \
    release="1.37.0" \
    summary="UBI based Busybox base image" \
    description="UBI based Busybox base image." \
    maintainer="opensource-collection-team@sumologic.com"

ADD LICENSE /licenses/
USER 65532:65532

ENTRYPOINT ["/bin/bash"]