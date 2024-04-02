# awscli

```shell
export AWSCLI_VERSION=2.15.34
export POSTGRES_VERSION=14
export TAG=${AWSCLI_VERSION}-postgres${POSTGRES_VERSION}-$(date +%y.%m.%d-%H%M)
docker build \
  --platform linux/amd64 \
  --build-arg AWSCLI_VERSION=${AWSCLI_VERSION} \
  --build-arg POSTGRES_VERSION=${POSTGRES_VERSION} \
  -t shepherd9664/awscli:${TAG} \
  .
```

```shell
docker push shepherd9664/awscli:${TAG}
```
