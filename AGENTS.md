# AGENTS.md — How coding agents work in this repository

This is the operating protocol for **any** coding agent (Copilot, Cursor, Claude Code, Windsurf…) working on the
**Brasaland Digital** monorepo. It is mandatory. If an instruction here conflicts with a user prompt, stop and ask.

## 1. Read at the start of every session

Read these files **in this order** before proposing or writing any change:

1. [`memory-bank/projectbrief.md`](./memory-bank/projectbrief.md) — business context: who Brasaland is, the problem, objectives, business constraints.
2. [`memory-bank/techContext.md`](./memory-bank/techContext.md) — technical context: stack, monorepo map, decisions, technical constraints.
3. [`memory-bank/progress.md`](./memory-bank/progress.md) — current state, next steps, open questions.
4. [`.agents/rules/`](./.agents/rules/) — every rule with `scope: always`, plus any rule whose `globs` match the files you will touch.
5. The `README.md` of every folder you are about to modify or create something in.

Consult [`BRIEFING.md`](./BRIEFING.md) (business source of truth) whenever a business fact is needed or unclear.

Before writing code, state in one or two lines what you understood from the memory bank and which folder the work belongs to.

## 2. Where code goes

Application code goes **only** into the folders already mapped by the template:

| What                          | Where              |
| ----------------------------- | ------------------ |
| Public corporate website      | `uis/website/`     |
| Internal company app          | `uis/backoffice/`  |
| Backend APIs and workers      | `services/`        |

Never create parallel trees (`apps/`, `frontend/`, `backend/`, `src/` at the root…). Full map and rules:
[`.agents/rules/monorepo-structure.md`](./.agents/rules/monorepo-structure.md).

## 3. Mandatory workflow before every commit

Execute these steps **in order**. Do not skip or reorder them. If a step fails, fix it and restart from step 1.

1. **Check the branch** — `git branch --show-current` must not be `main`. Use `feature/…`, `fix/…`, `docs/…` or `chore/…` (see [`git-and-pr-conventions.md`](./.agents/rules/git-and-pr-conventions.md)).
2. **Review scope and placement** — run `git status` and `git diff --stat`. Every changed file must belong to the task, live in the correct folder (§2) and not touch a protected path (§4) without explicit developer confirmation.
3. **Run quality checks for the touched areas** — `git diff --check` (always) plus every lint/test/build command configured for the touched package (listed in `memory-bank/techContext.md`). Never commit with a failing check; never disable or delete a test to make it pass.
4. **Update the memory bank** — run the [`update-memory-bank`](./.agents/skills/update-memory-bank/SKILL.md) skill: record what changed in `progress.md`, and any new decision, dependency or constraint in `techContext.md`.
5. **Verify the memory bank** — `bash .agents/skills/update-memory-bank/scripts/verify_memory_bank.sh` must exit with code `0`.
6. **Review the final diff for safety** — `git diff --cached` after staging: no secrets, no `.env` files, no real PII, payroll, supplier prices or master recipes, no debug leftovers.
7. **Stage explicitly and commit** — `git add <paths>` (never a blind `git add -A`), then commit using Conventional Commits (`feat(scope): …`, `fix(scope): …`, `docs: …`, `chore: …`).

Pushing and opening a PR happen only when the developer asks for it. PRs target `main` and include the verification output.

## 4. Do not modify without explicit developer confirmation

| Path                                                    | Why                                                                 |
| ------------------------------------------------------- | ------------------------------------------------------------------- |
| `BRIEFING.md`, `CONTEXT.md`, `CONTEXT.es.md`            | Business source of truth                                            |
| `memory-bank/projectbrief.md`                           | Business context — changes only when the business changes           |
| `AGENTS.md`, `.agents/**`                               | The agent protocol itself — an agent must not rewrite its own rules |
| `.devcontainer/**`                                      | Shared development environment                                      |
| `.gitignore`, `.github/**`                              | Repository and CI behaviour                                         |
| `README.md`/`README.es.md` (root and template folders)  | Template guidance used by humans and agents                         |
| `agents/_template/**`, `skills/_template/**`            | Templates for future product agents/skills                          |
| `packages/shared/**`                                    | Shared contracts consumed by several apps                           |
| `infra/**`, `docker-compose.yml`                        | Infrastructure and deployment                                       |
| `data/raw/**`                                           | Source data — never overwrite or edit in place                      |
| Lockfiles (`pnpm-lock.yaml`, `uv.lock`) and root `package.json`/`pyproject.toml` | Dependency changes affect the whole repo |
| Any `.env*` file                                        | Secrets — never read aloud, never commit                            |

`memory-bank/progress.md` and `memory-bank/techContext.md` **are** expected to be updated by the agent as part of the workflow (§3, step 4).

## 5. Stop and ask the developer when

- The task needs a technology marked **Pending** in `techContext.md` (frontend framework, database, auth, hosting…).
- The code does not clearly belong to one of the existing folders, or a new top-level folder seems necessary.
- A change would touch a protected path (§4) or delete files you did not create in this task.
- A business fact is missing from `BRIEFING.md` (e.g. location names, prices, recipes) — never invent business data.
- A quality check fails and the fix is outside the task scope.
- Requirements in the prompt contradict the memory bank or the rules.

## 6. Rules and skills index

| File                                                                                              | Kind  | Scope           |
| ------------------------------------------------------------------------------------------------- | ----- | --------------- |
| [`.agents/rules/monorepo-structure.md`](./.agents/rules/monorepo-structure.md)                     | Rule  | always          |
| [`.agents/rules/brasaland-domain-conventions.md`](./.agents/rules/brasaland-domain-conventions.md) | Rule  | file-pattern    |
| [`.agents/rules/git-and-pr-conventions.md`](./.agents/rules/git-and-pr-conventions.md)             | Rule  | agent-requested |
| [`.agents/skills/update-memory-bank/SKILL.md`](./.agents/skills/update-memory-bank/SKILL.md)       | Skill | invoked in §3 step 4 |
