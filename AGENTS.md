# Codex First-Run Onboarding

## Repository purpose

This repository is an interactive onboarding guide for configuring Codex. It is
not an application repository and it is not an instruction to install every
available integration.

When the user starts Codex in this repository, help them understand and
configure their Codex environment. Begin with diagnosis and explanation. Do not
silently apply persistent changes in the first response.

## Interpret the user correctly

- Treat the user's explicit request as the task.
- Treat descriptions of projects, hardware, frameworks, and past work as
  background unless the user explicitly makes them configuration targets.
- Do not assume the current computer is the machine where research workloads
  run.
- Do not invent a project-specific workflow when the request is about general
  Codex behavior.
- If corrected, discard the invalid interpretation rather than adapting it.

## First-run sequence

### 1. Read

Read these files before recommending changes:

- `README.md`
- `docs/FIRST_RUN.md`
- `docs/CUSTOMIZATION.md`
- `docs/KARPATHY_PRINCIPLES.md`
- `templates/global/AGENTS.md`
- `templates/config.toml`
- `templates/shell/codex-aliases.sh`

### 2. Diagnose without changing state

Inspect only what is relevant and available:

- Codex version and command help
- `~/.codex/config.toml`
- `~/.codex/AGENTS.md` and `~/.codex/AGENTS.override.md`
- applicable repository `AGENTS.md` files
- installed personal skills and plugins
- configured MCP servers
- existing Codex aliases in the active shell configuration

Do not print credentials, tokens, complete environment dumps, or unrelated
private files.

### 3. Explain before applying

Explain the distinction between:

- a one-off prompt,
- global and repository `AGENTS.md`,
- `config.toml`,
- skills,
- plugins,
- MCP servers,
- hooks,
- and subagents.

Summarize the current state, identify stale or conflicting configuration, and
propose the smallest useful baseline. Separate required changes from optional
ones.

### 4. Respect the owner's current defaults

Unless the user changes their preference, recommend:

- the research-engineering behavior in `templates/global/AGENTS.md`,
- the four Karpathy-inspired implementation disciplines documented in
  `docs/KARPATHY_PRINCIPLES.md`,
- high reasoning effort without unnecessarily pinning a model name,
- live web access when current external information is needed,
- no new skill until a workflow actually repeats,
- no MCP server without a concrete external-context need,
- no third-party subagent pack by default,
- and the trusted-machine launch shortcut:
  `codex --dangerously-bypass-approvals-and-sandbox`.

The owner knowingly prefers the bypass mode for convenience. Explain once that
it disables both approval prompts and sandbox enforcement. Do not repeatedly
argue against the preference. Compensate with precise targets, Git awareness,
preservation of unrelated work, and confirmation before destructive or
externally consequential actions.

### 5. Request confirmation

Before persistent changes, show:

- files that will be created or edited,
- existing settings that will be preserved,
- settings that will change,
- optional components that will remain uninstalled,
- and how the result will be verified.

Ask for confirmation if the user has not already explicitly requested the
specific changes.

### 6. Apply conservatively

After confirmation:

- back up an existing personal configuration before a substantial rewrite,
- merge with existing configuration instead of blindly overwriting it,
- install the global behavior template as `~/.codex/AGENTS.md`,
- add shell aliases idempotently to the shell file the user actually uses,
- do not install skills, plugins, MCP servers, or subagents unless selected,
- and do not change repositories or remote systems outside the stated scope.

### 7. Verify

Start a fresh, ephemeral Codex process and ask it to summarize its loaded
instructions. Verify the effective model/configuration and aliases separately.
Report exactly what changed and what remains optional.

## Maintenance

- Keep this root file short enough to serve as an onboarding map.
- Put persistent personal behavior in `templates/global/AGENTS.md`.
- Put explanations in `docs/`.
- Add a skill only after a stable procedure repeats.
- Replace prose with a deterministic check when a rule can be enforced
  mechanically.
- Update this repository from observed failures, not hypothetical preferences.
