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
- Every PR must use the standard PR structure below.
- PR descriptions must be concise, factual, and traceable to the plan.
- PRs must include the following sections:

```markdown
## Plan
- Plan: <plan name>
- Phase: <phase number and name>

## Purpose
- What this phase implements

## Scope
- What is included
- What is intentionally not included

## Changes
- Summary of the code, schema, contract, or documentation changes

## Reuse and alignment
- Existing functions / modules reused (paths)
- New abstractions introduced, with justification (link plan's Prior-art section)
- Duplication scan result (tool, findings, allowlist deltas)
- Nearest relevant files consulted for style and alignment

## Hygiene
- Dead code / unused imports removed in touched files: yes / no / n-a
- New TODO / FIXME comments link to tickets: yes / no / n-a
- Docs / README / docstrings updated: yes / no / n-a
- Complexity, file-size, and coverage budgets respected: yes / no / n-a

## Gates
Two-part gate: first that the Pre-implementation gates were filled in the
plan before work began (per `PLANNING.md`), and second that the during-
implementation updates have been reconciled.

Pre-implementation gates (verified before the phase branch was created):
- Prior-art and reuse check:
  - [ ] Completed — plan section filled; see "Reuse and alignment" above
  - [ ] n/a — state which surfaces were checked and why none applied
- Threat model:
  - [ ] Completed — link to the filled threat model in the plan
  - [ ] n/a — state which security-relevant surfaces were checked and
        confirmed not touched (auth, authz, user data, external surfaces,
        secrets, infra, supply chain)

If either gate was not completed before work began, state that explicitly
and do not check the box. A reviewer must not approve a PR where gates
were skipped or filled after implementation started.

Security updates during implementation:
- Security-relevant surfaces touched (auth, authz, data egress, secrets,
  infra, deps): yes / no
- Threat model updated (link plan's Threat model section) if the answer
  above is yes
- CI security gates green (see `CI_GATES.md`): secrets scan, SAST,
  dependency vulnerability scan
- Least-privilege review performed for any new IAM / DB grants / tokens:
  yes / no / n-a

## Validation
- Tests run (unit, integration, security, authz)
- Manual verification performed

## Contract impact
- API / schema / event / migration impact
- State whether changes are additive, breaking, or internal-only

## Risks / notes
- Known risks, follow-ups, or rollout considerations

## Plan conformance
- Confirm whether implementation matches the approved plan exactly
- If not, describe the deviation explicitly
```

### Definition of Done (applies to every phase)
A phase is not complete until every applicable item below is satisfied. Items
marked n/a must state why.

- Pre-implementation gates were completed and recorded in the plan before work
  began: prior-art and reuse check, and threat model (or explicit n/a with
  reasoning). A reviewer must verify both were filled before the phase branch
  was created, not retrofitted during PR preparation.
- Tests pass: unit, integration, and any security/authz tests required by the
  plan or by `SECURITY_BY_DEFAULT.md`.
- Lint, type, and format checks clean, per `STANDARD_TOOLING.md`.
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
  the template above.

### Enforcement
- Applies to: every phase of every plan across every repository with
  active development.
- Consequence on breach: a reviewer must block any PR that violates the
  phase, branch, or PR-template rules; a phase must not transition to
  `🟡 In Progress` without the pre-implementation gates in `PLANNING.md`
  filled; a phase must not be marked `🟢 Complete` while any applicable
  Definition-of-Done item is unmet.

