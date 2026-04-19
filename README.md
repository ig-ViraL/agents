# Claude Code Dev Environment Template

A reusable starter for new projects. Clone it and you instantly get a routed
multi-agent setup (backend, frontend, test) plus a global `CLAUDE.md`.

## What's inside

```
.
├── CLAUDE.md                       # Global rules + agent routing
├── .claude/
│   └── agents/
│       ├── backend-dev.md          # Backend specialist
│       ├── frontend-dev.md         # Frontend specialist
│       └── test-generator.md       # Auto-runs after the others
└── .gitignore
```

## Usage

### Option A — start a brand-new project from this template

```bash
git clone <this-repo-url> my-new-project
cd my-new-project
rm -rf .git && git init -b main      # detach from the template's history
```

Then open the folder in Claude Code. Agents are picked up automatically.

### Option B — drop the agents into an existing project

```bash
# from inside an existing repo
git clone <this-repo-url> /tmp/agents-template
cp -r /tmp/agents-template/.claude .
cp /tmp/agents-template/CLAUDE.md .   # or merge with your existing CLAUDE.md
```

## One-time per machine — install skill marketplaces

These are slash commands; type each one in the Claude Code prompt:

```
/plugin marketplace add anthropics/skills
/plugin marketplace add alirezarezvani/claude-skills
/plugin marketplace add mhattingpete/claude-skills-marketplace
```

Then run `/plugin` to browse each marketplace and install the plugins you want
(e.g. `fullstack-engineer`, `engineering-workflow`, `document-skills`,
`example-skills`). The exact `name@marketplace` IDs are visible in the
`/plugin` browser.

## How the agents route

| Task type                           | Agent          |
| ----------------------------------- | -------------- |
| API, DB, auth, migration, server    | `backend-dev`  |
| Component, page, styling, state     | `frontend-dev` |
| After any feature ships             | `test-generator` (auto) |

Routing rules live in `CLAUDE.md`. Edit per project as needed.
