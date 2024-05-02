# cp-kafka-connect

## build

```shell
dt=`date +%y.%m.%d-%H%M`
export CP_VERSION=7.6.1
export IMAGE_NAME=cp-kafka-connect
export TAG=${CP_VERSION}-${dt}
docker build \
  --platform linux/amd64 \
  --build-arg CP_VERSION=${CP_VERSION} \
  -t shepherd9664/${IMAGE_NAME}:${TAG} \
  ./
echo ${IMAGE_NAME}:${TAG}
```

## push

```shell
docker push shepherd9664/${IMAGE_NAME}:${TAG}
```

## k8s

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: cp-kafka-connect
  namespace: de-data-debezium
  labels:
    app: cp-kafka-connect
    app.kubernetes.io/name: kafka-connect
    team: de
spec:
  replicas: 1
  selector:
    matchLabels:
      app: cp-kafka-connect
  template:
    metadata:
      labels:
        app: cp-kafka-connect
    spec:
      volumes:
        - name: plugins
          emptyDir: {}
      initContainers:
        - name: init-plugin
          volumeMounts:
            - mountPath: /usr/share/confluent-hub-components
              name: plugins
          image: confluentinc/cp-kafka-connect:7.5.2
          imagePullPolicy: IfNotPresent
          env:
            - name: CONFLUENT_VERSION
              value: "7.5.2"
          command: ["/bin/sh", "-c"]
          args:
            - |
              confluent-hub install --no-prompt confluentinc/kafka-connect-jdbc:10.7.4
              confluent-hub install --no-prompt debezium/debezium-connector-postgresql:2.2.1
              confluent-hub install --no-prompt debezium/debezium-connector-mongodb:2.2.1
              confluent-hub install --no-prompt tabular/iceberg-kafka-connect:0.6.5
              confluent-hub install --no-prompt mongodb/kafka-connect-mongodb:1.11.1
              confluent-hub install --no-prompt confluentinc/kafka-connect-avro-converter:${CONFLUENT_VERSION}
              confluent-hub install --no-prompt confluentinc/kafka-connect-json-schema-converter:${CONFLUENT_VERSION}
      containers:
        - name: cp-kafka-connect
          image: confluentinc/cp-kafka-connect:7.5.2
          imagePullPolicy: IfNotPresent
          volumeMounts:
            - mountPath: /usr/share/confluent-hub-components
              name: plugins
          env:
            - name: CONFLUENT_VERSION
              value: "7.5.2"
            - name: CONNECT_BOOTSTRAP_SERVERS
              value: kafka-bootstrap.kafka.svc.cluster.local:9092
            - name: CONNECT_REST_PORT
              value: "8083"
            - name: CONNECT_GROUP_ID
              value: cp-kafka-connect
            - name: CONNECT_CONFIG_STORAGE_TOPIC
              value: _cp-kafka-connect-configs
            - name: CONNECT_OFFSET_STORAGE_TOPIC
              value: _cp-kafka-connect-offsets
            - name: CONNECT_STATUS_STORAGE_TOPIC
              value: _cp-kafka-connect-status
            - name: CONNECT_CONFIG_STORAGE_REPLICATION_FACTOR
              value: "1"
            - name: CONNECT_OFFSET_STORAGE_REPLICATION_FACTOR
              value: "1"
            - name: CONNECT_STATUS_STORAGE_REPLICATION_FACTOR
              value: "1"
            - name: CONNECT_KEY_CONVERTER
              value: org.apache.kafka.connect.json.JsonConverter
            - name: CONNECT_VALUE_CONVERTER
              value: org.apache.kafka.connect.json.JsonConverter
            - name: CONNECT_INTERNAL_KEY_CONVERTER
              value: org.apache.kafka.connect.json.JsonConverter
            - name: CONNECT_INTERNAL_VALUE_CONVERTER
              value: org.apache.kafka.connect.json.JsonConverter
            - name: CONNECT_LOG4J_ROOT_LOGLEVEL
              value: "INFO"
            - name: CONNECT_LOG4J_LOGGERS
              value: "org.reflections=ERROR"
            - name: CONNECT_PLUGIN_PATH
              value: /usr/share/java,/usr/share/confluent-hub-components,/data/connect-jars
            - name: CONNECT_REST_ADVERTISED_HOST_NAME
              valueFrom:
                fieldRef:
                  fieldPath: status.podIP
            - name: CONNECT_REST_ADVERTISED_PORT
              value: "8083"
---
apiVersion: v1
kind: Service
metadata:
  name: cp-kafka-connect
  namespace: de-data-debezium
spec:
  ports:
    - name: rest
      port: 8083
      protocol: TCP
      targetPort: 8083
  selector:
    app: cp-kafka-connect
```