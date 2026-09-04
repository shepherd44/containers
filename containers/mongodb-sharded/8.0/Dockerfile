# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# 원본: bitnami/containers@657585595c
#   bitnami/mongodb-sharded/8.0/debian-12/Dockerfile (8.0.13-debian-12-r1, 2025-09-07)
# 그 커밋이 bitnami 가 8.0 계열에 올린 마지막 릴리스이고, 2025-09-19 (48a109547d) 에
# 8.0 디렉터리가 upstream main 에서 제거됐다. 그래서 여기에 vendoring 한다.
#
# ── 왜 이 이미지가 필요한가 ────────────────────────────────────────────────
# bitnami 가 2025-08-28 부터 공개 카탈로그를 bitnamilegacy 로 옮기고 업데이트를
# 중단했다. mongodb-sharded 는 8.0.13 이 마지막이라 이후 8.0 패치를 받을 수 없다.
# 스택스미스 tarball 도 8.0.13 까지만 존재한다:
#   mongodb-8.0.13-0-linux-amd64-debian-12.tar.gz  -> 200
#   mongodb-8.0.14-0-linux-amd64-debian-12.tar.gz  -> 404
#
# aiaas-search-mongodb 에서 8.0.13 고정으로 인한 문제가 실제로 발생했다 (DET-1400):
# config server 가 커넥션 풀 밖에서 소켓을 누적해 arbiter 를 OOMKill 로 밀어낸다.
# 7.0.9 대비 arbiter 메모리 증가율이 3~37배로 뛰었고, 그 수정이 이후 8.0 패치에
# 들어있는지 확인하려면 최신 8.0 을 돌려봐야 한다.
#
# ── 원본과 다른 점 ────────────────────────────────────────────────────────
# bitnami 스캐폴딩(스크립트·conf.default·templates·database-tools·mongosh)은
# 8.0.13 스택스미스 tarball 을 그대로 쓰고, **서버 바이너리(mongod/mongos)만**
# MongoDB 공식 배포본으로 덮어쓴다. helm chart(mongodb-sharded 9.x)가 bitnami 의
# /opt/bitnami/scripts 계약과 디렉터리 레이아웃에 의존하므로 그쪽은 손대지 않는다.
#
# 최신 8.0.x 로 올리려면 MONGODB_VERSION 만 바꾼다. 바꾸기 전에 존재 확인:
#   curl -I https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-debian12-<ver>.tgz
#
# ⚠️ 공식 debian12 빌드는 x86_64 만 있다 (aarch64 는 403). 다른 arch 는 빌드를
#    실패시킨다 — 조용히 8.0.13 이 남은 이미지가 나가면 버전을 올린 의미가 없다.

FROM docker.io/bitnami/minideb:bookworm

ARG DOWNLOADS_URL="downloads.bitnami.com/files/stacksmith"
ARG TARGETARCH

# bitnami 스캐폴딩을 제공하는 마지막 스택스미스 tarball. 더 올릴 수 없다.
ARG BITNAMI_SCAFFOLD_VERSION="8.0.13-0"
# 실제로 실행될 서버 버전. 이 값만 바꾸면 된다.
ARG MONGODB_VERSION="8.0.30"

LABEL org.opencontainers.image.base.name="docker.io/bitnami/minideb:bookworm" \
      org.opencontainers.image.description="MongoDB sharded (bitnami scaffolding + upstream server binaries)" \
      org.opencontainers.image.documentation="https://github.com/bitnami/containers/tree/main/bitnami/mongodb-sharded/README.md" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/657585595c/bitnami/mongodb-sharded/8.0/debian-12" \
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
      "yq-4.47.1-3-linux-${OS_ARCH}-debian-12" \
      "wait-for-port-1.0.10-1-linux-${OS_ARCH}-debian-12" \
      "render-template-1.0.9-156-linux-${OS_ARCH}-debian-12" \
      "mongodb-shell-2.5.7-0-linux-${OS_ARCH}-debian-12" \
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
# bitnami 가 깔아둔 mongod/mongos 는 BITNAMI_SCAFFOLD_VERSION 이라 여기서 덮는다.
# conf.default / templates / database-tools / mongosh 는 건드리지 않는다.
# 마지막 grep 이 검증이다 — 덮어쓰기가 실패하면 빌드가 여기서 멈춘다.
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
