## Development process rules

Development can only begin once the planning document is complete, has human approver and approval date
recorded in the planning document. 

### Core workflow
- Every approved plan must be executed through explicit development phases.
- Work must proceed phase by phase unless parallelism is explicitly justified in the plan.
- Each phase must have a clearly defined implementation boundary, validation boundary, and merge boundary.
- No implementation work may begin until the relevant phase is marked as started in the plan.
- No phase may be considered complete until its code, tests, review, and merge steps are complete.

### Canonical branch
- `main` or `master`, whichever the repository uses, is the canonical branch.
- No direct commits may be made to the canonical branch.
- All phase branches must be created from the current canonical branch.
- Do not branch from another feature or phase branch.

### Branching model
- Every implementation phase must be done on its own branch.
- Keep the branch model simple: one phase, one branch, one PR.
- All phase branches must be created from the latest canonical branch.

### Branch naming
- Branch names must identify both the plan and the phase they implement.
- Recommended format:
  - `plan/<short-plan-name>/phase-<n>-<short-phase-name>`
- Examples:
  - `plan/layered-context-loading/phase-1-schema`
  - `plan/token-attribution/phase-3-search-response`
  - `plan/knowledge-graph/phase-2-service-layer`

### Phase execution rules
- Before starting a phase:
  - verify pre-implementation gates are filled in the plan (see `PLANNING.md`)
  - update the plan phase status to `🟡 In Progress`
  - create the phase branch from the canonical branch
  - ensure the branch scope matches the phase scope
- During the phase:
  - keep changes limited to the phase boundary defined in the plan
  - do not mix unrelated refactors or opportunistic cleanup unless explicitly documented
  - keep the plan updated as step status changes
- When implementation is complete:
  - run the required validation for that phase
  - update step statuses to reflect reality
  - prepare the phase for review through a pull request

### Pull request rules
- Every phase must be merged through a pull request.
- No phase branch may be merged without review.
- PRs must be scoped to a single phase unless the plan explicitly defines a combined merge.
- PR titles should identify the plan and phase clearly.
- Recommended PR title format:
  - `[Plan: <name>] Phase <n> - <phase name>`

### PR template rules
- Every PR must use the standard PR structure defined in `PR_TEMPLATE.md`.
- PR descriptions must be concise, factual, and traceable to the plan.

### Definition of Done (applies to every phase)
A phase is not complete until every applicable item below is satisfied. Items
marked n/a must state why.

- Pre-implementation gates were completed and recorded in the plan before work
  began: prior-art and reuse check, and threat model (or explicit n/a with
  reasoning). A reviewer must verify both were filled before the phase branch
  was created, not retrofitted during PR preparation.
- Tests pass: unit, integration, and any security/authz tests required by the
  plan or by `SECURITY_BY_DEFAULT.md`.
- Lint, type, and format checks clean, per `CI_GATES.md`.
- CI security gates green (see `CI_GATES.md`): secrets scan, SAST, dependency
  vulnerability scan.
- CI hygiene gates green (see `CI_GATES.md`): duplication scan, complexity and
  size budgets, coverage delta non-negative.
- Prior-art and reuse check from the plan is satisfied; no new duplicate
  abstractions introduced (see `CENTRALISED_BUSINESS_LOGIC.md`).
- Alignment with the surrounding codebase verified, per
  `CODEBASE_ALIGNMENT_POLICY.md`.
- Documentation updated where required (README, API docs, docstrings, ADR or
  changelog if applicable), per `PERIODIC_CODEBASE_HYGIENE_REVIEW.md`.
- Threat model updated if any security-relevant surface changed; least-privilege
  review complete for new grants or tokens.
- Migrations, if any, satisfy the Definition of Done in `DATABASE_MIGRATIONS.md`.
- Plan phase status reflects reality (see `PLANNING.md`); PR description follows
  the template in `PR_TEMPLATE.md`.

### Enforcement
- Applies to: every phase of every plan across every repository with
  active development.
- Consequence on breach: a reviewer must block any PR that violates the
  phase, branch, or PR-template rules; a phase must not transition to
  `🟡 In Progress` without the pre-implementation gates in `PLANNING.md`
  filled; a phase must not be marked `🟢 Complete` while any applicable
  Definition-of-Done item is unmet.

