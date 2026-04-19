# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

This is **not** an application — it's a bundle of custom Claude Code agents
that get installed into *other* projects. There is nothing to compile, no
test suite, and no runtime. Work in this repo is almost entirely:

- Editing agent definitions under `.claude/agents/*.md`
- Maintaining the two install scripts (`install.sh`, `install.ps1`)
- Keeping `README.md` in sync with the agent set

The `CLAUDE.md` in this repo is local guidance for editing the bundle itself.
It is **not** copied into consumer projects — `install.sh` / `install.ps1`
only ship the agent `.md` files.

## Repo architecture

Five agents form a pipeline that runs inside consumer projects:

```
project-scout  →  requirements-planner  →  backend-dev / frontend-dev  →  test-generator
  (once per          (per feature —            (execution;                   (auto after
   clone; writes      asks Qs, plans,           loads viral-agents.md)        handoff block)
   viral-agents.md)   awaits approval)
```

- `project-scout` is the bootstrap. It scans a consumer project once and
  writes a compact `viral-agents.md` profile at that project's root.
- All other agents load `viral-agents.md` at the start of their task instead
  of re-detecting the stack. This is the load-bearing contract — don't add
  stack-detection steps back into downstream agents.
- `test-generator` auto-triggers on the handoff block printed by the dev
  agents. The exact string `→ Handing off to test-generator` is the trigger;
  don't rephrase it.

## Agent file contract

Each file in `.claude/agents/` is a single markdown document with YAML
frontmatter:

```yaml
---
name: <kebab-case-name>           # must match the filename stem
description: >                    # Claude Code reads this to decide when to invoke
  <one-paragraph trigger spec, including "use when…" and "do NOT use for…">
---
```

Conventions followed across all five agents (keep consistent when editing):

- **Identity** section sets tone and one-line core principle
- **On Every Task** (or Phase 1) enforces loading `viral-agents.md` first
- **Rules** sections grouped by concern (API, DB, security, a11y, etc.)
- **Self-Review Checklist** as a markdown checkbox list near the end
- **Handoff** block at the bottom — fenced code block, exact wording matters
  because downstream agents pattern-match on it
- Target length: ≤ 200 lines. If an agent grows past that, the rules are
  probably redundant.

## Install-script contract

`install.sh` and `install.ps1` must stay behaviourally identical. If you add
a flag or change a target path in one, mirror it in the other the same session.

What they do:

1. Copy `.claude/agents/*.md` → `~/.claude/agents/` (global) or
   `<project>/.claude/agents/` (per-project)
2. In per-project mode only: append `.claude/agents/` and `viral-agents.md`
   to the target's `.gitignore`

What they must NOT do:

- Copy `CLAUDE.md` anywhere. This file stays in this repo only.
- Touch any other files in the consumer project.
- Assume network access — the repo is already cloned when the script runs.

Smoke-test a script change by running it against a throwaway project and
confirming the five agent files land in the expected folder:

```bash
./install.sh --project /tmp/fake-proj
ls /tmp/fake-proj/.claude/agents/     # should list all 5 agents
```

## When adding, removing, or renaming an agent

Both scripts use a `*.md` glob so the set is auto-detected — no script change
needed. But update these in the same commit:

- `README.md` — the agent list in "What's inside" and the routing table
- Any cross-references in other agent files (e.g. `requirements-planner`
  names `backend-dev` and `frontend-dev` in its routing section)
- The flow diagram in `README.md` if the pipeline changes

## Commands

There is no build, no lint, no test. The only commands used here are the
install scripts themselves:

```bash
./install.sh --help                        # usage
./install.sh                               # install globally for smoke-test
./install.sh --project /tmp/fake-proj      # install into a throwaway project
```

PowerShell equivalents: `.\install.ps1 -Help`, `.\install.ps1`,
`.\install.ps1 -Project C:\tmp\fake-proj`.
