ARG SPARK_VERSION

########dependencies download stage########
FROM maven:3.8-jdk-11-slim as maven_build_spark
WORKDIR /app

ARG SCALA_VERSION
ARG SPARK_VERSION
ARG HADOOP_VERSION
ARG HIVE_VERSION
ARG ICEBERG_VERSION
ENV SCALA_VERSION=${SCALA_VERSION}
ENV SPARK_VERSION=${SPARK_VERSION}
ENV HADOOP_VERSION=${HADOOP_VERSION}
ENV HIVE_VERSION=${HIVE_VERSION}
ENV ICEBERG_VERSION=${ICEBERG_VERSION}

COPY ./pom.xml .
RUN mvn dependency:copy-dependencies
#RUN mvn dependency:copy-dependencies \
#    -D scala.version=$SCALA_VERSION \
#    -D spark.version=$SPARK_VERSION \
#    -D hadoop.version=$HADOOP_VERSION \
#    -D hive.version=$HIVE_VERSION \
#    -D iceberg.version=$ICEBERG_VERSION

########build stage########
FROM apache/spark:${SPARK_VERSION}

ARG SPARK_USER=spark
ARG SPARK_UID=185
ARG SCALA_VERSION
ARG SPARK_VERSION
ARG HADOOP_VERSION
ARG HIVE_VERSION
ARG ICEBERG_VERSION

ENV SCALA_VERSION=${SCALA_VERSION}
ENV SPARK_VERSION=${SPARK_VERSION}
ENV HADOOP_VERSION=${HADOOP_VERSION}
ENV HIVE_VERSION=${HIVE_VERSION}
ENV ICEBERG_VERSION=${ICEBERG_VERSION}

USER 0
WORKDIR /

# python dependencies
COPY requirements.txt /opt/requirements.txt
RUN pip3 install --no-cache-dir -r /opt/requirements.txt
RUN mkdir -p /opt/python-libs
ENV PYTHONPATH=/opt/python-libs/:${PYTHONPATH}

# spark runtime dependencies
COPY --from=maven_build_spark /app/target/dependency/*.jar ${SPARK_HOME}/jars/

# prometheus jmx exporter
ADD https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/0.19.0/jmx_prometheus_javaagent-0.19.0.jar /prometheus/
RUN chmod 644 /prometheus/jmx_prometheus_javaagent-0.19.0.jar
RUN mkdir -p /etc/metrics/conf
COPY conf/metrics.properties /etc/metrics/conf
COPY conf/prometheus.yaml /etc/metrics/conf

USER ${SPARK_USER}
WORKDIR /opt/spark/work-dir
