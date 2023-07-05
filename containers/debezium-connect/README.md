# debezium-connect

## build

* BASE IMAGE: 0.35.1-kafka-3.3.2

```bash
export dt=$(date '+%Y.%m.%d-%H.%M')
docker build \
  --platform linux/amd64 \
  -t shepherd9664/debezium-connect:0.35.1-2.3.0-Final-${dt} \
  ./ 
```

## push

```bash
docker push shepherd9664/debezium-connect:0.35.1-2.3.0-Final-${dt}
```