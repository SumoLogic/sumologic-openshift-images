## Use original image to copy files from
## ref: https://github.com/brancz/kube-rbac-proxy/blob/v0.8.0/Dockerfile
FROM gcr.io/kubebuilder/kube-rbac-proxy:v0.8.0 as builder

## Build RedHat compliant image
FROM registry.access.redhat.com/ubi8/ubi:8.6

ENV SUMMARY="UBI based kube-rbac-proxy" \
    DESCRIPTION="The kube-rbac-proxy is a small HTTP proxy for a single upstream, that can perform RBAC authorization against the Kubernetes API using SubjectAccessReview."

LABEL name="Kube-rbac-proxy" \
      vendor="Sumo Logic" \
      version="0.8.0" \
      release="2" \
      summary="$SUMMARY" \
      description="$DESCRIPTION" \
      io.k8s.description="$DESCRIPTION" \
      maintainer="collection@sumologic.com"

RUN yum update -y \
 && yum install -y ca-certificates

COPY --from=builder \
    /usr/local/bin/kube-rbac-proxy \
    /usr/local/bin/kube-rbac-proxy
ADD https://raw.githubusercontent.com/brancz/kube-rbac-proxy/v0.8.0/LICENSE \
    /licenses/LICENSE

ENTRYPOINT ["/usr/local/bin/kube-rbac-proxy"]

USER 65532:65532
EXPOSE 8080
