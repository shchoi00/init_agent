---
name: "physicalai-hdmap-workflow"
description: "Use when working in the PhysicalAI HD map, FuseLoc, LiDAR2Map, or related GPU/data pipeline workspace and the task needs repo orientation, environment checks, run scripts, logs, or verification steps."
---

# PhysicalAI HD Map Workflow

Use this skill for work in the shared workspace that contains `physicalai-hdmap-pipeline`, `FuseLoc`, `LiDAR2Map`, local conda environments, run scripts, logs, and outputs.

## First Checks

1. Confirm the current directory with `pwd`.
2. Inspect the target repo before editing: `rg --files`, `git status --short`, and nearby README files.
3. Check whether the current directory is a git repo before assuming git commands apply.
4. If GPU execution is relevant, run `nvidia-smi` before launching long jobs.
5. Prefer existing scripts in the workspace over inventing new entrypoints.

## Common Workspace Files

Use these files when present:

- `WORKSPACE_RULES.md`
- `QUICK_START.md`
- `ENVIRONMENT_STATUS.md`
- `DATASET_INFO.md`
- `RUN_ALL_CLIPS.sh`
- `run_pipeline.sh`
- `run_parallel_8gpu.py`
- `physicalai-hdmap-pipeline/README.md`
- `physicalai-hdmap-pipeline/docs/`
- `FuseLoc/README.md`
- `LiDAR2Map/README.md`

## Verification Standard

Before saying work is complete:

1. Run the narrowest relevant command or test.
2. Check produced logs or output directories when the command creates artifacts.
3. For viewer or web UI changes, verify the rendered result with a browser or screenshot workflow when available.
4. Report any command that was skipped because it would be long-running, GPU-heavy, or data-dependent.

## Safety

Do not delete datasets, checkpoints, conda environments, runs, logs, or outputs unless the user explicitly asks for cleanup.

Avoid broad rewrites across `FuseLoc`, `LiDAR2Map`, and `physicalai-hdmap-pipeline` at the same time unless the task explicitly requires a cross-repo change.
