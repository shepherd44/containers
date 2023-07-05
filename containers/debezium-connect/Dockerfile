FROM quay.io/strimzi/kafka:0.35.1-kafka-3.3.2

USER root:root

ENV CONNECTOR_VERSION=2.3.0.Final
RUN mkdir -p /opt/kafka/plugins \
    && curl -fSL https://repo1.maven.org/maven2/io/debezium/debezium-connector-postgres/${CONNECTOR_VERSION}/debezium-connector-postgres-${CONNECTOR_VERSION}-plugin.tar.gz -o /tmp/debezium-connector-postgres-plugin.tar.gz \
    && tar -zxf /tmp/debezium-connector-postgres-plugin.tar.gz -C /opt/kafka/plugins/ \
    && curl -fSL https://repo1.maven.org/maven2/io/debezium/debezium-connector-mongodb/${CONNECTOR_VERSION}/debezium-connector-mongodb-${CONNECTOR_VERSION}-plugin.tar.gz -o /tmp/debezium-connector-mongodb-plugin.tar.gz \
    && tar -zxf /tmp/debezium-connector-mongodb-plugin.tar.gz -C /opt/kafka/plugins/ \
    && curl -fSL https://repo1.maven.org/maven2/io/debezium/debezium-connector-mysql/${CONNECTOR_VERSION}/debezium-connector-mysql-${CONNECTOR_VERSION}-plugin.tar.gz -o /tmp/debezium-connector-mysql-plugin.tar.gz \
    && tar -zxf /tmp/debezium-connector-mysql-plugin.tar.gz -C /opt/kafka/plugins/ \
    && rm -rf /tmp/*

USER 1001
