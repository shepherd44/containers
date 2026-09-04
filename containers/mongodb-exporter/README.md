# mongodb-exporter

`docker.io/bitnamilegacy/mongodb-exporter` 를 대체하는 이미지. bitnami 의 디렉터리 계약은
그대로 두고 **바이너리만 Percona 공식 릴리스로 교체**한다.

이미지: `shepherd9664/mongodb-exporter:<version>-debian-12-<timestamp>`

## 왜 만들었나

bitnami 가 2025-08-28 부터 공개 카탈로그를 `bitnamilegacy` 로 옮기고 업데이트를 중단했다.
`bitnamilegacy/mongodb-exporter` 는 `0.47.0-debian-12-r1` 에서 멈췄다. exporter 는
MongoDB 서버 버전을 따라가야 하는데(8.0 계열 컬렉터 대응), 거기서 고정되면 의미가 없다.

## upstream 과 다른 점

bitnami 는 stacksmith CDN 에서 자기들이 빌드한 tarball 을 받는다. 여기서는
[percona/mongodb_exporter](https://github.com/percona/mongodb_exporter) 릴리스 tarball 을
직접 받는다. 같은 소스의 공식 빌드고 정적 링크된 Go 바이너리다.

계약은 유지한다 — chart 가 여기에 의존한다:

| | 값 |
|---|---|
| 바이너리 | `/opt/bitnami/mongodb-exporter/bin/mongodb_exporter` |
| symlink | `/bin/mongodb_exporter` ← chart 가 부르는 경로 |
| user | `1001` |
| port | `9216` |
| `ENTRYPOINT` | `mongodb_exporter` |

`mongodb-sharded` chart 는 `sh -ec` 로 `/bin/mongodb_exporter --collect-all --compatible-mode
--web.listen-address ... --mongodb.uri ...` 를 직접 실행한다. `readOnlyRootFilesystem: true`
로 도는데 이 바이너리는 디스크에 쓰지 않는다.

## 버전 올리는 법

1. [릴리스](https://github.com/percona/mongodb_exporter/releases)에서 `linux-amd64` 에셋 확인
2. `.github/workflows/mongodb-exporter.yml` 의 `EXPORTER_VERSION` build-arg 와 태그 수정
3. push

빌드가 `mongodb_exporter --version` 을 grep 으로 검증한다. 실패하면 멈춘다 — 버전을
올렸는데 조용히 옛 바이너리가 남아 나가면 올린 의미가 없다.

## 제약

- **amd64 전용.** Percona 는 arm64 도 내지만 지금 쓰는 노드가 amd64 라 늘리지 않았다
- bitnami 의 `/opt/bitnami/scripts` 헬퍼는 없다. chart 가 바이너리를 직접 부르므로 필요 없다

## 배포처

helm chart `mongodb-sharded` 의 `metrics.image`
([shepherd44/helm-charts](https://github.com/shepherd44/helm-charts/tree/main/charts/mongodb-sharded)).
