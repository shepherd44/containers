# Replacement for docker.io/bitnamilegacy/os-shell.
#
# Bitnami's os-shell is minideb plus a handful of helper binaries pulled from
# their stacksmith CDN. We keep the base and the shell tooling, and drop the
# stacksmith dependency -- that CDN is exactly what we are trying not to rely on.
# yq comes from its own upstream instead.
FROM docker.io/bitnami/minideb:bookworm

ARG TARGETARCH
ARG YQ_VERSION=4.53.3

ENV HOME="/" \
    OS_ARCH="${TARGETARCH:-amd64}" \
    OS_FLAVOUR="debian-12" \
    OS_NAME="linux" \
    APP_VERSION="12" \
    BITNAMI_APP_NAME="os-shell" \
    PATH="/opt/bitnami/common/bin:$PATH"

SHELL ["/bin/bash", "-o", "errexit", "-o", "nounset", "-o", "pipefail", "-c"]

RUN install_packages ca-certificates curl jq procps

RUN ARCH="${TARGETARCH:-amd64}" ; \
    mkdir -p /opt/bitnami/common/bin ; \
    curl -sSLf "https://github.com/mikefarah/yq/releases/download/v${YQ_VERSION}/yq_linux_${ARCH}" \
      -o /opt/bitnami/common/bin/yq ; \
    chmod +x /opt/bitnami/common/bin/yq ; \
    yq --version | grep -q "${YQ_VERSION}"

RUN apt-get update && apt-get upgrade -y && \
    apt-get clean && rm -rf /var/lib/apt/lists /var/cache/apt/archives

RUN useradd -r -u 1001 -g root os-shell
RUN find / -perm /6000 -type f -exec chmod a-s {} \; || true

USER 1001
