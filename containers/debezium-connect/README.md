# debezium-connect

## build

```shell
dt=`date +%y.%m.%d.%H`
docker build \
  --platform linux/amd64 \
  -t shepherd9664/debezium-connect:0.34.0-2.1.4-Final-${dt} \
  ./
```
