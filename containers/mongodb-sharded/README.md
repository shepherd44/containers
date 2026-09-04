# mongodb-sharded

`docker.io/bitnamilegacy/mongodb-sharded` 를 대체하는 이미지. bitnami 스캐폴딩은 그대로 쓰고 **서버 바이너리만 MongoDB 공식 배포본으로 교체**한다.

이미지: `shepherd9664/mongodb-sharded:<version>-debian-12-<timestamp>`

## 왜 만들었나

bitnami 가 2025-08-28 부터 공개 카탈로그를 `bitnamilegacy` 로 옮기고 업데이트를 중단했다. `mongodb-sharded` 는 **8.0.13 이 마지막**이다.

| 확인 대상 | 결과 |
|---|---|
| `bitnami/containers` 의 `mongodb-sharded/8.0` 마지막 릴리스 | `8.0.13-debian-12-r1` (커밋 `657585595c`, 2025-09-07) |
| 그 디렉터리 | 2025-09-19 (`48a109547d`) upstream main 에서 제거됨 |
| `downloads.bitnami.com/.../mongodb-8.0.13-0-linux-amd64-debian-12.tar.gz` | 200 |
| `downloads.bitnami.com/.../mongodb-8.0.14-0-linux-amd64-debian-12.tar.gz` | 404 |
| MongoDB 공식 8.0 LTS 최신 | 8.0.30 (`fastdl.mongodb.org`, debian12 x86_64) |

즉 bitnami 경로로는 8.0.13 에 영구히 묶인다. 그 사이 공식 8.0 은 패치가 17개 더 나왔다.

실제 피해 사례가 있다 (DET-1400). `aiaas-search-mongodb` 의 config server 가 커넥션 풀 밖에서 소켓을 누적해 arbiter 를 OOMKill 로 밀어낸다. 7.0.9 대비 arbiter 메모리 증가율이 3~37배로 뛰었고, 이 수정이 이후 8.0 패치에 있는지 확인하려면 최신 8.0 을 돌려봐야 한다.

## 어떻게 만들었나

`bitnami/containers@657585595c` 의 `bitnami/mongodb-sharded/8.0/debian-12/` 를 통째로 vendoring 했다 (27개 파일). Dockerfile 에서 딱 한 단계만 추가한다:

```
bitnami 스택스미스 tarball (8.0.13) 설치      ← 스크립트·conf.default·templates·database-tools·mongosh
        ↓
공식 fastdl tarball 에서 mongod/mongos 만 덮어쓰기   ← 실제 실행될 서버
```

helm chart `mongodb-sharded` 9.x 가 bitnami 의 `/opt/bitnami/scripts` 계약과 디렉터리 레이아웃에 의존하므로 그 부분은 손대지 않는다. 교체 대상은 `bin/mongod`, `bin/mongos` 두 개뿐이다.

덮어쓰기 후 `mongod --version` / `mongos --version` 을 grep 으로 검증한다. 실패하면 빌드가 멈춘다 — 조용히 8.0.13 이 남은 이미지가 나가면 버전을 올린 의미가 없다.

## 버전 올리는 법

1. 공식 tarball 존재 확인
   ```bash
   curl -I https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-debian12-<ver>.tgz
   ```
2. `.github/workflows/mongodb-sharded.yml` 의 `env.MONGODB_VERSION` 수정
3. push. 워크플로가 빌드 전에 tarball 존재를 한 번 더 확인한다

일회성 빌드는 Actions 의 `workflow_dispatch` 에서 버전을 직접 넣어도 된다.

`BITNAMI_SCAFFOLD_VERSION` 은 8.0.13 에서 **올릴 수 없다**. 그게 존재하는 마지막 스택스미스 tarball 이다.

## 제약

- **amd64 전용.** 공식 debian12 빌드는 x86_64 만 있다 (aarch64 는 403). 다른 arch 는 빌드가 명시적으로 실패한다
- 베이스는 `bitnami/minideb:bookworm` 이라 OS 패키지는 빌드할 때마다 갱신된다. bitnamilegacy 이미지를 그대로 쓰는 것보다 이 점이 낫다
- bitnami 스크립트 자체는 8.0.13 시점에 고정이다. chart 가 요구하는 계약이 바뀌면 vendoring 한 `rootfs`/`prebuildfs` 를 직접 갱신해야 한다

## 배포처

`k8s-idc/aiaas-search-mongodb/helm/values.override.yaml` 의 `image.repository` / `image.tag`.

교체는 config server → shard data → mongos 순서와 롤아웃 확인이 필요하다. 절차는 k8s-manifests 의 `k8s-idc/aiaas-search-mongodb/README.md` "MongoDB 8.0 업그레이드 (런북)" 참조.
