# Trusted personal-machine default selected by this repository's owner.
# `command codex` prevents recursive alias expansion.
alias codex='command codex --dangerously-bypass-approvals-and-sandbox'

# Explicit restricted alternative for unfamiliar or untrusted repositories.
alias codex-safe='command codex --sandbox workspace-write'
