# init_agent

AI 에이전트별 개발 환경 세팅 모음.
각 에이전트마다 전용 브랜치가 있으며, 브랜치를 클론하거나 체크아웃해서 바로 사용합니다.

---

## 브랜치 구조

| 브랜치 | 에이전트 | 주요 내용 |
|---|---|---|
| [`claude`](../../tree/claude) | Claude Code | `CLAUDE.md` 행동 지침, 공식 스킬 설치, `settings.json` |
| [`codex`](../../tree/codex) | OpenAI Codex | 별칭 설정, 서브에이전트, Karpathy 베이스라인 |

---

## 사용법

### 특정 에이전트 세팅만 받기

```sh
# Claude Code 세팅
git clone -b claude https://github.com/shchoi00/init_agent.git
cd init_agent

# Codex 세팅
git clone -b codex https://github.com/shchoi00/init_agent.git
cd init_agent
```

### 전체 받기

```sh
git clone https://github.com/shchoi00/init_agent.git
cd init_agent

# 브랜치 목록 확인
git branch -a
```

---

## 공통 철학

모든 브랜치는 아래 원칙을 공유합니다. (Karpathy-inspired)

1. **코딩 전 먼저 생각** — 컨텍스트 파악 후 계획 수립
2. **단순함 우선** — 가장 단순하고 올바른 해결책
3. **최소 변경** — 필요한 것만, 관련 없는 코드 건드리지 않음
4. **검증 가능한 성공** — 완료 선언 전 반드시 확인
5. **에이전트 신중하게** — 위험 감소 또는 속도 향상 시에만 위임

---

## 참고

- [VoltAgent/awesome-agent-skills](https://github.com/VoltAgent/awesome-agent-skills) — Claude 스킬 목록
- [shchoi00/init_codex](https://github.com/shchoi00/init_codex) — Codex 원본 레포
