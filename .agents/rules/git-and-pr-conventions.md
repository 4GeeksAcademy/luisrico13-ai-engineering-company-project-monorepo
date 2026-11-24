---
name: git-and-pr-conventions
description: Branch naming, commit message format and pull-request checklist. Load when creating a branch, committing, pushing or opening a PR.
scope: agent-requested
alwaysApply: false
---

# Rule: Git and pull-request conventions

**Scope:** `agent-requested` — not loaded automatically. The agent must load it whenever it is about to
create a branch, commit, push or open/update a pull request (`AGENTS.md` §3 steps 1 and 7).

## Branches

- Never commit directly to `main`.
- Name: `<type>/<short-kebab-description>` with `type` ∈ `feature`, `fix`, `docs`, `chore`, `refactor`.
  Examples: `feature/agent-memory-bank`, `feature/backoffice-sales-dashboard`, `fix/api-currency-rounding`.
- One branch = one task. Start from an up-to-date `main` (`git pull origin main`).

## Commits

- [Conventional Commits](https://www.conventionalcommits.org/): `<type>(<optional scope>): <imperative summary>`.
  - `type` ∈ `feat`, `fix`, `docs`, `chore`, `refactor`, `test`, `build`, `ci`.
  - `scope` = the folder or app touched: `website`, `backoffice`, `api`, `data`, `memory-bank`, `agents-config`…
  - Summary ≤ 72 characters, English, no trailing period.
- Small, focused commits. Stage files by path; never commit generated artefacts, `node_modules/`, `.venv/` or `.env*`.
- Every commit that changes behaviour, structure or decisions includes the corresponding memory-bank update.

## Pull requests

- Target: `main` of this repository (the fork), never the upstream template.
- Title follows the commit convention.
- Description must contain:
  1. **Summary** — what and why, linked to the stakeholder need in `BRIEFING.md` when applicable.
  2. **Changes** — list of files/folders touched.
  3. **Verification** — commands run (`AGENTS.md` §3) and their result, including `verify_memory_bank.sh`.
  4. **Memory bank** — what was updated in `memory-bank/`.
  5. A direct link to `AGENTS.md`.
- After approval, merge into `main` and delete the branch so the next branch starts from current code.

## How to verify

- `git branch --show-current` matches `^(feature|fix|docs|chore|refactor)/[a-z0-9-]+$`.
- `git log main..HEAD --format=%s` — every line matches `^(feat|fix|docs|chore|refactor|test|build|ci)(\([a-z0-9-]+\))?: .{1,72}$`.
