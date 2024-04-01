# awscli

```shell
export TAG=$(date +%y.%m.%d-%H%M)
docker build \
  --platform linux/amd64 \
  -t shepherd9664/awscli:${TAG} \
  .
```

```shell
docker push shepherd9664/awscli:${TAG}
```
