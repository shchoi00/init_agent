# init_agent — Claude Branch

Claude Code 환경 세팅.

> 전체 구조는 [main 브랜치](../../tree/main) 참조.

---

## 목표

이 브랜치를 클론하면 Claude Code가:

1. alias로 full permission 위임
2. `CLAUDE.md` 행동 지침 로드
3. `~/.claude/settings.json` 권한 설정
4. 모든 변경사항 검증

---

## 1. 별칭 설정

Codex의 `--sandbox danger-full-access`에 대응. 모든 권한을 Claude에 위임.

```sh
# bash
echo 'alias claude="claude --dangerously-skip-permissions"' >> ~/.bashrc && source ~/.bashrc

# zsh
echo 'alias claude="claude --dangerously-skip-permissions"' >> ~/.zshrc && source ~/.zshrc
```

---

## 2. CLAUDE.md 배포

프로젝트 루트에 `CLAUDE.md`를 두면 Claude Code가 자동으로 읽어들입니다.
전역 적용:

```sh
cp CLAUDE.md ~/CLAUDE.md
```

---

## 3. settings.json 설정

```sh
cat > ~/.claude/settings.json << 'EOF'
{
  "permissions": {
    "allow": [
      "Bash(git:*)",
      "Bash(python3:*)",
      "Bash(pip:*)",
      "Bash(pip3:*)",
      "Bash(npm:*)",
      "Bash(ls:*)",
      "Bash(mkdir:*)",
      "Bash(cp:*)",
      "Bash(mv:*)",
      "Bash(rm:*)",
      "Bash(cat:*)",
      "Bash(echo:*)",
      "Bash(which:*)",
      "Bash(chmod:*)"
    ]
  }
}
EOF
```

---

## 4. 검증

```sh
command -v claude
alias claude
ls -la ~/CLAUDE.md
cat ~/.claude/settings.json
```

---

## 참고

- [VoltAgent/awesome-agent-skills](https://github.com/VoltAgent/awesome-agent-skills) — Claude 스킬 목록
- [Claude Code 공식 문서](https://docs.anthropic.com/claude-code)
