# cp-kafka-connect

## build

```shell
dt=`date +%y.%m.%d-%H%M`
export CP_VERSION=7.5.2
IMAGE_NAME=cp-kafka-connect
TAG=${CP_VERSION}-${dt}
docker build \
  --platform linux/amd64 \
  -t shepherd9664/${IMAGE_NAME}:${TAG} \
  ./
echo ${IMAGE_NAME}:${TAG}
```

## push

```shell
docker push shepherd9664/${IMAGE_NAME}:${TAG}
```
