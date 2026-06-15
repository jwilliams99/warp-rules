## Rule: Commit discipline

All Git commits must follow a single conventional-commit format so history
is machine-parseable, human-readable, and traceable to tickets.

### Why
A consistent commit format makes history usable: reviewers can read a diff's
intent quickly, tools can generate changelogs and release notes, and audits
can trace a change from a ticket to the lines that implemented it.

### Format
Every commit message has four parts, in order:

```
type(scope): description
- factual change 1
- factual change 2
- factual change 3
TICKET-NUMBER
```

- **Subject line**: `type(scope): description`, imperative mood, no trailing
  period. Scope is optional when the change is project-wide.
- **Factual bullet points**: each bullet states exactly what changed, in
  terms a reviewer can verify against the diff. No marketing copy.
- **Trailer line**: a ticket identifier on the last line (for example
  `ENG-338`). If there is genuinely no associated ticket, use `NO-TICKET`.
  Do not invent identifiers.

### Allowed types
- `feat` — new user-visible behaviour
- `fix` — corrects a defect
- `docs` — documentation only
- `style` — formatting, whitespace, or other cosmetic changes with no
  behavioural effect
- `refactor` — behaviour-preserving restructuring
- `test` — tests only
- `chore` — tooling, build, CI, housekeeping

### Example
```
feat(logging): add user_id to log format string
- added [user:%(user_id)s] to defaults.yaml format string
- updated fallback format in __init__.py
- modified auth endpoints to use get_log_context()
ENG-338
```

### TDD red-first commits
When recording a failing test as the starting point of a TDD cycle, the
subject line must include the `[tdd-red]` marker:

```
test(auth): add failing test for negative authz [tdd-red]
- added test asserting 403 for unauthorised principal
- aligned with scope-leak expectations in SECURITY_BY_DEFAULT.md
NO-TICKET
```

A red-first commit must be followed by a green commit in the same session.
Do not leave a red-first commit as the last commit on a branch. See
`TEST_DRIVEN_DEVELOPMENT.md`.

### WIP commits
When the user has explicitly asked for a work-in-progress commit, include
the `[wip]` marker on the subject line:

```
chore(indexer): snapshot partial progress on ingestion refactor [wip]
- extracted candidate normalisation helper
- retrieval path still failing integration tests
NO-TICKET
```

WIP commits must be rebased, squashed, or removed before the phase branch
is merged, per `DEVELOPMENT_PROCESS.md`.

### Enforcement
- Applies to: every commit on every branch.
- Consequence on breach: where a commit-message linter is configured in
  CI, the CI run fails. In every repository, a reviewer must request a
  rewrite of any commit message that does not follow this format before
  the PR is merged.

---

## Auto-commit rules

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
- No secrets were introduced (see secrets section in `SECURITY_BY_DEFAULT.md`).

### When NOT to auto-commit
Do NOT auto-commit if any of these are true:
- The branch check above fails.
- The change is tiny or noisy (formatting only, whitespace only, comment
  only, renames only) unless it is part of a larger coherent change.
- There are failing tests, failing lint, or the build is broken — with two
  explicit exceptions:
  - the user explicitly asked for a WIP commit (use the `[wip]` marker), OR
  - a TDD red-first commit is being recorded as the starting point of a
    TDD cycle (use the `[tdd-red]` marker), and it must be followed by a
    green commit in the same session.
- The change touches production infra or security-sensitive code (ask first).
- The change mixes unrelated concerns into the phase branch.
- The change includes secrets or looks like credentials (stop and fix
  immediately).

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
