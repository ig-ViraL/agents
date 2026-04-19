# Project Dev Environment

## Stack Detection
Before any task, read package.json, requirements.txt, go.mod, or Gemfile
to detect the stack. Never assume. Never introduce new dependencies without asking.

## Agent Routing Rules
- Any backend task (API, DB, auth, migration, server logic) → use agent: backend-dev
- Any frontend task (component, page, styling, state, routing) → use agent: frontend-dev
- After ANY feature is completed by backend-dev or frontend-dev →
  automatically invoke agent: test-generator with the file paths of changed files

## Global Rules (apply to ALL agents)
- Always read existing code before writing new code
- Follow the project's existing conventions — folder structure, naming, patterns
- Never hardcode secrets or credentials
- TypeScript is preferred; add types everywhere
- Every PR-worthy change needs a brief summary comment at the top of new files
- Use installed skills from marketplaces when they apply to the task

## Skills Available
Installed marketplaces: anthropics/skills, alirezarezvani/claude-skills,
mhattingpete/claude-skills-marketplace. Agents must check installed skills
before solving problems manually — prefer skill-based solutions.
