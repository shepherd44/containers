ARG STRIMZI_VERSION
ARG KAFKA_VERSION
########dependencies download stage########
FROM maven:3.9.7 as maven_download_confluent
WORKDIR /app

COPY pom.xml .
RUN --mount=type=cache,target=/root/.m2 mvn dependency:copy-dependencies

########build stage########
FROM quay.io/strimzi/kafka:${STRIMZI_VERSION}-kafka-${KAFKA_VERSION}

USER root:root

COPY ./docker-maven-download.sh /usr/local/bin/docker-maven-download

ARG DEBEZIUM_VERSION
ENV CONNECTOR_VERSION=${DEBEZIUM_VERSION}
ENV DEBEZIUM_PLUGIN_DIR=$KAFKA_HOME/plugins
RUN mkdir -p $KAFKA_HOME/plugins && \
    docker-maven-download debezium postgres "$DEBEZIUM_VERSION" && \
    docker-maven-download debezium mongodb "$DEBEZIUM_VERSION" && \
    docker-maven-download debezium mysql "$DEBEZIUM_VERSION" && \
    docker-maven-download debezium jdbc "$DEBEZIUM_VERSION"

COPY --from=maven_download_confluent /app/target/dependency/*.jar ${KAFKA_HOME}/plugins/libs/

RUN curl https://github.com/databricks/iceberg-kafka-connect/releases/download/v0.6.19/iceberg-kafka-connect-runtime-hive-0.6.19.zip -o /tmp/iceberg-kafka-connect-runtime-hive-0.6.19.zip -L \
    && unzip /tmp/iceberg-kafka-connect-runtime-hive-0.6.19.zip -d /tmp \
    && cp -rf /tmp/iceberg-kafka-connect-runtime-hive-0.6.19/lib ${KAFKA_HOME}/plugins/iceberg-kafka-connect-runtime-hive-0.6.19 \
    && rm /tmp/iceberg-kafka-connect-runtime-hive-0.6.19.zip \
    && rm -rf /tmp/iceberg-kafka-connect-runtime-hive-0.6.19

USER 1001
