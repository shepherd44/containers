# hive metastore (4.0.0)

`apache/hive:4.0.0` 베이스 + S3A(hadoop-aws/aws-sdk) + PostgreSQL JDBC 추가.

## 특징
- 공식 `apache/hive:4.0.0` 상속: entrypoint 환경변수 매핑, Java 8, Hadoop 3.3.6, hcatalog(DbNotificationListener).
- metastore-site.xml 은 이미지에 굽지 않음 → 런타임에 `HIVE_CUSTOM_CONF_DIR`(k8s ConfigMap)로 주입.
- HIVE-26882 포함(4.0.0) → Iceberg lock-free 전제 충족. deprecated `get_table` 유지(4.0.1 에서 제거) → 기존 Iceberg/Spark 클라이언트 호환.

## 실행(메타스토어 모드) 환경변수
- `SERVICE_NAME=metastore`
- `DB_DRIVER=postgres`
- `IS_RESUME=true` (스키마 init/upgrade 스킵 — 스키마는 schematool 로 별도 관리)
- `HIVE_CUSTOM_CONF_DIR=/path/to/conf` (metastore-site.xml 마운트 디렉터리)
- `SERVICE_OPTS` 로 `-Djavax.jdo.option.Connection*` 지정 가능(또는 conf 파일로)

## build
CI(`.github/workflows/hive-metastore.yml`)가 빌드/푸시. 태그 `4.0.0-{date}` + `4.0.0-latest`.

> 이전 3.1.3(standalone-metastore tarball + 자체 start.sh 렌더링) 구성은 git 이력 참조.
