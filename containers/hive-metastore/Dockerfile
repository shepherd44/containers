FROM shepherd9664/hadoop-base:3.3.4

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ARG postgresql_jar_version=42.5.1
ARG hadoop_aws_version=3.3.4
ARG aws_java_sdk_bundle_version=1.12.396
ENV HIVE_VERSION=3.1.3
ENV HIVE_METASTORE_URL=https://repo1.maven.org/maven2/org/apache/hive/hive-standalone-metastore/${HIVE_VERSION}/hive-standalone-metastore-${HIVE_VERSION}-bin.tar.gz
ENV METASTORE_HOME=/opt/hive-metastore
RUN mkdir -p /opt \
    && curl -fSL ${HIVE_METASTORE_URL} -o /tmp/hive-standalone-metastore-${HIVE_VERSION}-bin.tar.gz \
    && tar -zxf /tmp/hive-standalone-metastore-${HIVE_VERSION}-bin.tar.gz -C /opt/ \
    && rm -rf /tmp/hive-standalone-metastore-${HIVE_VERSION}-bin.tar.gz \
    && ln -s /opt/apache-hive-metastore-${HIVE_VERSION}-bin ${METASTORE_HOME} \
    && curl -fSL https://jdbc.postgresql.org/download/postgresql-${postgresql_jar_version}.jar \
      -o /opt/hive-metastore/lib/postgresql-${postgresql_jar_version}.jar \
    && chmod 644 /opt/hive-metastore/lib/postgresql-${postgresql_jar_version}.jar \
    && curl -fSL https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/${hadoop_aws_version}/hadoop-aws-${hadoop_aws_version}.jar \
      -o ${METASTORE_HOME}/lib/hadoop-aws-${hadoop_aws_version}.jar \
    && curl -fSL https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-bundle/${aws_java_sdk_bundle_version}/aws-java-sdk-bundle-${aws_java_sdk_bundle_version}.jar \
      -o /${METASTORE_HOME}/lib/aws-java-sdk-bundle-${aws_java_sdk_bundle_version}.jar

COPY conf ${METASTORE_HOME}/conf
COPY start.sh /opt/start.sh
RUN chmod a+x /opt/start.sh

EXPOSE 9083

ENTRYPOINT ["/opt/start.sh"]

CMD ["/opt/hive-metastore/bin/start-metastore"]