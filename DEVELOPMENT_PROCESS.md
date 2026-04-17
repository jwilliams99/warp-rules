## Development process rules

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

## Validation
- Tests run
- Manual verification performed

## Contract impact
- API / schema / event / migration impact
- State whether changes are additive, breaking, or internal-only

## Risks / notes
- Known risks, follow-ups, or rollout considerations

## Plan conformance
- Confirm whether implementation matches the approved plan exactly
- If not, describe the deviation explicitly