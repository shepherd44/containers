#!/usr/bin/env bash
set -euo pipefail

# 환경변수 기반 설정 렌더링.
# HMS_RENDER_CONF="src:dst[,src:dst...]" 를 지정하면, 각 템플릿(src) 파일의 ${VAR}
# placeholder 를 환경변수 값으로 치환해 dst 로 출력한다. DB 비밀번호 / S3 키 등
# credential 을 설정 파일 평문 대신 env(예: k8s Secret)로 주입하기 위함이다.
# 미지정 시 아무 동작도 하지 않으므로 기존 사용 방식과 호환된다.
if [[ -n "${HMS_RENDER_CONF:-}" ]]; then
  IFS=',' read -ra _entries <<< "${HMS_RENDER_CONF}"
  for _entry in "${_entries[@]}"; do
    _src="${_entry%%:*}"
    _dst="${_entry#*:}"
    if [[ -z "${_src}" || "${_src}" == "${_entry}" ]]; then
      echo "[start.sh] invalid HMS_RENDER_CONF entry: '${_entry}' (expected src:dst)" >&2
      exit 1
    fi
    if [[ ! -f "${_src}" ]]; then
      echo "[start.sh] template not found: ${_src}" >&2
      exit 1
    fi
    echo "[start.sh] rendering ${_src} -> ${_dst}"
    # 정의된 환경변수만 치환하고, 미정의 placeholder 는 원형을 유지한다.
    # 치환값을 정규식 replacement 가 아닌 $ENV 조회로 처리하므로 비밀번호의
    # 특수문자(/, &, $ 등)도 안전하다.
    perl -pe 's/\$\{(\w+)\}/exists $ENV{$1} ? $ENV{$1} : $&/ge' "${_src}" > "${_dst}"
  done
fi

exec "$@"
