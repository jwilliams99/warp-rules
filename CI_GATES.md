## Rule: CI gates (required checks)

Every repository with active development must run a defined set of
automated checks in CI. This rule is the single authoritative list of
required gates; other rules reference it rather than redefining their own.

### Why
Humans are not a reliable enforcement mechanism for security and hygiene. Gates that run on every commit, PR, and build are. Centralising the list here prevents drift between repos and between rules.

### Roll-out
New gates land in three steps, in order:
1. Advisory (runs in CI, reports findings, does not fail the build).
2. Blocking on new code only (allowlists for legacy findings, recorded with owners and expiry dates).
3. Blocking on all code.
A gate must reach step 3 within one sprint of introduction unless an exception is documented in the repo's README with an owner and expiry.

### Required gates (all repositories)
Every repo must run the gates below, using the named tool for the stack in use. Gates must be wired into the status-check requirements for the canonical branch.

1. Secrets scanning
   •  Tools: `gitleaks` (pre-commit and CI), `trufflehog` on PR diff, full-history scan on branch creation.
   •  Behaviour: any finding is blocking; no allowlist without documented rotation.
   •  References: `SECURITY_BY_DEFAULT.md` (secrets section).

2. Static application security testing (SAST)
   •  Tools: `semgrep` (polyglot default) or `codeql` where available; language-specific rulesets opt-in.
   •  Behaviour: blocking at `error` severity; advisory at `warning` unless promoted.

3. Dependency vulnerability scanning
   •  Tools per stack: `pip-audit`; `npm audit` / `pnpm audit`; `govulncheck`; `cargo audit`; `trivy fs` for polyglot trees.
   •  Behaviour: critical and high blocking; medium advisory; SLA for patches per `SECURITY_BY_DEFAULT.md`.

4. Infrastructure-as-code and container scanning (where applicable)
   •  Tools: `checkov` or `tfsec` for Terraform; `kube-linter` for Kubernetes manifests; `trivy image` for container images.
   •  Behaviour: blocking at `high` severity.

5. Lint, format, type
   •  Tools per stack (see table below).
   •  Behaviour: blocking.

Tools by language:
- Python: `black` (formatter), `isort` (imports), `ruff` (linter and
  import-checker), `mypy` or `pyright` (type-check).
- JavaScript: `prettier` (formatter), `eslint` (linter).
- TypeScript: `prettier` (formatter), `eslint` (linter), `tsc --noEmit` (type-check).
- Go: `gofmt` (or `goimports`), `go vet`, `staticcheck`.
- Rust: `rustfmt`, `clippy`.
- Terraform: `terraform fmt`, `tflint`.
- Shell: `shellcheck`, `shfmt`.
- Markdown: `markdownlint` where configured.

If the repository defines a project-standard formatter or linter that does
not match this list, follow the repository's choice. Record any deliberate
deviation in the repository's README.

6. Duplication scan
   •  Default: `jscpd` (polyglot).
   •  Per-stack alternatives: Python `pylint --enable=duplicate-code`; JS/TS `eslint` `sonarjs/no-duplicate-string` and `sonarjs/no-identical-functions`; Go `dupl`; Java/Kotlin `PMD-CPD`.
   •  Behaviour: blocking above the repo's documented threshold (for example `min-tokens: 50`, max duplication `5%`). Allowlist entries require justification.
   •  References: `CENTRALISED_BUSINESS_LOGIC.md`, `CODEBASE_ALIGNMENT_POLICY.md`.

7. Complexity and size budgets
   •  Tools: `radon` (Python), ESLint `complexity` rule (JS/TS), `gocyclo` (Go).
   •  Budgets: per-function cyclomatic complexity, per-function length, per-file length, max parameters. Defaults documented per language in the repo's README.
   •  Behaviour: blocking when budgets are exceeded.

8. Test and coverage
   •  Behaviour: unit and integration tests pass; coverage delta must not be negative; skipped tests flagged.
   •  Security-test expectations (positive authz, negative authz, scope-leak, abuse) are defined in `SECURITY_BY_DEFAULT.md`.

9. Migration checks (where applicable)
   •  Migrations run cleanly on an empty DB and on an existing DB in CI, per `DATABASE_MIGRATIONS.md`.

10. Hygiene checks
    •  Unused imports and dead code: `vulture`, `ts-prune`, language-server "unused" diagnostics, `knip`.
    •  Unused dependencies: `depcheck`, `pip-audit --strict`, `go mod tidy` diff check.
    •  TODO freshness: CI check fails if a TODO has no ticket reference or is older than the policy window (see `PERIODIC_CODEBASE_HYGIENE_REVIEW.md`).
    •  `.env.example` vs code reference drift.

### Supply-chain gates (at build / release time)
•  Lockfiles are authoritative; CI rejects unpinned installs.
•  SBOM generated on every build and stored with the artefact.
•  Container images and release artefacts are signed (for example Sigstore / `cosign`); signatures verified on pull.
•  Automated dependency-update PRs enabled (for example Dependabot or Renovate) with an SLA per `SECURITY_BY_DEFAULT.md`.

### Allowlists and exceptions
•  Every allowlisted finding must include: the file and rule, the reason, the owner, and an expiry date.
•  Expired allowlist entries fail CI.
•  Exceptions to a whole gate require an entry in the repo's README with an owner and an expiry.

### Local developer ergonomics
•  Pre-commit hooks must mirror the cheapest CI gates (lint, format, type, secrets scan) so authors get feedback before pushing.
•  A single `make check` (or equivalent) target should run the full local-suitable gate set.

### Metrics
Each repository should publish, at minimum:
•  Percentage of PRs where all gates pass on first push.
•  Count of open CVEs by severity and mean time to patch.
•  Duplication percentage trend.
•  Coverage trend.
•  Count of TODOs without tickets.

### Enforcement
- Applies to: every repository with active development.
- Consequence on breach: any failing required gate blocks the PR from
  merging and blocks the deployment pipeline. Missing gates in a repo are
  themselves a defect and must be added on the next change.

### Mapping to the global Definition of Done
Each CI gate in this file satisfies one or more bullets in the Definition
of Done in `DEVELOPMENT_PROCESS.md`. This mapping is the source of truth;
if the DoD or this file changes, update the other in the same change set.

- Secrets scanning → DoD: CI security gates green; no secrets committed.
- SAST → DoD: CI security gates green.
- Dependency vulnerability scanning → DoD: CI security gates green;
  dependency SLA met.
- IaC / container scanning → DoD: CI security gates green (where
  applicable).
- Lint, format, type → DoD: lint, type, and format checks clean.
- Duplication scan → DoD: CI hygiene gates green; no new duplicate
  abstractions.
- Complexity and size budgets → DoD: CI hygiene gates green.
- Test and coverage → DoD: tests pass; coverage delta non-negative.
- Migration checks → DoD: migrations satisfy `DATABASE_MIGRATIONS.md` DoD.
- Hygiene checks → DoD: documentation updated; TODO freshness respected.

### Related canonical rules
- `SECURITY_BY_DEFAULT.md` — defines what must be gated and why.
- `PERIODIC_CODEBASE_HYGIENE_REVIEW.md` — broader hygiene checklist; this
  rule automates the parts that can be automated.
- `DATABASE_MIGRATIONS.md` — migration CI expectations.
- `DEVELOPMENT_PROCESS.md` — the global Definition of Done; every gate in
  this file maps to one or more DoD bullets (see mapping above).
