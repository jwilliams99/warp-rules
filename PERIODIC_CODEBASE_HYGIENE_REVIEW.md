## Rule: Periodic codebase hygiene review

Perform regular code hygiene reviews to eliminate waste, reduce risk, and
maintain a clean, navigable codebase. This complements the
canonical-function rule by catching broader decay.

### Why
Codebases accumulate cruft over time — dead code, stale comments, unused dependencies, outdated documentation, and latent bugs. Without periodic review, these compound into slower development, harder onboarding, and hidden security risks.

### Review Cadence
•  Recommended: once per sprint or at minimum once per month
•  Trigger on: major feature completion, dependency upgrades, or team member transitions

### Hygiene Checklist

| # | Category | What to check | Action | Reference |
|---|----------|--------------|--------|----------|
| 1 | Duplication | Functions/blocks with overlapping logic | Consolidate into canonical location | `CENTRALISED_BUSINESS_LOGIC.md` |
| 2 | Dead code | Unused functions, classes, methods, variables, impossible branches, commented-out code | Remove (version control is the archive) | — |
| 3 | Unused imports & deps | Imports in source, package manifests | Strip/audit (package.json, requirements.txt, go.mod) | — |
| 4 | TODO / FIXME / HACK | Linked ticket? Older than 90 days? | Resolve or ticket | `CI_GATES.md` |
| 5 | Stale comments | Comments that no longer match code behaviour | Remove or rewrite | — |
| 6 | Complexity | High cyclomatic complexity (language-dependent threshold, e.g. >10) | Extract sub-functions or simplify | `CI_GATES.md` |
| 7 | Naming | Casing, prefixes, verb/noun patterns, vague identifiers | Enforce conventions | — |
| 8 | Magic numbers | Hardcoded constants and strings | Extract to named constants, config, or env vars | — |
| 9 | Error handling | Bare/blanket catches without logging or re-raising | Add context propagation | — |
| 10 | Dependency health | CVEs, SLAs, version drift, lockfile pinning, SBOM | Confirm controls active | `CI_GATES.md`, `SECURITY_BY_DEFAULT.md` |
| 11 | Test hygiene | Permanently skipped tests, tests with no assertions, flaky tests | Fix or remove | — |
| 12 | Security surface | Input validation, least-privilege, authz tests, secrets handling | Confirm controls active | `SECURITY_BY_DEFAULT.md` |
| 13 | Unused config & env vars | Env vars and config keys no code path references | Remove; keep .env.example in sync | — |
| 14 | Documentation currency | README, API docs, architecture docs, inline docstrings, runbooks, changelog/ADRs, onboarding guides | Verify accuracy; update or reconcile | — |

### Outputs
Each review should produce:
•  A summary of findings (categorised by severity: critical / warning / info).
•  A list of actionable items, each linked to a ticket.
•  Confirmation that critical items are addressed before the next release.

### PR Checklist (for hygiene PRs)
•  Does this PR only remove / clean up code (no new features mixed in)?
•  Were removed items verified as unused (not just suspected)?
•  Do all tests still pass after cleanup?
•  Is the change set small enough for meaningful review?
•  Is documentation updated to reflect any removals or changes?

### Enforcement
- Applies to: all repositories with active development.
- Consequence on breach: the cycle owner files findings as tickets;
  critical items must be addressed before the next release. A release
  containing unresolved critical findings must not ship.
- Owner: rotating among team members each cycle.
