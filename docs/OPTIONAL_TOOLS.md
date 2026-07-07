# Optional Codex Tools

This file tracks optional tools that are useful after the baseline Codex setup.

## Recommended Order

1. OpenAI Developer Docs MCP
2. Project workflow skill
3. Project-local hooks
4. GitHub tooling
5. Browser or Playwright workflow

## Rationale

These tools map to the current Codex customization surfaces:

- MCP is the right surface for live external documentation and tools. Codex stores MCP server configuration in `config.toml`, either globally or in a trusted project `.codex/config.toml`.
- Skills are the right surface for repeated task workflows. Codex loads only the skill metadata up front, then reads `SKILL.md` when the skill is selected.
- Hooks are the right surface for lifecycle checks around tool calls. The included hook template follows the documented `[[hooks.PreToolUse]]` shape for Bash commands.
- Subagents are still useful, but optional fields such as `model` and `sandbox_mode` inherit from the parent session when omitted. This is why the baseline installer removes hard-coded model pins from installed subagents.

References:

- MCP: https://developers.openai.com/codex/mcp
- Skills: https://developers.openai.com/codex/skills
- Hooks: https://developers.openai.com/codex/hooks
- Subagents: https://developers.openai.com/codex/subagents

## OpenAI Developer Docs MCP

Use this first. It gives Codex direct access to current OpenAI developer docs through MCP.

```sh
codex mcp add openaiDeveloperDocs --url https://developers.openai.com/mcp
codex mcp list
```

Codex stores MCP configuration in `config.toml`. Use user-level config for personal tools, or project `.codex/config.toml` for trusted project-scoped tools.

Reference: https://developers.openai.com/codex/mcp

## Project Workflow Skill

Use a skill when the workflow is repeated often and needs stable instructions, references, or scripts.

Template:

```text
templates/skills/physicalai-hdmap-workflow/SKILL.md
```

Install:

```sh
bash install_optional_tools.sh project-skill
```

Codex skills use progressive disclosure: Codex sees the skill metadata first and reads the full `SKILL.md` only when the skill is selected.

Reference: https://developers.openai.com/codex/skills

## Project Hooks

Use hooks for lifecycle checks around tool calls. The included template blocks a few obviously destructive shell commands and lets everything else proceed.

Template:

```text
templates/project-codex/config.toml
templates/hooks/pre_tool_use_policy.py
```

Install:

```sh
bash install_optional_tools.sh project-hooks
```

Project-local hooks only load when the project is trusted. Review the copied `.codex/` files before relying on them.

Reference: https://developers.openai.com/codex/hooks

## GitHub Tooling

Prefer the GitHub CLI (`gh`) for repo work when available:

```sh
gh auth status
gh pr status
gh pr checks
gh issue list
```

Use this with Codex review/debug workflows so PR metadata and CI logs can be inspected directly.

## Browser And Playwright Workflow

For apps with a viewer or web UI, keep a standard verification command in `AGENTS.md` or a project skill. Codex can then run a dev server, inspect screenshots, and verify rendered state instead of relying on static code review.

Useful project targets:

```text
physicalai-hdmap-pipeline/viewer/
```

## Install Everything

```sh
bash install_optional_tools.sh all
```
