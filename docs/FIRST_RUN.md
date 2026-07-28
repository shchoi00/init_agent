# First-run flow

이 문서는 처음 Codex 환경을 설정하는 agent가 따라야 할 대화 순서를
설명합니다.

## 1. 현재 상태 진단

첫 단계는 변경이 아니라 진단입니다. 다음 항목 중 존재하는 것만 확인합니다.

```sh
codex --version
codex --help
test -f ~/.codex/config.toml && sed -n '1,240p' ~/.codex/config.toml
test -f ~/.codex/AGENTS.md && sed -n '1,240p' ~/.codex/AGENTS.md
test -f ~/.codex/AGENTS.override.md &&
  sed -n '1,240p' ~/.codex/AGENTS.override.md
codex mcp list
```

추가 명령은 현재 `codex --help`에 해당 기능이 있을 때만 사용합니다.
credential, token, 전체 환경 변수, 관계없는 개인 파일은 출력하지 않습니다.

## 2. 첫 설명

첫 응답에는 최소한 다음이 포함되어야 합니다.

1. 현재 실제로 로드될 전역 지침 파일
2. `AGENTS.override.md`가 기본 파일을 가리고 있는지
3. 현재 model/reasoning/permission 기본값
4. 기존 alias가 실제로 어떤 권한을 만드는지
5. 설치된 Skill/MCP/plugin 중 현재 목적과 관계없는 항목
6. 필수 변경과 선택 변경의 구분

진단 결과가 없는데 구체적인 환경이나 연구 workflow를 만들어내지 않습니다.

## 3. 추천안

기본 추천안은 다음 세 항목입니다.

### 전역 행동 규칙

`templates/global/AGENTS.md`를 기준으로 기존 전역 파일과 비교합니다.
기존 사용자 규칙이 있으면 덮어쓰지 말고 충돌과 중복을 먼저 설명합니다.

### 실행 설정

`templates/config.toml`은 기준안일 뿐입니다. 현재 model 이름이나 조직 정책을
추측하지 말고, 기존 config에 필요한 필드만 병합합니다.

### shell alias

사용자가 현재 선택한 trusted-machine 기본값은 다음입니다.

```sh
alias codex='command codex --dangerously-bypass-approvals-and-sandbox'
alias codex-safe='command codex --sandbox workspace-write'
```

실제 로그인 shell을 확인하고 `.bashrc` 또는 `.zshrc` 중 하나에만
중복 없이 추가합니다.

## 4. 적용 전 제시할 내용

다음 형식으로 먼저 보고합니다.

```text
현재 상태:
- ...

적용할 변경:
- ~/.codex/AGENTS.md: ...
- ~/.codex/config.toml: ...
- ~/.bashrc 또는 ~/.zshrc: ...

보존할 내용:
- ...

설치하지 않을 선택 항목:
- Skill
- MCP
- plugin
- subagent

검증 방법:
- ...
```

## 5. 적용

- 기존 파일의 실질적인 재작성 전에는 timestamp backup을 만듭니다.
- 템플릿을 기계적으로 덮어쓰지 않고 의미 단위로 병합합니다.
- alias 추가는 여러 번 실행해도 중복되지 않아야 합니다.
- Skill, MCP, plugin, subagent는 사용자가 명시적으로 선택한 경우에만
  설치합니다.

## 6. 검증

새 Codex 프로세스에서 전역 지침을 확인합니다.

```sh
codex exec --ephemeral --skip-git-repo-check --sandbox read-only \
  "도구를 사용하지 말고, 로드한 전역 지침의 핵심을 요약해줘."
```

alias는 새 interactive shell에서 확인합니다.

```sh
bash -ic 'type codex; type codex-safe'
```

마지막 보고에는 변경된 파일, backup 경로, 검증 결과, 적용하지 않은 선택
항목을 포함합니다.
