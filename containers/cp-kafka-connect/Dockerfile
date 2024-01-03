ARG CP_VERSION
FROM confluentinc/cp-kafka-connect:${CP_VERSION}

RUN confluent-hub install --no-prompt confluentinc/kafka-connect-jdbc:10.7.4
RUN confluent-hub install --no-prompt debezium/debezium-connector-postgresql:2.2.1
RUN confluent-hub install --no-prompt tabular/iceberg-kafka-connect:0.6.5
RUN confluent-hub install --no-prompt mongodb/kafka-connect-mongodb:1.11.1
RUN confluent-hub install --no-prompt debezium/debezium-connector-mongodb:2.2.1
