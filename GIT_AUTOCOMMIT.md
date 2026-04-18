## Rule: Auto-commit changes in git repos (with batching)

When working inside a Git repository, the agent should keep the repo tidy by
committing work automatically — but only when it makes sense.

### When auto-commit is allowed
Auto-commit is allowed when ALL of these are true:
- The working directory is inside a git repo (`git rev-parse --is-inside-work-tree`).
- The current branch is a phase branch that matches the active plan phase, per
  the branch naming convention in `DEVELOPMENT_PROCESS.md`
  (format: `plan/<short-plan-name>/phase-<n>-<short-phase-name>`).
- Changes are non-destructive (no mass deletions, no sweeping refactors).
- The changes are coherent (one idea / one fix / one feature).
- No secrets were introduced (tokens, passwords, private keys, credentials).

### When NOT to auto-commit
Do NOT auto-commit if any of these are true:
- The current branch is not a phase branch for the active plan phase. This
  includes: the canonical branch (`main` / `master`), another plan's phase
  branch, an unrecognised branch, or a branch whose name does not match the
  active plan and phase. When in doubt, ask before committing.
- The change is tiny/noisy (formatting only, whitespace only, comment-only,
  renames only) unless it is part of a larger coherent change.
- There are failing tests, failing lint, or the build is broken — with two
  explicit exceptions:
  - the user explicitly asked for a "WIP" commit, OR
  - a TDD red-first commit is being recorded as the starting point of a TDD
    cycle; in that case the commit message must mark it as such
    (e.g. `test: add failing test for <behaviour> [tdd-red]`) and must be
    followed by a green commit in the same session.
- The change touches production infra or security-sensitive code (ask first).
- The branch scope does not match the active plan phase (see
  `DEVELOPMENT_PROCESS.md`) — do not mix unrelated changes into a phase branch.
- The change includes secrets or looks like credentials (stop and fix
  immediately; see `SECRETS_AND_CREDENTIALS_HANDLING.md`).

### Batching rule (avoid commit spam)
Batch small edits together. The agent should accumulate "tiny" changes and
commit them only when:
- a meaningful milestone is reached, OR
- the user explicitly asks for a commit, OR
- the change set is at least medium-sized (rough heuristic: >~20 lines changed
  across >1 file), OR
- it is the end of a task or session.

"Tiny" examples:
- single typo fix
- minor wording edits
- small formatting changes
- trivial refactor that does not change behaviour

### What to do before committing
Before committing, the agent MUST:
1. Run `git branch --show-current` and confirm the branch name matches the
   active plan phase before proceeding. If it does not match, stop and ask.
2. Review `git status` and `git diff` to confirm the commit is coherent.
3. Run the repo's fast checks if available (prefer the cheapest one):
   - `make test` / `make lint` / `npm test` / `pytest -q` / etc.
   - If no checks exist, at least ensure changes are syntactically valid.
4. Ensure no secrets are present (scan the diff for tokens/keys).

### Commit style
- The authoritative commit-message format is defined in
  `MANDATORY_CONVENTIONAL_COMMITS.md` (type(scope): description, factual bullet
  points, ticket number on the last line). Auto-commits MUST follow that format.
- Keep commits small and focused.
- Prefer one commit per logical change set.
- Ticketless commits: when there is genuinely no associated ticket (e.g. an
  in-session scratch fix the user has not ticketed), use `NO-TICKET` on the
  last line instead of omitting it. Do not invent ticket identifiers.

### Auto-push policy
- The agent may commit locally without asking.
- The agent must ASK before pushing to any remote, unless the user explicitly
  enabled auto-push in this repo.

### Suggested workflow
- If a task involves multiple small steps, commit at milestones:
  - "scaffold added"
  - "feature implemented"
  - "tests updated"
  - "docs updated"