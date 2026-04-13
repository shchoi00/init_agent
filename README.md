# init_claude

Claude Code 환경을 빠르게 세팅하기 위한 bootstrap 가이드.
[init_codex](https://github.com/shchoi00/init_codex)의 Claude Code 버전.

---

## 목표

이 레포를 클론하면 Claude Code가:

1. `CLAUDE.md`를 읽고 행동 지침을 로드한다.
2. 유용한 공식 스킬을 설치한다.
3. `~/.claude/settings.json`을 설정한다.
4. 모든 변경사항을 검증한다.

---

## 1. CLAUDE.md 배포

프로젝트 루트에 `CLAUDE.md`를 두면 Claude Code가 자동으로 읽어들입니다.
전역 적용을 원한다면 홈 디렉토리에 복사하세요.

```sh
# 전역 적용 (선택)
cp CLAUDE.md ~/CLAUDE.md
```

---

## 2. 공식 Claude 스킬 설치

[VoltAgent/awesome-agent-skills](https://github.com/VoltAgent/awesome-agent-skills?tab=readme-ov-file#official-claude-skills)에서 큐레이션된 Anthropic 공식 스킬 목록.

### 권장 스킬 (우선순위 순)

```sh
# MCP 서버 생성 — 외부 API 연동
claude skills install anthropics/mcp-builder

# 웹앱 테스트 — Playwright 기반 로컬 테스트
claude skills install anthropics/webapp-testing

# 새 스킬 제작 가이드
claude skills install anthropics/skill-creator

# 문서 처리
claude skills install anthropics/pdf
claude skills install anthropics/docx
claude skills install anthropics/xlsx

# UI / 프론트엔드
claude skills install anthropics/frontend-design
claude skills install anthropics/web-artifacts-builder
```

### 전체 공식 스킬 목록

| 스킬 | 설명 |
|---|---|
| `anthropics/docx` | Word 문서 생성·편집·분석 |
| `anthropics/doc-coauthoring` | 문서 협업 편집 |
| `anthropics/pptx` | PowerPoint 생성·편집·분석 |
| `anthropics/xlsx` | Excel 생성·편집·분석 |
| `anthropics/pdf` | PDF 텍스트 추출·생성·폼 처리 |
| `anthropics/algorithmic-art` | p5.js 기반 생성 아트 |
| `anthropics/canvas-design` | PNG/PDF 비주얼 디자인 |
| `anthropics/frontend-design` | 프론트엔드 UI/UX 개발 |
| `anthropics/slack-gif-creator` | Slack용 GIF 생성 |
| `anthropics/theme-factory` | 아티팩트 테마 생성·적용 |
| `anthropics/web-artifacts-builder` | React + Tailwind HTML 아티팩트 |
| `anthropics/mcp-builder` | MCP 서버 생성 |
| `anthropics/webapp-testing` | Playwright 로컬 웹앱 테스트 |
| `anthropics/brand-guidelines` | Anthropic 브랜드 가이드라인 |
| `anthropics/internal-comms` | 상태 보고서·뉴스레터 작성 |
| `anthropics/skill-creator` | 스킬 제작 가이드 |
| `anthropics/template` | 새 스킬 기본 템플릿 |

---

## 3. settings.json 설정

`~/.claude/settings.json`에 기본 권한과 환경 설정을 적용합니다.

```sh
cat > ~/.claude/settings.json << 'EOF'
{
  "permissions": {
    "allow": [
      "Bash(git:*)",
      "Bash(python3:*)",
      "Bash(pip:*)",
      "Bash(npm:*)",
      "Bash(ls:*)",
      "Bash(mkdir:*)",
      "Bash(cp:*)",
      "Bash(mv:*)"
    ]
  }
}
EOF
```

---

## 4. 검증 체크리스트

세팅 완료 후 아래 명령으로 확인합니다.

```sh
# Claude Code 설치 확인
command -v claude

# 스킬 설치 확인
claude skills list

# CLAUDE.md 위치 확인
ls -la ~/CLAUDE.md 2>/dev/null || ls -la ./CLAUDE.md

# settings.json 확인
cat ~/.claude/settings.json
```

---

## 5. 행동 지침

`CLAUDE.md`에 정의된 5가지 핵심 원칙:

1. **코딩 전 먼저 생각** — 컨텍스트를 파악하고 계획 수립
2. **단순함 우선** — 가장 단순하고 올바른 해결책 선택
3. **최소 변경** — 필요한 것만 수정, 관련 없는 코드 건드리지 않음
4. **검증 가능한 성공 정의** — 완료 선언 전 반드시 확인
5. **에이전트를 신중하게** — 위험 감소 또는 속도 향상 시에만 서브에이전트 위임

---

## 참고

- [VoltAgent/awesome-agent-skills](https://github.com/VoltAgent/awesome-agent-skills) — Claude 스킬 목록
- [init_codex](https://github.com/shchoi00/init_codex) — Codex 버전 원본
- [Claude Code 공식 문서](https://docs.anthropic.com/claude-code)
