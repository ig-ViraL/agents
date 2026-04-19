# Viral's Claude Code Agents

A bundle of five custom Claude Code agents that route work through planning,
implementation, and testing — plus a one-shot project profiler that keeps each
agent's context small.

## What's inside

```
.
├── install.sh                          # Install script (bash / Git Bash)
├── install.ps1                         # Install script (PowerShell)
├── .claude/
│   └── agents/
│       ├── project-scout.md            # Profiles the repo → viral-agents.md
│       ├── requirements-planner.md     # Clarifies + plans before any build
│       ├── backend-dev.md              # Backend specialist
│       ├── frontend-dev.md             # Frontend specialist
│       └── test-generator.md           # Auto-runs after backend/frontend
├── CLAUDE.md                           # Local — for editing this repo, NOT shipped
└── .gitignore
```

> `CLAUDE.md` is guidance for working in *this* repo only. The install scripts
> do **not** copy it into consumer projects — only the agent `.md` files ship.

## Install

Clone this repo's `main` branch once, then run the installer.

### Global install (recommended — once per machine)

Agents go into `~/.claude/agents/` and apply to **every** project you open.

```bash
git clone --depth 1 --single-branch --branch main <this-repo-url> /tmp/viral-agents
cd /tmp/viral-agents
./install.sh              # bash / Git Bash
# or
.\install.ps1             # PowerShell
cd - && rm -rf /tmp/viral-agents
```

### Per-project install

Drop the agents into one specific project. The script also appends
`.claude/agents/` and `viral-agents.md` to that project's `.gitignore` so
nothing gets committed.

```bash
./install.sh --project /path/to/your/project
# or
.\install.ps1 -Project C:\code\my-app
```

### Flags

- `--help` / `-Help` — usage

Both scripts are idempotent — re-run any time to refresh after you update this repo.

## Flow — how the agents route

```
  ┌───────────────────┐
  │  project-scout    │  (once per clone) → writes viral-agents.md
  └─────────┬─────────┘
            │
  ┌─────────▼─────────┐
  │requirements-planner│  (any new feature/idea) → asks questions → plan → approval
  └─────────┬─────────┘
            │
     ┌──────┴──────┐
     ▼             ▼
┌──────────┐  ┌──────────┐
│backend-  │  │frontend- │
│  dev     │  │  dev     │
└─────┬────┘  └─────┬────┘
      └─────┬───────┘
            ▼
  ┌───────────────────┐
  │  test-generator   │  (auto-triggered after any feature ships)
  └───────────────────┘
```

| Task type                                        | Agent                  |
| ------------------------------------------------ | ---------------------- |
| First-time setup of a clone                      | `project-scout`        |
| New requirement, feature, or vague idea          | `requirements-planner` |
| API, DB, auth, migration, server logic           | `backend-dev`          |
| Component, page, styling, state, routing         | `frontend-dev`         |
| After any feature ships                          | `test-generator` (auto)|

Routing rules live in `CLAUDE.md`. Edit per project as needed.

## viral-agents.md — per-project context file

Every agent loads `./viral-agents.md` at the start of its task instead of
re-scanning `package.json`, config files, and folder trees. This keeps session
context small and consistent across agents.

- Generated once by `project-scout` after you install into a project
- Gitignored by default (per-clone, not shared)
- Re-run `project-scout` whenever the stack, folder layout, or conventions change

## One-time per machine — install skill marketplaces

The agents prefer skills from these marketplaces when they apply. Type each
command in the Claude Code prompt:

```
/plugin marketplace add anthropics/skills
/plugin marketplace add alirezarezvani/claude-skills
/plugin marketplace add mhattingpete/claude-skills-marketplace
```

Then run `/plugin` to browse and install — e.g. `fullstack-engineer`,
`engineering-workflow`, `document-skills`, `example-skills`.

## Updating

After you edit agents in this repo and push:

```bash
cd /tmp/viral-agents && git pull && ./install.sh
```

Or per-project:

```bash
cd /path/to/clone && git pull && ./install.sh --project /path/to/project
```
