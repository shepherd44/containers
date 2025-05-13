# postgres with aws cli

## build

```shell
export POSTGRES_VERSION=17.5
export TAG=${POSTGRES_VERSION}-$(date +%y.%m.%d-%H%M)
docker build \
  --build-arg POSTGRES_VERSION=${POSTGRES_VERSION} \
  --platform linux/amd64 \
  -t shepherd9664/postgres-awscli:$TAG .
```

## push

```shell
docker push shepherd9664/postgres-awscli:$TAG
echo shepherd9664/postgres-awscli:$TAG
```
