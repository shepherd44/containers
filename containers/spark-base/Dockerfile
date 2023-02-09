FROM ubuntu:22.04

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        net-tools \
        curl \
        apt-transport-https \
        ca-certificates \
        gnupg \
        ssh \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# setting openjdk 11
ENV JAVA_HOME=/opt/java
ENV PATH=${JAVA_HOME}/bin:${PATH}
ENV JAVA_VERSION="jdk-11.0.18-10"
ENV JAVA_BINARY_URL="https://github.com/adoptium/temurin11-binaries/releases/download/jdk-11.0.18%2B10/OpenJDK11U-jdk_x64_linux_hotspot_11.0.18_10.tar.gz"
ENV JAVA_ESUM="4a29efda1d702b8ff38e554cf932051f40ec70006caed5c4857a8cbc7a0b7db7"

RUN curl -fSL ${JAVA_BINARY_URL} -o /tmp/${JAVA_VERSION}.tar.gz \
    && echo "${JAVA_ESUM} */tmp/${JAVA_VERSION}.tar.gz" | sha256sum -c - \
    && mkdir -p ${JAVA_HOME} \
    && tar -zxf /tmp/${JAVA_VERSION}.tar.gz -C ${JAVA_HOME} --strip-components 1 \
    && rm -f /tmp/${JAVA_VERSION}.tar.gz

# setting spark
ARG spark_version=3.3.1
ENV SPARK_VERSION=${spark_version}
ENV SPARK_HOME=/opt/spark
ENV PATH=${SPARK_HOME}/sbin:${SPARK_HOME}/bin:${PATH}

RUN curl -fSL https://dlcdn.apache.org/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop3.tgz -o /tmp/spark-${SPARK_VERSION}-bin-hadoop3.tgz \
  && tar -xzf /tmp/spark-${SPARK_VERSION}-bin-hadoop3.tgz --directory /opt/ \
  && ln -s /opt/spark-${SPARK_VERSION}-bin-hadoop3 ${SPARK_HOME} \
  && rm -rf /tmp/spark-${SPARK_VERSION}-bin-hadoop3.tgz

COPY conf/spark-defaults.conf /opt/spark/conf/spark-defaults.conf

ENV PYTHONPATH=${SPARK_HOME}/python:${SPARK_HOME}/python/lib/py4j-0.10.9.5-src.zip:${PYTHONPATH}

# setting hadoop
ARG hadoop_version=3.3.4
ENV HADOOP_VERSION=${hadoop_version}
ENV HADOOP_URL=https://dlcdn.apache.org/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz
ENV HADOOP_KEYS=https://downloads.apache.org/hadoop/common/KEYS

RUN curl -O ${HADOOP_KEYS} \
    && gpg --import KEYS \
    && curl -fSL "$HADOOP_URL" -o /tmp/hadoop.tar.gz \
    && curl -fSL "$HADOOP_URL.asc" -o /tmp/hadoop.tar.gz.asc \
    && gpg --verify /tmp/hadoop.tar.gz.asc \
    && tar -zxf /tmp/hadoop.tar.gz -C /opt/ \
    && ln -s /opt/hadoop-${HADOOP_VERSION} /opt/hadoop \
    && ln -s /opt/hadoop-${HADOOP_VERSION}/etc/hadoop /etc/hadoop \
    && mkdir /opt/hadoop/logs \
    && mkdir /hadoop-data \
    && rm /tmp/hadoop.tar.gz*

ENV HADOOP_HOME=/opt/hadoop
ENV HADOOP_CONF_DIR=/etc/hadoop
ENV MULTIHOMED_NETWORK=1
ENV USER=root
ENV PATH=$HADOOP_HOME/bin/:$PATH

ADD entrypoint.sh /opt/entrypoint.sh
RUN chmod a+x /opt/entrypoint.sh

ENTRYPOINT ["/opt/entrypoint.sh"]
