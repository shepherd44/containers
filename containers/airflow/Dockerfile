FROM apache/airflow:2.5.0-python3.10

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
