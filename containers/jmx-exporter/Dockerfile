# Prometheus JMX exporter, run as a standalone HTTP server sidecar.
#
# There is no maintained public image for this: prometheus/jmx_exporter ships jars
# only, and the images charts historically used (solsson, sscaling) stopped in 2019-2020
# on a JDK 8 base. So we build it, the same way as the other images here.
FROM eclipse-temurin:21-jre-noble

ARG JMX_EXPORTER_VERSION=1.6.0

ENV JMX_EXPORTER_VERSION="${JMX_EXPORTER_VERSION}" \
    JMX_EXPORTER_HOME="/opt/jmx-exporter"

SHELL ["/bin/bash", "-o", "errexit", "-o", "nounset", "-o", "pipefail", "-c"]

RUN apt-get update && apt-get install -y --no-install-recommends curl ca-certificates && \
    BASE="https://github.com/prometheus/jmx_exporter/releases/download/${JMX_EXPORTER_VERSION}" ; \
    JAR="jmx_prometheus_standalone-${JMX_EXPORTER_VERSION}.jar" ; \
    mkdir -p "${JMX_EXPORTER_HOME}" ; \
    curl -sSLf "${BASE}/${JAR}" -o "${JMX_EXPORTER_HOME}/jmx_prometheus_standalone.jar" ; \
    curl -sSLf "${BASE}/${JAR}.sha256" -o /tmp/jar.sha256 ; \
    # the published .sha256 names the release file; check against our fixed filename
    echo "$(cut -d' ' -f1 /tmp/jar.sha256)  ${JMX_EXPORTER_HOME}/jmx_prometheus_standalone.jar" | sha256sum -c - ; \
    rm -f /tmp/jar.sha256 ; \
    apt-get purge -y --auto-remove curl && \
    apt-get clean && rm -rf /var/lib/apt/lists /var/cache/apt/archives

# 10001 is the uid the cp-schema-registry chart runs this sidecar as.
RUN useradd -r -u 10001 -g root jmx-exporter

# Fails the build if the jar cannot start; a jar/JRE mismatch is otherwise only
# visible as a CrashLoopBackOff at deploy time.
RUN out="$(java -jar "${JMX_EXPORTER_HOME}/jmx_prometheus_standalone.jar" 2>&1 || true)" ; \
    echo "${out}" | grep -q -i "usage"

EXPOSE 5556
USER 10001
WORKDIR /opt/jmx-exporter
ENTRYPOINT ["java", "-jar", "/opt/jmx-exporter/jmx_prometheus_standalone.jar"]
