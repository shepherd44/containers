# iceberg-kafka-connect-runtime

Apache Iceberg 의 Kafka Connect 싱크 런타임 배포판(hive dist zip)을 빌드해 이 저장소 릴리스 자산으로 올린다.

이 디렉터리에는 소스가 없다. 빌드는 전부 [`.github/workflows/iceberg-kafka-connect-runtime.yml`](../../.github/workflows/iceberg-kafka-connect-runtime.yml) 이 apache/iceberg 를 체크아웃해서 수행한다.

## 왜 직접 빌드하는가

Apache 는 이 zip 을 **배포하지 않는다**. `kafka-connect/build.gradle` 에 명시돼 있다.

```groovy
// there are no Maven artifacts so disable publishing tasks
project.tasks.matching { it.group == 'publishing' }.each { it.enabled = false }
```

- Maven Central 의 `org.apache.iceberg` 에는 `iceberg-kafka-connect`, `-events`, `-transforms` 만 있다. `-runtime` 은 없다.
- GitHub 릴리스 자산도 0건이다.
- `type: maven` 으로 대체할 수 없다. `iceberg-kafka-connect` POM 의 런타임 의존성은 11개뿐이라 S3FileIO(`iceberg-aws` + AWS SDK), hive-metastore, parquet, orc 가 전부 빠진다. 실제 배포판은 `runtime-deps.txt` 기준 237개 jar 에 exclude·force 규칙이 붙는다.

`databricks/iceberg-kafka-connect`(구 tabular)가 이 zip 을 릴리스로 올려줬으나 **v0.6.19 / 2024-06-06 이후 끊겼다.**

## 쓰는 곳

`k8s-manifests` 의 `k8s-idc/de-data-debezium/connect/02-iceberg-sink-prod-connect.yaml`, KafkaConnect `spec.build.plugins[].artifacts` 가 URL 과 sha512 로 참조한다. 워크플로우가 릴리스 노트에 붙여넣을 YAML 조각을 그대로 출력한다.

## 실행

Actions 탭에서 수동 실행한다. 새 Iceberg 버전이 **GA** 로 나왔을 때만 돌린다.

| 입력 | 설명 |
|------|------|
| `ref` | apache/iceberg 의 git ref. 보통 `apache-iceberg-1.12.0` 같은 태그 |
| `version` | 배포판 버전 문자열. 비우면 `ref` 에서 `apache-iceberg-` 를 뗀다 |
| `draft` | 릴리스를 draft 로 만들지 |

GA 가 아닌 무언가를 빌드해야 하면(예: GA 에 특정 수정을 cherry-pick) apache/iceberg 포크에 브랜치를 만들고 워크플로우의 `repository` 를 그쪽으로 바꿔 실행한다. 워크플로우 안에 패치 로직을 넣지 않는다.

## 함정

**`version.txt` 를 반드시 먼저 써야 한다.** `build.gradle` 의 `getProjectVersion()` 은 `version.txt` 가 없으면 git 태그에서 버전을 읽은 뒤 **MINOR 를 +1 하고 `-SNAPSHOT` 을 붙인다.** 릴리스 태그를 정확히 체크아웃해도 그렇다. `version.txt` 는 릴리스 과정에서만 생성되고 저장소에는 커밋돼 있지 않다. 이걸 안 하면 `apache-iceberg-1.12.0` 을 빌드해도 산출물이 `...-hive-1.13.0-SNAPSHOT.zip` 이 된다.

**`-DsparkVersions= -DflinkVersions= -DkafkaVersions=3` 를 뺴면 안 된다.** Spark/Flink 모듈까지 빌드하느라 시간이 몇 배로 늘어난다. 상류 `kafka-connect-ci.yml` 이 쓰는 셀렉터와 같다.

**JDK 는 17.** 상류 CI 매트릭스가 17/21 이고, 배포 대상 Strimzi Connect 이미지의 런타임도 Java 17 이다.
