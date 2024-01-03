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

ARG CP_VERSION
ADD https://packages.confluent.io/maven/io/confluent/common-config/${CP_VERSION}/common-config-${CP_VERSION}.jar /opt/kafka/plugins/
ADD https://packages.confluent.io/maven/io/confluent/common-utils/${CP_VERSION}/common-utils-${CP_VERSION}.jar /opt/kafka/plugins/
ADD https://packages.confluent.io/maven/io/confluent/kafka-connect-avro-converter/${CP_VERSION}/kafka-connect-avro-converter-${CP_VERSION}.jar /opt/kafka/plugins/
ADD https://packages.confluent.io/maven/io/confluent/kafka-connect-avro-data/${CP_VERSION}/kafka-connect-avro-data-${CP_VERSION}.jar /opt/kafka/plugins/
ADD https://packages.confluent.io/maven/io/confluent/kafka-avro-serializer/${CP_VERSION}/kafka-avro-serializer-${CP_VERSION}.jar /opt/kafka/plugins/
ADD https://packages.confluent.io/maven/io/confluent/kafka-schema-serializer/${CP_VERSION}/kafka-schema-serializer-${CP_VERSION}.jar /opt/kafka/plugins/
ADD https://packages.confluent.io/maven/io/confluent/kafka-schema-converter/${CP_VERSION}/kafka-schema-converter-${CP_VERSION}.jar /opt/kafka/plugins/
ADD https://packages.confluent.io/maven/io/confluent/kafka-schema-registry-client/${CP_VERSION}/kafka-schema-registry-client-${CP_VERSION}.jar /opt/kafka/plugins/
ADD https://packages.confluent.io/maven/io/confluent/kafka-connect-json-schema-converter/${CP_VERSION}/kafka-connect-json-schema-converter-${CP_VERSION}.jar /opt/kafka/plugins/
ADD https://packages.confluent.io/maven/io/confluent/kafka-json-schema-provider/${CP_VERSION}/kafka-json-schema-provider-${CP_VERSION}.jar /opt/kafka/plugins/
ADD https://packages.confluent.io/maven/io/confluent/kafka-json-schema-serializer/${CP_VERSION}/kafka-json-schema-serializer-${CP_VERSION}.jar /opt/kafka/plugins/

# Add iceberg sink connector
#  - https://github.com/getindata/kafka-connect-iceberg-sink
ARG iceberg_sink_version=0.4.0
RUN curl -fSL https://github.com/getindata/kafka-connect-iceberg-sink/releases/download/${iceberg_sink_version}/kafka-connect-iceberg-sink-${iceberg_sink_version}-plugin.zip \
    -o /tmp/kafka-connect-iceberg-sink-${iceberg_sink_version}-plugin.zip \
    && unzip /tmp/kafka-connect-iceberg-sink-${iceberg_sink_version}-plugin.zip -d /opt/kafka/plugins/


USER 1001
