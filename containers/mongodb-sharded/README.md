# mongodb-sharded

`docker.io/bitnamilegacy/mongodb-sharded` 를 대체하는 이미지. bitnami 스캐폴딩은 그대로 쓰고 **서버 바이너리만 MongoDB 공식 배포본으로 교체**한다.

이미지: `shepherd9664/mongodb-sharded:<version>-debian-12-<timestamp>`

## 왜 만들었나

bitnami 가 2025-08-28 부터 공개 카탈로그를 `bitnamilegacy` 로 옮기고 업데이트를 중단했다. 시리즈별로 마지막 릴리스에서 멈췄고, 스택스미스 tarball 도 그 버전까지만 존재한다.

실제 피해 사례가 있다 (DET-1400). `aiaas-search-mongodb` 의 config server 가 커넥션 풀 밖에서 소켓을 누적해 arbiter 를 OOMKill 로 밀어낸다. 7.0.9 대비 arbiter 메모리 증가율이 3~37배로 뛰었고, 이 수정이 이후 8.0 패치에 있는지 확인하려면 최신 8.0 을 돌려봐야 한다. bitnami 경로로는 그게 불가능하다.

## 시리즈

| 시리즈 | bitnami 스캐폴딩 | upstream 출처 | 기본 서버 버전 | 성격 |
|---|---|---|---|---|
| `8.0/` | 8.0.13-0 (마지막) | `bitnami/containers@657585595c` (2025-09-07) | 8.0.30 | **LTS.** 운영이 쓰는 계열 |
| `8.1/` | **없음** → 8.2.7-2 차용 | `bitnami/containers@350503ffe7` (2026-05-08) | 8.1.3 | rapid release, LTS 아님. 테스트용 |
| `8.2/` | 8.2.7-2 (마지막) | `bitnami/containers@350503ffe7` (2026-05-08) | 8.2.12 | 다음 후보 |

확인된 사실:

- bitnami 가 실제로 만든 시리즈는 **7.0 / 8.0 / 8.2 / 8.3** 뿐이다. **8.1 은 없다** — rapid release 라 건너뛰었다
- 8.0 디렉터리는 2025-09-19 (`48a109547d`), 8.2 디렉터리는 2026-05-12 (`ba22d84d9a`) 에 upstream main 에서 제거됐다. 그래서 커밋 해시로 끄집어내 vendoring 했다
- 스택스미스 tarball: `mongodb-8.0.13-0-...` 200 / `mongodb-8.0.14-0-...` **404**
- 공식 fastdl debian12 최신: 8.0.30, 8.1.3, 8.2.12

**8.1 주의.** bitnami 스캐폴딩이 없어 8.2 것을 빌려 쓴다. 스크립트가 8.1 서버로 검증된 적이 없다. 게다가 rapid release 라 8.2 가 나온 시점에 이미 지원이 끝났다. 운영 후보가 아니라 재현 테스트용이다.

## 어떻게 만들었나

각 시리즈 디렉터리에 bitnami 의 `debian-12/` 를 통째로 vendoring 했다 (시리즈당 27개 파일). Dockerfile 에서 딱 한 단계만 추가한다:

```
bitnami 스택스미스 tarball 설치        ← 스크립트·conf.default·templates·database-tools·mongosh
        ↓
공식 fastdl tarball 에서 mongod/mongos 만 덮어쓰기   ← 실제 실행될 서버
```

helm chart `mongodb-sharded` 9.x 가 bitnami 의 `/opt/bitnami/scripts` 계약과 디렉터리 레이아웃에 의존하므로 그 부분은 손대지 않는다. 교체 대상은 `bin/mongod`, `bin/mongos` 두 개뿐이다.

덮어쓰기 후 `mongod --version` / `mongos --version` 을 grep 으로 검증한다. 실패하면 빌드가 멈춘다 — 조용히 스캐폴딩 버전이 남은 이미지가 나가면 버전을 올린 의미가 없다.

## 버전 올리는 법

1. 공식 tarball 존재 확인
   ```bash
   curl -I https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-debian12-<ver>.tgz
   ```
2. `.github/workflows/mongodb-sharded.yml` 의 `matrix.include` 에서 해당 시리즈 `version` 수정
3. push. 워크플로가 빌드 전에 tarball 존재를 한 번 더 확인하고, 버전이 시리즈와 맞는지도 검사한다

일회성 빌드는 Actions 의 `workflow_dispatch` 에서 `series` 와 `mongodb_version` 을 지정한다. 버전 오버라이드는 시리즈를 명시했을 때만 먹는다 — 안 그러면 8.0 빌드에 8.2 버전이 박힌다.

`BITNAMI_SCAFFOLD_VERSION` 은 **올릴 수 없다.** 각 시리즈의 마지막 스택스미스 tarball 이다.

## 제약

- **amd64 전용.** 공식 debian12 빌드는 x86_64 만 있다 (aarch64 는 403). 다른 arch 는 빌드가 명시적으로 실패한다
- 베이스는 `bitnami/minideb:bookworm` 이라 OS 패키지는 빌드할 때마다 갱신된다. bitnamilegacy 이미지를 그대로 쓰는 것보다 이 점이 낫다
- bitnami 스크립트 자체는 각 시리즈의 마지막 릴리스 시점에 고정이다. chart 가 요구하는 계약이 바뀌면 vendoring 한 `rootfs`/`prebuildfs` 를 직접 갱신해야 한다
- 8.3 은 아직 upstream main 에 살아 있어서 여기에 만들지 않았다. 필요해지면 같은 방식으로 추가한다

## 배포처

`k8s-idc/aiaas-search-mongodb/helm/values.override.yaml` 의 `image.repository` / `image.tag`.

교체는 config server → shard data → mongos 순서와 롤아웃 확인이 필요하다. 절차는 k8s-manifests 의 `k8s-idc/aiaas-search-mongodb/README.md` "MongoDB 8.0 업그레이드 (런북)" 참조.
