ARG AIRFLOW_VERSION="2.8.1"
ARG PYTHON_VERSION="3.11"
FROM apache/airflow:${AIRFLOW_VERSION}-python${PYTHON_VERSION}

#USER root
#RUN apt-get update \
#  && apt-get install -y --no-install-recommends vim \
#  && apt-get autoremove -yqq --purge \
#  && apt-get clean \
#  && rm -rf /var/lib/apt/lists/* \

USER airflow
COPY ./requirements.txt ./requirements.txt
RUN pip install --no-cache-dir -r ./requirements.txt

# Embedding dags
#COPY --chown=airflow:root test_dag.py /opt/airflow/dags
