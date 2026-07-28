# init_agent — Codex Onboarding

Codex를 처음 설정하거나 오래된 설정을 다시 점검할 때 사용하는 대화형
onboarding 저장소입니다.

이 저장소의 목적은 설정을 무조건 자동 설치하는 것이 아닙니다. Codex가
현재 환경을 읽기 전용으로 진단하고, 각 설정의 의미와 선택지를 먼저 설명한
다음, 사용자가 선택한 것만 적용하게 합니다.

## 시작하기

```sh
git clone -b codex https://github.com/shchoi00/init_agent.git
cd init_agent
codex --dangerously-bypass-approvals-and-sandbox
```

Codex는 루트의 `AGENTS.md`를 자동으로 읽습니다. 첫 메시지는 간단하게
다음처럼 입력하면 됩니다.

```text
이 저장소의 onboarding 지침을 따라 내 Codex 설정을 점검해줘.
먼저 현재 상태와 추천 설정을 설명하고, 변경할 파일을 보여준 뒤 적용해줘.
```

## 첫 실행에서 Codex가 하는 일

1. Codex 버전과 현재 전역 설정을 읽기 전용으로 확인
2. 기존 `AGENTS.md`, config, alias, Skill, MCP, plugin 상태 확인
3. 각 customization surface의 역할 설명
4. 현재 설정에서 오래됐거나 충돌하는 부분 식별
5. 최소 권장안과 선택 항목 분리
6. 변경 대상과 보존할 설정을 먼저 제시
7. 승인된 항목만 적용
8. 새 Codex 프로세스로 실제 로딩 검증

## 현재 기본 방향

- 특정 프로젝트가 아닌 범용 research-engineering 사고 규칙
- 사용자의 명시적 요청과 배경·예시를 엄격히 구분
- 사실, 추론, 가설, 추측과 불확실성을 구분
- 경쟁 가설, 반증 가능성, confounder, leakage와 평가 적합성 검토
- 실제 검증 없이는 완료나 성능 향상을 주장하지 않음
- Karpathy 발언에서 정리된 네 가지 구현 규율을 명시적으로 적용
- 반복 절차가 생기기 전에는 Skill을 만들지 않음
- 실제 외부 문맥 요구가 생기기 전에는 MCP를 추가하지 않음
- 검토되지 않은 제3자 subagent pack을 기본 설치하지 않음

## 권한 기본 선호

이 저장소의 소유자는 신뢰하는 개인 환경에서 아래 실행 방식을 선호합니다.

```sh
codex --dangerously-bypass-approvals-and-sandbox
```

이는 승인 요청과 sandbox를 모두 우회합니다. 위험을 숨기지는 않되, 이 선택을
매번 되돌리려 하지 않습니다. 대신 Git 상태 확인, 정확한 대상 확인, 사용자
변경 보존, 파괴적·외부 영향 작업 전 확인 같은 행동 규칙으로 보완합니다.

편의를 위한 alias 예시는
[`templates/shell/codex-aliases.sh`](templates/shell/codex-aliases.sh)에
있습니다.

## 저장소 구조

```text
.
├── AGENTS.md                         # 첫 실행 agent의 onboarding 절차
├── README.md                         # 사람용 시작 안내
├── docs/
│   ├── FIRST_RUN.md                  # 진단·설명·적용 순서
│   ├── CUSTOMIZATION.md              # 설정 수단별 역할과 선택 기준
│   └── KARPATHY_PRINCIPLES.md        # 출처와 Codex 적용 방식
└── templates/
    ├── global/
    │   └── AGENTS.md                 # 설치할 범용 연구 행동 규칙
    ├── config.toml                   # 보수적인 config 기준안
    └── shell/
        └── codex-aliases.sh          # bypass/default 실행 alias 예시
```

## 중요한 구분

루트 `AGENTS.md`와 `templates/global/AGENTS.md`의 목적은 다릅니다.

- 루트 `AGENTS.md`: 이 저장소에서 처음 설정을 안내하는 agent용 지침
- `templates/global/AGENTS.md`: 사용자 홈의 `~/.codex/AGENTS.md`로
  설치할 개인 행동 규칙

루트 파일 자체를 전역 파일로 복사하면 안 됩니다.

## 업데이트 원칙

설정은 한 번에 완성하지 않습니다. 실제 사용 중 반복되는 실패가 생기면
다음 기준으로 갱신합니다.

```text
반복되는 판단 오류       → global AGENTS.md
저장소에만 해당하는 사실 → repository AGENTS.md
반복되는 작업 절차       → Skill
외부 시스템의 실시간 정보 → MCP/plugin
기계적으로 검사 가능한 규칙 → test/linter/hook
```

Codex의 최신 설정 구조는 공식 문서를 우선합니다.

- [Codex customization](https://learn.chatgpt.com/docs/customization/overview)
- [AGENTS.md](https://learn.chatgpt.com/docs/agent-configuration/agents-md)
- [Codex configuration](https://learn.chatgpt.com/docs/config-file/config-basic)
- [Skills](https://learn.chatgpt.com/docs/build-skills)
- [MCP](https://learn.chatgpt.com/docs/extend/mcp)
- [Karpathy의 원 발언](https://x.com/karpathy/status/2015883857489522876)
- [Karpathy의 neural-network recipe](https://karpathy.github.io/2019/04/25/recipe/)
- [Karpathy autoresearch](https://github.com/karpathy/autoresearch)
