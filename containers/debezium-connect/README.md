## build

* BASE IMAGE: 0.35.1-kafka-3.3.1

```bash
docker build \
--platform linux/amd64 \
-t shepherd9664/debezium-connect:0.35.1-2.3.0-Final \
./ 
```

## push

```bash
docker push shepherd9664/debezium-connect:0.35.1-2.3.0-Final
```