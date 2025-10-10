ARG UPSTREAM_VERSION
## Use original image to copy files from
## ref: https://github.com/brancz/kube-rbac-proxy/blob/${UPSTREAM_VERSION}/Dockerfile
FROM public.ecr.aws/sumologic/kube-rbac-proxy:v${UPSTREAM_VERSION} as builder

## Build RedHat compliant image
FROM registry.access.redhat.com/ubi9/ubi:9.6
ARG UPSTREAM_VERSION
ARG RELEASE

ENV SUMMARY="UBI based Kube RBAC Proxy image" \
    DESCRIPTION="The kube-rbac-proxy is a small HTTP proxy for a single upstream, that can perform RBAC authorization against the Kubernetes API using SubjectAccessReview."

LABEL name="Kube RBAC Proxy" \
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
