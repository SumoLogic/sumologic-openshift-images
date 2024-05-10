ARG UPSTREAM_VERSION
ARG RELEASE
ARG UBI_IMAGE=registry.access.redhat.com/ubi8/ubi:8.6
## Use original image to copy files from
## ref: https://github.com/brancz/kube-rbac-proxy/blob/${UPSTREAM_VERSION}/Dockerfile
FROM public.ecr.aws/sumologic/kube-rbac-proxy:v${UPSTREAM_VERSION} as builder

## Build RedHat compliant image
FROM ${UBI_IMAGE}
ARG UPSTREAM_VERSION

ENV SUMMARY="UBI based kube-rbac-proxy" \
    DESCRIPTION="The kube-rbac-proxy is a small HTTP proxy for a single upstream, that can perform RBAC authorization against the Kubernetes API using SubjectAccessReview."

LABEL name="Kube-rbac-proxy" \
    vendor="Sumo Logic" \
    version="$UPSTREAM_VERSION" \
    release="$RELEASE" \
    summary="$SUMMARY" \
    description="$DESCRIPTION" \
    io.k8s.description="$DESCRIPTION" \
    maintainer="opensource-collection-team@sumologic.com"

RUN yum update -y \
    && yum install -y ca-certificates

COPY --from=builder \
    /usr/local/bin/kube-rbac-proxy \
    /usr/local/bin/kube-rbac-proxy
ADD https://raw.githubusercontent.com/brancz/kube-rbac-proxy/v${UPSTREAM_VERSION}/LICENSE \
    /licenses/LICENSE

ENTRYPOINT ["/usr/local/bin/kube-rbac-proxy"]

USER 65532:65532
EXPOSE 8080
