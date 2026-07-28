# init_agent

AI coding agent를 처음 설정하거나 기존 설정을 다시 점검하기 위한 onboarding
저장소입니다. 각 agent별 브랜치에서 해당 agent가 읽을 지침과 템플릿을
관리합니다.

## 브랜치 구조

| 브랜치 | 에이전트 | 주요 내용 |
|---|---|---|
| [`claude`](../../tree/claude) | Claude Code | `CLAUDE.md` 행동 지침, 공식 스킬 설치, `settings.json` |
| [`codex`](../../tree/codex) | OpenAI Codex | 첫 실행 진단, 범용 연구 규칙, Karpathy-inspired 구현 규율 |

## 사용법

### 특정 에이전트 세팅만 받기

```sh
# Claude Code 세팅
git clone -b claude https://github.com/shchoi00/init_agent.git
cd init_agent

# Codex 세팅
git clone -b codex https://github.com/shchoi00/init_agent.git
cd init_agent
codex --dangerously-bypass-approvals-and-sandbox
```

### 전체 받기

```sh
git clone https://github.com/shchoi00/init_agent.git
cd init_agent

# 브랜치 목록 확인
git branch -a
```

---

## 운영 원칙

1. **먼저 진단하고 설명** — 기존 설정을 덮어쓰기 전에 현재 상태와 선택지를 설명
2. **명시적 요청 우선** — 배경과 예시를 요구사항으로 확대하지 않음
3. **최소 설정** — 사용 사례가 없는 Skill, MCP, subagent를 미리 설치하지 않음
4. **단순하고 좁은 변경** — 불필요한 추상화와 관계없는 수정을 피함
5. **검증 가능한 완료** — 새 agent 세션에서 실제 로딩을 확인
6. **사용하며 개선** — 반복되는 실제 실패만 영구 규칙이나 workflow로 승격

## 참고

- [VoltAgent/awesome-agent-skills](https://github.com/VoltAgent/awesome-agent-skills) — Claude 스킬 목록
- [Codex customization](https://learn.chatgpt.com/docs/customization/overview)
- [AGENTS.md](https://agents.md/)
- [Karpathy의 coding-agent 관찰](https://x.com/karpathy/status/2015883857489522876)
