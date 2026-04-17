## Rule: Auto-commit changes in git repos (with batching)

When working inside a Git repository, the agent should keep the repo tidy by committing work automatically — **but only when it makes sense**.

### When auto-commit is allowed
Auto-commit is allowed when ALL of these are true:
- The working directory is inside a git repo (`git rev-parse --is-inside-work-tree`).
- Changes are non-destructive (no mass deletions, no sweeping refactors).
- The changes are coherent (one idea / one fix / one feature).
- No secrets were introduced (tokens, passwords, private keys, credentials).

### When NOT to auto-commit
Do NOT auto-commit if any of these are true:
- The change is tiny/noisy (formatting only, whitespace only, comment-only, renames only) **unless** it’s part of a larger coherent change.
- There are failing tests, failing lint, or the build is broken (unless the user explicitly asked for a “WIP” commit).
- The change touches production infra or security-sensitive code (ask first).
- The repo is not on the expected branch (e.g. not on a feature branch) unless the user asked otherwise.
- The change includes secrets or looks like credentials (stop and fix immediately).

### Batching rule (avoid commit spam)
Batch small edits together. The agent should:
- Accumulate “tiny” changes and commit them only when:
  - a meaningful milestone is reached, OR
  - the user explicitly asks for a commit, OR
  - the change set is at least medium-sized (rough heuristic: > ~20 lines changed across >1 file), OR
  - it’s the end of a task/session.

“TINY” examples:
- single typo fix
- minor wording edits
- small formatting changes
- trivial refactor that doesn’t change behaviour

### What to do before committing
Before committing, the agent MUST:
1. Review `git status` and `git diff` to confirm the commit is coherent.
2. Run the repo’s fast checks if available (prefer the cheapest one):
   - `make test` / `make lint` / `npm test` / `pytest -q` / etc.
   - If no checks exist, at least ensure changes are syntactically valid.
3. Ensure no secrets are present (scan the diff for tokens/keys).

### Commit style
- Use conventional, descriptive messages:
  - `feat: ...`, `fix: ...`, `docs: ...`, `chore: ...`, `refactor: ...`, `test: ...`
- Keep commits small and focused.
- Prefer one commit per logical change set.

### Auto-push policy
- The agent may commit locally without asking.
- The agent must ASK before pushing to any remote, unless the user explicitly enabled auto-push in this repo.

### Suggested workflow
- If a task involves multiple small steps, commit at milestones:
  - “scaffold added”
  - “feature implemented”
  - “tests updated”
  - “docs updated”