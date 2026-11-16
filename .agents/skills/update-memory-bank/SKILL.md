---
name: update-memory-bank
description: Record a completed change in the Brasaland memory bank so the next agent session starts with accurate context. Run before every commit (AGENTS.md §3 step 4).
---

# Skill: Update the memory bank

## Objective

Bring `memory-bank/` in sync with the change that is about to be committed — **one objective only**: the memory
bank must describe the repository as it will be after the commit. It does not write application code, decide
technologies or edit business facts.

## When to use

- Mandatory before every commit (`AGENTS.md` §3, step 4).
- After any decision with the developer (technology chosen, folder created, convention changed), even without code.
- At the end of a session that leaves work unfinished, to record where it stopped.

## Inputs

| Input                | Required | Source                                                  | Example                                                         |
| -------------------- | -------- | ------------------------------------------------------- | --------------------------------------------------------------- |
| `change_summary`     | Yes      | Developer prompt / agent's own work                     | "Scaffolded FastAPI app in services/api with /health endpoint"  |
| `changed_files`      | Yes      | `git status --porcelain` and `git diff --stat <base>`   | `services/api/main.py`, `services/api/README.md`                |
| `decisions`          | No       | Conversation with the developer                         | "Database: PostgreSQL 16 — confirmed by developer"              |
| `next_steps`         | No       | Task plan / developer                                   | "Add /locations router"                                         |
| `open_questions`     | No       | Anything blocked or unclear                             | "Location names for Florida not in BRIEFING.md"                 |
| `base_ref`           | No       | Ref to compare against (default `HEAD`; `origin/main` for a PR) | `origin/main`                                           |

## Procedure

1. Collect `changed_files` with `git status --porcelain` and `git diff --stat <base_ref>`.
2. Read the current `memory-bank/progress.md` and `memory-bank/techContext.md`.
3. Update **`progress.md`**:
   - Set `Last updated: YYYY-MM-DD` to today.
   - Rewrite **Current state** so it is true after this change (remove items that are no longer true).
   - Update **Next steps**: remove what is done, add what follows from `next_steps`.
   - Update **Known issues / open questions** with `open_questions`; remove resolved ones.
   - Add bullets under `### YYYY-MM-DD` (today) in **Changelog** (create the heading if missing; newest date first).
4. Update **`techContext.md`** if any changed file is technical (`uis/`, `services/`, `packages/`, `infra/`, `mcps/`, `agents/`, `workflows/`, `data/pipelines/`, `internal/`, `.devcontainer/`, dependency manifests, Dockerfiles, compose files) or if `decisions` is not empty:
   - Stack table: change **Pending** → **Decided** only for decisions the developer confirmed.
   - Add a row to **Architectural decisions** (`ADR-NNN`, date, decision, status).
   - Add new subfolders to **Monorepo map**, new commands/env vars/constraints to **Technical constraints**.
5. Do **not** edit `projectbrief.md` (protected). If the change reveals the business context is outdated, list it under open questions and tell the developer.
6. Run the verification script and fix every `FAIL` until it passes:

   ```bash
   bash .agents/skills/update-memory-bank/scripts/verify_memory_bank.sh            # before a commit
   bash .agents/skills/update-memory-bank/scripts/verify_memory_bank.sh --base origin/main   # before a PR
   ```

## Expected output

- Modified `memory-bank/progress.md` (always) and `memory-bank/techContext.md` (when applicable), staged together with the code change.
- A short report to the developer: files updated + the verification script output.

## Acceptance criteria

Criteria AC1–AC6 are checked automatically by `scripts/verify_memory_bank.sh` (exit code `0` = all pass). AC7 is checked by reviewing the diff.

| ID  | Criterion                                                                                                                                         | How it is verified |
| --- | ------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------ |
| AC1 | `projectbrief.md`, `techContext.md` and `progress.md` exist in `memory-bank/` and are not empty                                                     | script             |
| AC2 | Required sections exist: projectbrief → *Business description, Problem it solves, Project objectives*; techContext → *Tech stack, Monorepo map, Architectural decisions, Technical constraints*; progress → *Current state, Next steps, Changelog* | script |
| AC3 | `progress.md` contains a line `Last updated: YYYY-MM-DD` with a valid date                                                                         | script             |
| AC4 | If anything changed against the base ref, `progress.md` is among the changed files, `Last updated` is today and the Changelog has a `### <today>` entry | script         |
| AC5 | If technical files changed, `techContext.md` is also changed                                                                                       | script             |
| AC6 | No unfilled placeholders (`{{`, `[TODO]`, `TODO:`, `FIXME`, `lorem ipsum`, `<fill`) in `memory-bank/`                                              | script             |
| AC7 | Every statement added is true for the repository after the commit; no invented business data; `projectbrief.md` untouched unless the developer confirmed it | diff review |

## Example run

```text
$ bash .agents/skills/update-memory-bank/scripts/verify_memory_bank.sh
PASS  AC1 required memory-bank files exist and are not empty
PASS  AC2 every file contains its required sections
PASS  AC3 progress.md has 'Last updated: 2026-11-16'
PASS  AC4 changes are recorded in progress.md (Last updated + Changelog for 2026-11-16)
PASS  AC5 technical changes are accompanied by a techContext.md update
PASS  AC6 no unfilled placeholders in memory-bank/

Memory bank verification PASSED
```
