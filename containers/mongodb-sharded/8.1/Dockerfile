# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# ⚠️ bitnami 는 mongodb-sharded 8.1 을 만든 적이 없다.
#    upstream 에 존재한 시리즈는 7.0 / 8.0 / 8.2 / 8.3 뿐이다. 8.1 은 rapid release 라
#    bitnami 가 건너뛰었다. 그래서 이 이미지의 스캐폴딩은 **8.2 것을 차용**한다:
#      bitnami/containers@350503ffe7 (8.2.7-debian-12-r2, 2026-05-08)
#    스크립트가 8.1 서버를 전제로 검증된 적이 없다는 뜻이므로, 8.0/8.2 보다 먼저
#    실환경 검증이 필요하다.
#
# ⚠️ 8.1 은 rapid release 라 LTS 가 아니다. 다음 rapid release(8.2)가 나온 시점에
#    이미 지원이 끝났다. 운영에 올릴 후보가 아니라 재현 테스트용으로만 쓸 것.
#    운영은 8.0(LTS) 또는 8.2 를 쓴다.
#
# 스캐폴딩(스크립트·conf.default·templates·database-tools·mongosh)은 8.2.7 스택스미스
# tarball 을 쓰고, **서버 바이너리(mongod/mongos)만** MongoDB 공식 8.1.x 로 덮어쓴다.
# 자세한 배경은 ../README.md 참조.
#
# ⚠️ 공식 debian12 빌드는 x86_64 만 있다 (aarch64 는 403). 다른 arch 는 빌드를
#    실패시킨다.

FROM docker.io/bitnami/minideb:bookworm

ARG DOWNLOADS_URL="downloads.bitnami.com/files/stacksmith"
ARG TARGETARCH

# 8.2 계열 스캐폴딩을 빌려 쓴다 (8.1 용 tarball 은 존재하지 않는다).
ARG BITNAMI_SCAFFOLD_VERSION="8.2.7-2"
# 실제로 실행될 서버 버전. 이 값만 바꾸면 된다.
ARG MONGODB_VERSION="8.1.3"

LABEL org.opencontainers.image.base.name="docker.io/bitnami/minideb:bookworm" \
      org.opencontainers.image.description="MongoDB sharded 8.1 (bitnami 8.2 scaffolding + upstream server binaries; 8.1 is a rapid release, not LTS)" \
      org.opencontainers.image.documentation="https://github.com/bitnami/containers/tree/main/bitnami/mongodb-sharded/README.md" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/350503ffe7/bitnami/mongodb-sharded/8.2/debian-12" \
      org.opencontainers.image.title="mongodb-sharded" \
      org.opencontainers.image.vendor="Broadcom, Inc." \
      org.opencontainers.image.version="${MONGODB_VERSION}"

ENV HOME="/" \
    OS_ARCH="${TARGETARCH:-amd64}" \
    OS_FLAVOUR="debian-12" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "errexit", "-o", "nounset", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl libbrotli1 libcom-err2 libcurl4 libffi8 libgcc-s1 libgmp10 libgnutls30 libgssapi-krb5-2 libhogweed6 libidn2-0 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.5-0 libnettle8 libnghttp2-14 libp11-kit0 libpsl5 librtmp1 libsasl2-2 libssh2-1 libssl3 libtasn1-6 libunistring2 libzstd1 numactl procps zlib1g
RUN --mount=type=secret,id=downloads_url,env=SECRET_DOWNLOADS_URL \
    DOWNLOADS_URL=${SECRET_DOWNLOADS_URL:-${DOWNLOADS_URL}} ; \
    mkdir -p /tmp/bitnami/pkg/cache/ ; cd /tmp/bitnami/pkg/cache/ || exit 1 ; \
    COMPONENTS=( \
      "yq-4.53.2-1-linux-${OS_ARCH}-debian-12" \
      "wait-for-port-1.0.10-10-linux-${OS_ARCH}-debian-12" \
      "render-template-1.0.9-165-linux-${OS_ARCH}-debian-12" \
      "mongodb-shell-2.8.3-0-linux-${OS_ARCH}-debian-12" \
      "mongodb-${BITNAMI_SCAFFOLD_VERSION}-linux-${OS_ARCH}-debian-12" \
    ) ; \
    for COMPONENT in "${COMPONENTS[@]}"; do \
      if [ ! -f "${COMPONENT}.tar.gz" ]; then \
        curl -SsLf "https://${DOWNLOADS_URL}/${COMPONENT}.tar.gz" -O ; \
        curl -SsLf "https://${DOWNLOADS_URL}/${COMPONENT}.tar.gz.sha256" -O ; \
      fi ; \
      sha256sum -c "${COMPONENT}.tar.gz.sha256" ; \
      tar -zxf "${COMPONENT}.tar.gz" -C /opt/bitnami --strip-components=2 --no-same-owner ; \
      rm -rf "${COMPONENT}".tar.gz{,.sha256} ; \
    done

# ── 서버 바이너리를 공식 배포본으로 교체 ──────────────────────────────────
# 마지막 grep 이 검증이다. 덮어쓰기가 실패하면 빌드가 여기서 멈춘다.
RUN if [ "${OS_ARCH}" != "amd64" ]; then \
      echo "ERROR: upstream debian12 tarball is x86_64 only; OS_ARCH=${OS_ARCH} unsupported" >&2 ; \
      exit 1 ; \
    fi ; \
    cd /tmp || exit 1 ; \
    TARBALL="mongodb-linux-x86_64-debian12-${MONGODB_VERSION}.tgz" ; \
    curl -SsLf "https://fastdl.mongodb.org/linux/${TARBALL}" -O ; \
    curl -SsLf "https://fastdl.mongodb.org/linux/${TARBALL}.sha256" -o "${TARBALL}.sha256" ; \
    echo "$(tr -d '\n' < "${TARBALL}.sha256")  ${TARBALL}" | sha256sum -c - ; \
    tar -zxf "${TARBALL}" ; \
    SRC="/tmp/mongodb-linux-x86_64-debian12-${MONGODB_VERSION}/bin" ; \
    install -m 0755 "${SRC}/mongod" /opt/bitnami/mongodb/bin/mongod ; \
    install -m 0755 "${SRC}/mongos" /opt/bitnami/mongodb/bin/mongos ; \
    rm -rf "/tmp/${TARBALL}" "/tmp/${TARBALL}.sha256" "/tmp/mongodb-linux-x86_64-debian12-${MONGODB_VERSION}" ; \
    /opt/bitnami/mongodb/bin/mongod --version | head -1 ; \
    /opt/bitnami/mongodb/bin/mongod --version | head -1 | grep -q "v${MONGODB_VERSION}" ; \
    /opt/bitnami/mongodb/bin/mongos --version | head -1 | grep -q "v${MONGODB_VERSION}"

RUN apt-get update && apt-get upgrade -y && \
    apt-get clean && rm -rf /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN find / -perm /6000 -type f -exec chmod a-s {} \; || true
RUN ln -s /opt/bitnami/scripts/mongodb-sharded/entrypoint.sh /entrypoint.sh
RUN ln -s /opt/bitnami/scripts/liblog.sh /liblog.sh
RUN ln -s /opt/bitnami/scripts/mongodb-sharded/run.sh /run.sh

COPY rootfs /
RUN /opt/bitnami/scripts/mongodb-sharded/postunpack.sh
ENV APP_VERSION="${MONGODB_VERSION}" \
    BITNAMI_APP_NAME="mongodb-sharded" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/mongodb/bin:$PATH"

EXPOSE 27017

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/mongodb-sharded/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/mongodb-sharded/run.sh" ]
