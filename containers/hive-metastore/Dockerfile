# Hive standalone metastore 4.0.0.
# 공식 apache/hive:4.0.0 을 베이스로 사용 → entrypoint 환경변수 매핑(SERVICE_NAME/DB_DRIVER/
# IS_RESUME/SERVICE_OPTS/HIVE_CUSTOM_CONF_DIR/METASTORE_PORT), Java 8, Hadoop 3.3.6,
# hive-hcatalog-server-extensions-4.0.0(DbNotificationListener) 를 그대로 상속한다.
# metastore-site.xml 은 이미지에 굽지 않고 런타임에 HIVE_CUSTOM_CONF_DIR(k8s ConfigMap)로 주입.
#
# 추가하는 것: S3A(Ceph RGW) 접근용 hadoop-aws + aws-java-sdk-bundle (Hadoop 3.3.6 정렬),
#             PostgreSQL JDBC 드라이버. (공식 이미지에는 미포함)
#
# 참고: 이전 3.1.3(standalone-metastore tarball + 자체 start.sh 렌더링) 구성은 git 이력 참조.
# 기존 3.1.3 이미지 태그(3.1.3-hadoop3.3.4-*)는 레지스트리에 남아있어 롤백 가능.

ARG hadoop_aws_version=3.3.6
ARG aws_java_sdk_bundle_version=1.12.367
ARG postgresql_jar_version=42.7.4

FROM curlimages/curl:8.11.1 AS jars
ARG hadoop_aws_version
ARG aws_java_sdk_bundle_version
ARG postgresql_jar_version
WORKDIR /jars
RUN curl -fsSL https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/${hadoop_aws_version}/hadoop-aws-${hadoop_aws_version}.jar -o hadoop-aws-${hadoop_aws_version}.jar \
    && curl -fsSL https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-bundle/${aws_java_sdk_bundle_version}/aws-java-sdk-bundle-${aws_java_sdk_bundle_version}.jar -o aws-java-sdk-bundle-${aws_java_sdk_bundle_version}.jar \
    && curl -fsSL https://repo1.maven.org/maven2/org/postgresql/postgresql/${postgresql_jar_version}/postgresql-${postgresql_jar_version}.jar -o postgresql-${postgresql_jar_version}.jar

FROM apache/hive:4.0.0
USER root
COPY --from=jars /jars/*.jar /opt/hive/lib/
RUN chmod 644 /opt/hive/lib/hadoop-aws-*.jar /opt/hive/lib/aws-java-sdk-bundle-*.jar /opt/hive/lib/postgresql-*.jar
USER hive
