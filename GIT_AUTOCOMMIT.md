## Rule: Auto-commit changes in git repos (with batching)

When working inside a Git repository, the agent should keep the repo tidy by
committing work automatically — but only when it makes sense.

### When auto-commit is allowed
Auto-commit is allowed when ALL of these are true:
- The working directory is inside a git repo (`git rev-parse --is-inside-work-tree`).
- The current branch is a phase branch that matches the active plan phase,
  per the branch naming convention in `DEVELOPMENT_PROCESS.md` (format:
  `plan/<short-plan-name>/phase-<n>-<short-phase-name>`). Any other branch
  (the canonical branch, another plan's phase branch, an unrecognised
  branch) must not be auto-committed to; ask before committing.
- Changes are non-destructive (no mass deletions, no sweeping refactors).
- The changes are coherent (one idea / one fix / one feature) and stay
  within the phase scope defined in the plan.
- No secrets were introduced (see `SECRETS_AND_CREDENTIALS_HANDLING.md`).

### When NOT to auto-commit
Do NOT auto-commit if any of these are true:
- The branch check above fails.
- The change is tiny or noisy (formatting only, whitespace only, comment
  only, renames only) unless it is part of a larger coherent change.
- There are failing tests, failing lint, or the build is broken — with two
  explicit exceptions:
  - the user explicitly asked for a WIP commit (use the `[wip]` marker per
    `MANDATORY_CONVENTIONAL_COMMITS.md`), OR
  - a TDD red-first commit is being recorded as the starting point of a
    TDD cycle (use the `[tdd-red]` marker per
    `MANDATORY_CONVENTIONAL_COMMITS.md` and `TEST_DRIVEN_DEVELOPMENT.md`),
    and it must be followed by a green commit in the same session.
- The change touches production infra or security-sensitive code (ask first).
- The change mixes unrelated concerns into the phase branch.
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
  `MANDATORY_CONVENTIONAL_COMMITS.md` (`type(scope): description`, factual
  bullet points, ticket identifier on the last line). Auto-commits must
  follow that format, including the `[tdd-red]` and `[wip]` markers where
  applicable.
- Keep commits small and focused.
- Prefer one commit per logical change set.
- Ticketless commits: when there is genuinely no associated ticket, use
  `NO-TICKET` on the last line per `MANDATORY_CONVENTIONAL_COMMITS.md`. Do
  not invent ticket identifiers.

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

### Enforcement
- Applies to: every auto-commit the agent initiates inside a Git
  repository.
- Consequence on breach: the agent must stop and ask the user before
  proceeding whenever any allowed-to-commit precondition fails. A commit
  that bypassed these preconditions must be reverted or amended before
  further work continues.
