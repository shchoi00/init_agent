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

```sh
mkdir -p ~/.codex/agents

# AI/ML 에이전트
for agent in ai-engineer llm-architect machine-learning-engineer ml-engineer mlops-engineer nlp-engineer data-engineer data-scientist prompt-engineer; do
    cp categories/05-data-ai/${agent}.toml ~/.codex/agents/ 2>/dev/null || true
done

# 코드 품질
for agent in python-pro reviewer debugger; do
    cp categories/02-language-specialists/${agent}.toml ~/.codex/agents/ 2>/dev/null || true
    cp categories/04-quality-security/${agent}.toml ~/.codex/agents/ 2>/dev/null || true
done
```

---

## 3. 검증

```sh
command -v codex
alias codex
ls ~/.codex/agents/
```

---

## 참고

- [shchoi00/init_codex](https://github.com/shchoi00/init_codex) — 원본 레포
- [VoltAgent/awesome-codex-subagents](https://github.com/VoltAgent/awesome-codex-subagents) — 서브에이전트 목록
