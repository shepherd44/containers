# Replacement for docker.io/bitnamilegacy/mongodb-exporter.
#
# Same layout contract as the bitnami image -- the binary lives at
# /opt/bitnami/mongodb-exporter/bin/mongodb_exporter and is symlinked to
# /bin/mongodb_exporter, which is the path the mongodb-sharded chart calls.
# The binary itself is Percona's official release instead of a stacksmith build.
FROM docker.io/bitnami/minideb:bookworm

ARG TARGETARCH
ARG EXPORTER_VERSION=0.53.0

ENV HOME="/" \
    OS_ARCH="${TARGETARCH:-amd64}" \
    OS_FLAVOUR="debian-12" \
    OS_NAME="linux" \
    APP_VERSION="${EXPORTER_VERSION}" \
    BITNAMI_APP_NAME="mongodb-exporter" \
    PATH="/opt/bitnami/mongodb-exporter/bin:$PATH"

SHELL ["/bin/bash", "-o", "errexit", "-o", "nounset", "-o", "pipefail", "-c"]

RUN install_packages ca-certificates curl procps

RUN ARCH="${TARGETARCH:-amd64}" ; \
    NAME="mongodb_exporter-${EXPORTER_VERSION}.linux-${ARCH}" ; \
    URL="https://github.com/percona/mongodb_exporter/releases/download/v${EXPORTER_VERSION}/${NAME}.tar.gz" ; \
    mkdir -p /opt/bitnami/mongodb-exporter/bin ; \
    curl -sSLf "${URL}" -o /tmp/exporter.tar.gz ; \
    tar -xzf /tmp/exporter.tar.gz -C /tmp ; \
    install -m 0755 "/tmp/${NAME}/mongodb_exporter" /opt/bitnami/mongodb-exporter/bin/mongodb_exporter ; \
    install -m 0644 "/tmp/${NAME}/LICENSE" /opt/bitnami/mongodb-exporter/LICENSE ; \
    rm -rf /tmp/exporter.tar.gz "/tmp/${NAME}" ; \
    ln -sf /opt/bitnami/mongodb-exporter/bin/mongodb_exporter /bin/mongodb_exporter

# A silently mismatched binary defeats the point of pinning the version.
RUN /bin/mongodb_exporter --version 2>&1 | grep -q "${EXPORTER_VERSION}"

RUN apt-get update && apt-get upgrade -y && \
    apt-get clean && rm -rf /var/lib/apt/lists /var/cache/apt/archives

RUN chmod g+rwX /opt/bitnami
RUN uninstall_packages curl
RUN find / -perm /6000 -type f -exec chmod a-s {} \; || true

EXPOSE 9216
WORKDIR /opt/bitnami/mongodb-exporter
USER 1001
ENTRYPOINT [ "mongodb_exporter" ]
