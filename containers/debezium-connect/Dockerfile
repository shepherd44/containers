ARG STRIMZI_VERSION
ARG KAFKA_VERSION
########dependencies download stage########
FROM maven:3.9.7 as maven_download_confluent
WORKDIR /app

COPY pom.xml .
RUN mvn dependency:copy-dependencies

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

USER 1001
