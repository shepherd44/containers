FROM quay.io/strimzi/kafka:0.36.0-kafka-3.5.0

USER root:root

ENV CONNECTOR_VERSION=2.4.1.Final
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

# Add iceberg sink connector
#  - https://github.com/getindata/kafka-connect-iceberg-sink
ARG iceberg_sink_version=0.3.1
RUN curl -fSL https://github.com/getindata/kafka-connect-iceberg-sink/releases/download/${iceberg_sink_version}/kafka-connect-iceberg-sink-${iceberg_sink_version}-plugin.zip \
    -o /tmp/kafka-connect-iceberg-sink-${iceberg_sink_version}-plugin.zip \
    && unzip /tmp/kafka-connect-iceberg-sink-${iceberg_sink_version}-plugin.zip -d /opt/kafka/plugins/


USER 1001
