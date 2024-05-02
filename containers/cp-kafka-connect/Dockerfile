ARG CP_VERSION
FROM confluentinc/cp-kafka-connect:${CP_VERSION}

RUN confluent-hub install --no-prompt confluentinc/kafka-connect-jdbc:10.7.6
RUN confluent-hub install --no-prompt debezium/debezium-connector-postgresql:2.5.3
RUN confluent-hub install --no-prompt tabular/iceberg-kafka-connect:0.6.16
RUN confluent-hub install --no-prompt mongodb/kafka-connect-mongodb:1.11.2
RUN confluent-hub install --no-prompt debezium/debezium-connector-mongodb:2.4.2
