# os-shell

`docker.io/bitnamilegacy/os-shell` 를 대체하는 이미지. bitnami chart 들이 init container
(`volume-permissions` 등) 로 쓰는 셸 유틸리티 이미지다.

이미지: `shepherd9664/os-shell:12-debian-12-<timestamp>`

## 왜 만들었나

bitnami 가 2025-08-28 부터 공개 카탈로그를 `bitnamilegacy` 로 옮기고 업데이트를 중단했다.
`bitnamilegacy/os-shell` 은 `12-debian-12-r51` 에서 멈춰 있고 OS 패키지 갱신이 없다.
init container 라 짧게 뜨고 죽지만 root 로 도는 컨테이너다 — 여기가 낡은 채로 남는 건 곤란하다.

## upstream 과 다른 점

bitnami 원본은 minideb 에 apt 패키지 몇 개를 깔고, stacksmith CDN 에서 헬퍼 바이너리
5개(`yq` / `wait-for-port` / `render-template` / `ini-file` / `scuttle`)를 받아 넣는다.
여기서는 그 CDN 의존을 뺐다 — 그게 애초에 벗어나려는 대상이다.

| | bitnami | 여기 |
|---|---|---|
| base | `bitnami/minideb:bookworm` | 동일 |
| apt | `ca-certificates curl jq procps` | 동일 |
| `yq` | stacksmith 빌드 | `mikefarah/yq` 공식 릴리스 |
| `wait-for-port`, `render-template`, `ini-file`, `scuttle` | stacksmith 빌드 | **없음** |
| user | `1001` (`-g root`) | 동일 |
| `PATH` | `/opt/bitnami/common/bin` 선행 | 동일 |

빠진 헬퍼 4개는 bitnami 자체 빌드라 upstream 소스가 없다. `mongodb-sharded` chart 의
`volume-permissions` 는 `bash` / `mkdir` / `chown` / `find` / `xargs` 만 쓰므로 영향 없다.
다른 chart 를 이 이미지로 돌리려면 그 chart 가 저 헬퍼를 부르는지 먼저 확인해야 한다.

## 제약

- **amd64 전용.** 필요해지면 workflow 의 `platforms` 를 늘리면 된다 (base 도 yq 도 arm64 있음)
- 버전 올리기: workflow 의 `YQ_VERSION` build-arg 만 고치면 된다. 빌드가 `yq --version` 으로 검증한다

## 배포처

helm chart `mongodb-sharded` 의 `volumePermissions.image`
([shepherd44/helm-charts](https://github.com/shepherd44/helm-charts/tree/main/charts/mongodb-sharded)).
