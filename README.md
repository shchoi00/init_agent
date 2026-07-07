# init_agent — Codex Branch

OpenAI Codex 환경 세팅.
원본: [shchoi00/init_codex](https://github.com/shchoi00/init_codex)

> 전체 구조는 [main 브랜치](../../tree/main) 참조.

---

## 목표

이 브랜치를 클론하면 Codex가:

1. `AGENTS.md`를 읽고 행동 지침을 로드한다.
2. `codex --sandbox danger-full-access` 별칭을 쉘에 추가한다.
3. AI/ML 서브에이전트를 `~/.codex/agents/`에 설치한다.
4. 모든 변경사항을 검증한다.

---

## 빠른 설치

```sh
git clone -b codex https://github.com/shchoi00/init_agent.git
cd init_agent
bash install_codex.sh
```

설치 스크립트는 아래 작업을 수행한다.

1. 현재 쉘 설정 파일에 Codex 별칭을 중복 없이 추가한다.
2. `VoltAgent/awesome-codex-subagents`에서 필요한 `.toml` 파일을 받는다.
3. 선택한 서브에이전트를 `~/.codex/agents/`에 설치한다.
4. 서브에이전트의 `model = ...` 고정을 제거해서 현재 Codex 기본 모델을 상속하게 한다.
5. `codex`, alias, 설치된 agent 목록을 검증한다.

---

## 1. 별칭 설정

```sh
# zsh
echo 'alias codex="codex --sandbox danger-full-access"' >> ~/.zshrc && source ~/.zshrc

# bash
echo 'alias codex="codex --sandbox danger-full-access"' >> ~/.bashrc && source ~/.bashrc
```

---

## 2. 서브에이전트 설치

[VoltAgent/awesome-codex-subagents](https://github.com/VoltAgent/awesome-codex-subagents) 기반.
이 저장소에는 `categories/` 디렉터리를 직접 포함하지 않으므로, 먼저 서브에이전트 저장소를 받아야 한다.

```sh
git clone --depth 1 --branch add-categories https://github.com/VoltAgent/awesome-codex-subagents.git
mkdir -p ~/.codex/agents

# AI/ML 에이전트
for agent in ai-engineer llm-architect machine-learning-engineer ml-engineer mlops-engineer nlp-engineer data-engineer data-scientist prompt-engineer; do
    grep -v '^model = ' awesome-codex-subagents/categories/05-data-ai/${agent}.toml > ~/.codex/agents/${agent}.toml
done

# 코드 품질
for agent in python-pro reviewer debugger; do
    if [ -f awesome-codex-subagents/categories/02-language-specialists/${agent}.toml ]; then
        grep -v '^model = ' awesome-codex-subagents/categories/02-language-specialists/${agent}.toml > ~/.codex/agents/${agent}.toml
    else
        grep -v '^model = ' awesome-codex-subagents/categories/04-quality-security/${agent}.toml > ~/.codex/agents/${agent}.toml
    fi
done
```

---

## 3. 검증

```sh
command -v codex
alias codex
ls ~/.codex/agents/
grep -R '^model = ' ~/.codex/agents/*.toml
```

마지막 `grep` 명령이 아무것도 출력하지 않으면 서브에이전트가 특정 모델에 고정되지 않은 상태다.

---

## 4. 선택 도구

기본 설치 후에는 아래 도구를 추가하면 최신 문서 확인, 반복 워크플로우, 안전 체크가 편해진다.

```sh
bash install_optional_tools.sh all
```

포함 항목:

1. OpenAI Developer Docs MCP
2. PhysicalAI/HD map 프로젝트 워크플로우 skill 템플릿
3. 프로젝트 로컬 hook/config 템플릿

OMX는 Node.js 20+ 의존성과 setup scope 선택이 필요하므로 별도로 설치한다.
Node.js가 없으면 사용자 로컬 경로에 자동 설치하고, 기본값으로 user/plugin setup과 doctor까지 실행한다.

```sh
bash install_optional_tools.sh omx
```

자세한 내용은 [`docs/OPTIONAL_TOOLS.md`](docs/OPTIONAL_TOOLS.md)를 본다.

---

## 참고

- [shchoi00/init_codex](https://github.com/shchoi00/init_codex) — 원본 레포
- [VoltAgent/awesome-codex-subagents](https://github.com/VoltAgent/awesome-codex-subagents) — 서브에이전트 목록
