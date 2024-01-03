# debezium-connect

## build

* BASE IMAGE: 0.36.0-kafka-3.5.0
* [strimzi kafka image](https://quay.io/repository/strimzi/kafka?tab=tags)
* [confluent maven](https://packages.confluent.io/maven/)

```bash
export STRIMZI_VERSION=0.36.0
export KAFKA_VERSION=3.5.0
export DEBEZIUM_VERSION=2.5.0.Final
export CP_VERSION=7.5.3
export dt=$(date '+%Y.%m.%d-%H.%M')
export TAG=${STRIMZI_VERSION}-kafka-${KAFKA_VERSION}-${DEBEZIUM_VERSION}-${dt}
docker build \
  --platform linux/amd64 \
  --build-arg DEBEZIUM_VERSION=${DEBEZIUM_VERSION} \
  --build-arg CP_VERSION=${CP_VERSION} \
  --build-arg STRIMZI_VERSION=${STRIMZI_VERSION} \
  --build-arg KAFKA_VERSION=${KAFKA_VERSION} \
  -t shepherd9664/debezium-connect:${TAG} \
  ./
```

## push

```bash
docker push shepherd9664/debezium-connect:${TAG}
```