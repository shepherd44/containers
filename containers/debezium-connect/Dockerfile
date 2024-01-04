ARG STRIMZI_VERSION
ARG KAFKA_VERSION
FROM quay.io/strimzi/kafka:${STRIMZI_VERSION}-kafka-${KAFKA_VERSION}

USER root:root

ARG DEBEZIUM_VERSION
ENV CONNECTOR_VERSION=${DEBEZIUM_VERSION}
RUN mkdir -p $KAFKA_HOME/plugins && \
    docker-maven-download debezium postgres "$DEBEZIUM_VERSION" && \
    docker-maven-download debezium mongodb "$DEBEZIUM_VERSION" && \
    docker-maven-download debezium mysql "$DEBEZIUM_VERSION" && \
    docker-maven-download debezium jdbc "$DEBEZIUM_VERSION"

COPY ./docker-maven-download.sh /usr/local/bin/docker-maven-download

ARG CP_VERSION
ARG AVRO_VERSION
ARG APICURIO_VERSION
ARG GUAVA_VERSION
ENV MAVEN_DEP_DESTINATION=$KAFKA_HOME/libs
ENV DEBEZIUM_PLUGIN_DIR=$KAFKA_HOME/plugins
RUN docker-maven-download confluent kafka-connect-avro-converter "$CP_VERSION" && \
    docker-maven-download confluent kafka-connect-avro-data "$CP_VERSION" && \
    docker-maven-download confluent kafka-avro-serializer "$CP_VERSION" && \
    docker-maven-download confluent kafka-schema-serializer "$CP_VERSION" && \
    docker-maven-download confluent kafka-schema-registry-client "$CP_VERSION" && \
    docker-maven-download confluent kafka-connect-json-schema-converter "$CP_VERSION" && \
    docker-maven-download confluent common-config "$CP_VERSION" && \
    docker-maven-download confluent common-utils "$CP_VERSION" && \
    docker-maven-download central org/apache/avro avro "$AVRO_VERSION" && \
    docker-maven-download apicurio "$APICURIO_VERSION" && \
    docker-maven-download central com/google/guava guava "$GUAVA_VERSION"

# Add iceberg sink connector
#  - https://github.com/getindata/kafka-connect-iceberg-sink
ARG iceberg_sink_version=0.4.0
RUN curl -fSL https://github.com/getindata/kafka-connect-iceberg-sink/releases/download/${iceberg_sink_version}/kafka-connect-iceberg-sink-${iceberg_sink_version}-plugin.zip \
    -o /tmp/kafka-connect-iceberg-sink-${iceberg_sink_version}-plugin.zip \
    && unzip /tmp/kafka-connect-iceberg-sink-${iceberg_sink_version}-plugin.zip -d /opt/kafka/plugins/


USER 1001
