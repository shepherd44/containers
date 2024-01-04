ARG STRIMZI_VERSION
ARG KAFKA_VERSION
FROM quay.io/strimzi/kafka:${STRIMZI_VERSION}-kafka-${KAFKA_VERSION}

USER root:root

ARG DEBEZIUM_VERSION
ENV CONNECTOR_VERSION=${DEBEZIUM_VERSION}
RUN mkdir -p /opt/kafka/plugins \
    && curl -fSL https://repo1.maven.org/maven2/io/debezium/debezium-connector-postgres/${CONNECTOR_VERSION}/debezium-connector-postgres-${CONNECTOR_VERSION}-plugin.tar.gz -o /tmp/debezium-connector-postgres-plugin.tar.gz \
    && tar -zxf /tmp/debezium-connector-postgres-plugin.tar.gz -C /opt/kafka/plugins/ \
    && curl -fSL https://repo1.maven.org/maven2/io/debezium/debezium-connector-mongodb/${CONNECTOR_VERSION}/debezium-connector-mongodb-${CONNECTOR_VERSION}-plugin.tar.gz -o /tmp/debezium-connector-mongodb-plugin.tar.gz \
    && tar -zxf /tmp/debezium-connector-mongodb-plugin.tar.gz -C /opt/kafka/plugins/ \
    && curl -fSL https://repo1.maven.org/maven2/io/debezium/debezium-connector-mysql/${CONNECTOR_VERSION}/debezium-connector-mysql-${CONNECTOR_VERSION}-plugin.tar.gz -o /tmp/debezium-connector-mysql-plugin.tar.gz \
    && tar -zxf /tmp/debezium-connector-mysql-plugin.tar.gz -C /opt/kafka/plugins/ \
    && curl -fSL https://repo1.maven.org/maven2/io/debezium/debezium-connector-jdbc/${CONNECTOR_VERSION}/debezium-connector-jdbc-${CONNECTOR_VERSION}-plugin.tar.gz -o /tmp/debezium-connector-jdbc-plugin.tar.gz \
    && tar -zxf /tmp/debezium-connector-jdbc-plugin.tar.gz -C /opt/kafka/plugins/ \
    && rm -rf /tmp/*

COPY ./docker-maven-download.sh /usr/local/bin/docker-maven-download

ARG CP_VERSION
ARG AVRO_VERSION
ARG APICURIO_VERSION
ARG GUAVA_VERSION
ENV MAVEN_DEP_DESTINATION=$KAFKA_HOME/libs
RUN docker-maven-download confluent kafka-connect-avro-converter "$CP_VERSION" && \
    docker-maven-download confluent kafka-connect-avro-data "$CP_VERSION" && \
    docker-maven-download confluent kafka-avro-serializer "$CP_VERSION" && \
    docker-maven-download confluent kafka-schema-serializer "$CP_VERSION" && \
    docker-maven-download confluent kafka-schema-registry-client "$CP_VERSION" && \
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
