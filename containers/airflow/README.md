# Airflow Docker Image

python package list

* apache-airflow-providers-amazon==7.3.0
* apache-airflow-providers-trino==4.3.2
* apache-airflow-providers-cncf-kubernetes==5.2.2

## build

```shell
dt=`date +%y.%m.%d.%H`
docker build \
  --platform linux/amd64 \
  -t shepherd9664/airflow:2.5.1-py3.10-%{dt} \
  ./
```
