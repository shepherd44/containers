# Spark

Spark for kubernetes

## spark 

## build

### spark 3.5.0

```shell
export SPARK_VERSION="3.5.0"
export HADOOP_VERSION="3.3.4"
export SCALA_VERSION="2.12"
export HIVE_VERSION="2.3.9"
export ICEBERG_VERSION="1.4.3"
export dt=`date +%y.%m.%d-%H%M`
export IMAGE_NAME="shepherd9664/spark"
export TAG="${SPARK_VERSION}-${dt}"
export FULL_IMAGE_NAME="${IMAGE_NAME}:${TAG}"
docker build \
  --platform linux/amd64 \
  --build-arg SPARK_VERSION=${SPARK_VERSION} \
  --build-arg HADOOP_VERSION=${HADOOP_VERSION} \
  --build-arg SCALA_VERSION=${SCALA_VERSION} \
  --build-arg HIVE_VERSION=${HIVE_VERSION} \
  --build-arg ICEBERG_VERSION=${ICEBERG_VERSION} \
  -f ./Dockerfile \
  -t ${FULL_IMAGE_NAME} \
  ./
echo build complete: ${FULL_IMAGE_NAME}
```

```shell
docker push ${FULL_IMAGE_NAME}
echo ${FULL_IMAGE_NAME}
```
