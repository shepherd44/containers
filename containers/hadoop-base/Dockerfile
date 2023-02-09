FROM debian:11

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        net-tools \
        curl \
        netcat \
        apt-transport-https \
        ca-certificates \
        gnupg \
        libsnappy-dev \
        ssh \
        openssh-server \
    && mkdir -p /root/.ssh \
    && chmod 700 /root/.ssh \
    && mkdir /var/run/sshd \
    && ssh-keygen -t rsa -P '' -f ~/.ssh/id_dsa \
    && cat ~/.ssh/id_dsa.pub >> ~/.ssh/authorized_keys \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# setting openjdk 8
ENV JAVA_HOME=/opt/java
ENV PATH=${JAVA_HOME}/bin:${PATH}
ENV JAVA_VERSION="jdk8u352-b08"
ENV JAVA_BINARY_URL="https://github.com/adoptium/temurin8-binaries/releases/download/jdk8u352-b08/OpenJDK8U-jdk_x64_linux_hotspot_8u352b08.tar.gz"
ENV JAVA_ESUM="1633bd7590cb1cd72f5a1378ae8294451028b274d798e2a4ac672059a2f00fee"

RUN curl -fSL ${JAVA_BINARY_URL} -o /tmp/${JAVA_VERSION}.tar.gz \
    && echo "${JAVA_ESUM} */tmp/${JAVA_VERSION}.tar.gz" | sha256sum -c - \
    && mkdir -p ${JAVA_HOME} \
    && tar -zxf /tmp/${JAVA_VERSION}.tar.gz -C ${JAVA_HOME} --strip-components 1 \
    && rm -f /tmp/${JAVA_VERSION}.tar.gz

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
ENV PATH=${HADOOP_HOME}/bin/:${PATH}

ADD entrypoint.sh /opt/entrypoint.sh
RUN chmod a+x /opt/entrypoint.sh

ENTRYPOINT ["/opt/entrypoint.sh"]
