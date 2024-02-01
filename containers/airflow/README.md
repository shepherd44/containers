# Airflow Docker Image

## build

```shell
export AIRFLOW_VERSION=2.8.1
export PYTHON_VERSION=3.11
export IMAGE_NAME=shepherd9664/airflow
export TAG="${AIRFLOW_VERSION}-py${PYTHON_VERSION}"
dt=`date +%y.%m.%d.%H`
docker build \
  --platform linux/amd64 \
  --build-arg AIRFLOW_VERSION=${AIRFLOW_VERSION} \
  --build-arg PYTHON_VERSION=${PYTHON_VERSION} \
  -t ${IMAGE_NAME}:${TAG} \
  ./
echo ${IMAGE_NAME}:${TAG}
```
