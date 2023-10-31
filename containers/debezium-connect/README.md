# debezium-connect

## build

* BASE IMAGE: 0.36.0-kafka-3.5.0

```bash
export DEBEZIUM_VERSION=2.4.0.Final
export dt=$(date '+%Y.%m.%d-%H.%M')
docker build \
  --platform linux/amd64 \
  -t shepherd9664/debezium-connect:0.36.0-${DEBEZIUM_VERSION}-${dt} \
  ./ 
```

## push

```bash
docker push shepherd9664/debezium-connect:0.36.0-${DEBEZIUM_VERSION}-${dt}
```