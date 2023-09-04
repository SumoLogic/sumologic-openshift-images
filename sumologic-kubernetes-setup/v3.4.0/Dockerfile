FROM registry.access.redhat.com/ubi8/ubi:8.8

ENV SUMMARY="SumoLogic k8s setup job image" \
    DESCRIPTION="This image is used to setup the kubernetes cluster and SumoLogic environment before installing SumoLogic collection helm chart"
### Required Labels #####
LABEL name="SumoLogic Kubernetes Setup" \
      vendor="Sumo Logic" \
      version="3.4.0" \
      release="4" \
      summary="$SUMMARY" \
      description="$DESCRIPTION" \
      io.k8s.description="$DESCRIPTION" \
      maintainer="collection@sumologic.com"

### Required End User Agreements ###
ADD https://raw.githubusercontent.com/SumoLogic/sumologic-kubernetes-setup/v3.4.0/LICENSE \
    /licenses/LICENSE

## Original image ref: https://github.com/SumoLogic/sumologic-kubernetes-setup/blob/v3.4.0/Dockerfile
ENV TERRAFORM_VERSION=1.2.7
ENV COLLECTION_VERSION=c251098963278e02c012cf8471d0b7a162efcb74
ENV MONITORS_VERSION=v1.0.7
ARG TARGETPLATFORM

RUN yum update -y \
 && yum install unzip git jq -y \
 && yum clean all \
 && if [ "${TARGETPLATFORM}" = "linux/amd64" ]; then TERRAFORM_PLATFORM="linux_amd64"; fi; \
    if [ "${TARGETPLATFORM}" = "linux/arm/v7" ]; then TERRAFORM_PLATFORM="linux_arm"; fi; \
    if [ "${TARGETPLATFORM}" = "linux/arm64" ]; then TERRAFORM_PLATFORM="linux_arm64"; fi; \
    if [ "${TERRAFORM_PLATFORM}" = "" ]; then TERRAFORM_PLATFORM="${TARGETPLATFORM}"; fi \
 && curl -o terraform.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_${TERRAFORM_PLATFORM}.zip \
 && unzip terraform.zip \
 && mv terraform /usr/local/bin/ \
 && rm terraform.zip \
 && groupdel input \
 && userdel systemd-coredump \
 && groupadd -g 999 setup \
 && useradd -u 999 -g setup setup \
 && mkdir /terraform /scripts /monitors \
 && chown -R setup:setup /terraform /scripts /monitors

USER setup
RUN cd /terraform/ \
 && curl -O https://raw.githubusercontent.com/SumoLogic/sumologic-kubernetes-collection/${COLLECTION_VERSION}/deploy/helm/sumologic/conf/setup/main.tf \
 && terraform init \
 && rm main.tf
RUN cd /monitors/ \
 && git clone https://github.com/SumoLogic/terraform-sumologic-sumo-logic-monitor.git \
 && cd terraform-sumologic-sumo-logic-monitor \
 && git checkout ${MONITORS_VERSION} \
 && cd .. \
 && cp terraform-sumologic-sumo-logic-monitor/monitor_packages/kubernetes/* . \
 && rm -rf terraform-sumologic-sumo-logic-monitor

ARG BUILD_TAG=latest
ENV TAG=$BUILD_TAG

WORKDIR /terraform/
