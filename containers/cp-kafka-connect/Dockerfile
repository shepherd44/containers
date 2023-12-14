FROM confluentinc/cp-kafka-connect:7.5.2

RUN confluent-hub install --no-prompt confluentinc/kafka-connect-jdbc:10.7.4
RUN confluent-hub install --no-prompt debezium/debezium-connector-postgresql:2.2.1
RUN confluent-hub install --no-prompt tabular/iceberg-kafka-connect:0.6.5
