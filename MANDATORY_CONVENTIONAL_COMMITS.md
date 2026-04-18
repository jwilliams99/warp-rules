## Rule: Mandatory conventional commit format

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
subject line must include the `[tdd-red]` marker so the red-first intent is
explicit:

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

### Relationship to other rules
- `GIT_AUTOCOMMIT.md` — when auto-commit is allowed and how it batches work.
- `TEST_DRIVEN_DEVELOPMENT.md` — TDD cycle and red-first requirement.
- `DEVELOPMENT_PROCESS.md` — phase branches, PR template, merge rules.
- `CI_GATES.md` — automated checks on commit messages where configured.

### Enforcement
- Applies to: every commit on every branch.
- Consequence on breach: where a commit-message linter is configured in
  CI, the CI run fails. In every repository, a reviewer must request a
  rewrite of any commit message that does not follow this format before
  the PR is merged.
