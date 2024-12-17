# hive metastore

## build

```shell
export TAG=3.1.3-$(date +%y.%m.%d-%H%M)
docker build --platform linux/amd64 -t shepherd9664/hive-metastore:$TAG .
```