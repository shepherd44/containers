# jmx-exporter

[Prometheus JMX exporter](https://github.com/prometheus/jmx_exporter) as a standalone
HTTP server, for use as a metrics sidecar next to a JVM that exposes JMX/RMI.

이미지: `shepherd9664/jmx-exporter:<version>-<timestamp>`

## 왜 만들었나

prometheus/jmx_exporter 는 **jar 만 배포하고 공식 컨테이너 이미지가 없다.** helm chart 들이
관행적으로 쓰던 이미지들은 전부 죽었다:

| 이미지 | 마지막 갱신 |
|---|---|
| `solsson/kafka-prometheus-jmx-exporter` | 2020-04-23 |
| `sscaling/jmx-prometheus-exporter` | 2019-10-06 |
| `bitnami/jmx-exporter` | 버전 태그 제거 (bitnamilegacy 로 이동) |

`solsson` 이미지는 JDK 8 기반이라 chart 들이 그에 맞춰 `-XX:+UseCGroupMemoryLimitForHeap`,
`-XX:MaxRAMFraction=1` 같은 **JDK 11 에서 제거된 플래그**를 커맨드에 박아 두고 있다. 이미지를
바꾸려면 그 커맨드도 같이 고쳐야 한다.

## 구성

- base: `eclipse-temurin:21-jre-noble`
- `jmx_prometheus_standalone-<version>.jar` 를 GitHub 릴리스에서 받아 sha256 검증
- user `10001` (chart 들이 이 사이드카에 쓰던 uid)
- `ENTRYPOINT` 가 jar 이므로 인자만 넘기면 된다

```
java -jar jmx_prometheus_standalone.jar <port> <configFile>
```

1.x 는 `jmx_prometheus_httpserver.jar` 가 `jmx_prometheus_standalone.jar` 로 이름이 바뀌었다.
인자 형태(포트, 설정파일)는 같아서 기존 chart 커맨드에서 jar 이름과 JVM 플래그만 고치면 된다.

설정 파일 키는 하위호환된다 — `whitelistObjectNames` / `blacklistObjectNames` 는 1.6.0 에서도
동작하지만 `includeObjectNames` / `excludeObjectNames` 가 현재 이름이다.

## 버전 올리는 법

1. [릴리스](https://github.com/prometheus/jmx_exporter/releases) 확인
2. `.github/workflows/jmx-exporter.yml` 의 `JMX_EXPORTER_VERSION` build-arg 와 태그 수정
3. push

빌드가 sha256 을 검증하고, 받은 jar 가 현재 JRE 에서 실제로 기동하는지(`usage` 출력) 확인한다.
둘 중 하나라도 실패하면 빌드가 멈춘다.

## 배포처

helm chart `cp-schema-registry` 의 `schema_registry.prometheus.jmx.image`
([shepherd44/helm-charts](https://github.com/shepherd44/helm-charts/tree/main/charts/cp-schema-registry)).
그 chart 에서 사이드카는 기본 비활성이다.
