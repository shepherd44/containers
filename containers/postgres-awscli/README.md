# postgres with aws cli

## build

```shell
export TAG=15.6-$(date +%y.%m.%d-%H%M)
docker build --platform linux/amd64 -t shepherd9664/postgres-awscli:$TAG .
```

## push

```shell
docker push shepherd9664/postgres-awscli:$TAG
echo shepherd9664/postgres-awscli:$TAG
```
