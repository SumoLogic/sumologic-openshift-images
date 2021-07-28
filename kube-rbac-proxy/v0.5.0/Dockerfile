## Use original image to copy files from
## ref: https://github.com/brancz/kube-rbac-proxy/blob/a6da502b4a4abad511cb1afa87b0b52c74a89987/Dockerfile
FROM gcr.io/kubebuilder/kube-rbac-proxy:v0.5.0 as builder

## Build RedHat compliant image
FROM registry.access.redhat.com/ubi8/ubi:8.4

LABEL name="Kube-rbac-proxy" \
      vendor="Sumo Logic" \
      version="0.5.0" \
      release="1" \
      summary="UBI based kube-rbac-proxy" \
      description="The kube-rbac-proxy is a small HTTP proxy for a single upstream, that can perform RBAC authorization against the Kubernetes API using SubjectAccessReview." \
      maintainer="collection@sumologic.com"

RUN yum update -y \
 && yum install -y ca-certificates

COPY --from=builder \
    /kube-rbac-proxy \
    /
ADD https://raw.githubusercontent.com/brancz/kube-rbac-proxy/a6da502b4a4abad511cb1afa87b0b52c74a89987/LICENSE \
    /licenses/LICENSE

ENTRYPOINT ["./kube-rbac-proxy"]
EXPOSE 8080
