## Development process rules

Development can only begin once the planning document is complete, and the human approver and approval date
are recorded in the planning document.
Human approval must be explicit, not implied.

### Core workflow
- Every approved plan must be executed through explicit development phases.
- Work must proceed phase by phase unless parallelism is explicitly justified in the plan.
- Each phase must have a clearly defined implementation boundary, validation boundary, and merge boundary.
- No implementation work may begin until the relevant phase is marked as started in the plan.
- No phase may be considered complete until its code, tests, review, and merge steps are complete.
- A phase is delivered through its approved merge units. Each merge unit has exactly one task branch and pull request; no branch is required for the phase as a whole.
- Do not mark a phase complete until every merge unit's pull request is merged and its acceptance criteria are verified.

### Canonical branch
- `main` or `master`, whichever the repository uses, is the canonical branch.
- No direct commits may be made to the canonical branch.
- All task branches must be created from the latest canonical branch.
- Do not branch from another feature or task branch.

### Branching model
- Every implementation phase must define one or more merge units in the approved plan, as specified in `PLANNING.md`.
- Each merge unit maps to exactly one task branch and one pull request. A phase can have multiple branches and pull requests; there is no phase branch.
- Do not combine separate merge units in one pull request or split one merge unit across pull requests. Change a boundary only by updating and re-approving the plan before continuing.
- Create each task branch from the latest canonical branch.

### Branch naming
- Planned-work branch names must identify the plan, phase, and merge unit.
- Recommended format:
  - `plan/<short-plan-name>/p<phase>-<merge-unit-id>-<short-description>`
- Examples:
  - `plan/layered-context-loading/p1-MU1-schema`
  - `plan/token-attribution/p3-MU2-search-response`
  - `plan/knowledge-graph/p2-MU1-service-layer`
- For work that is not scoped to an approved plan phase, use:
  - `feature/<short-description>` for new functionality
  - `fix/<short-description>` for defect fixes
  - `chore/<short-description>` for maintenance work

### Protected-branch hard stop (non-negotiable)
- Before any code edit or commit, run `git branch --show-current`.
- If the current branch is protected (`main`, `master`, `develop`, or any production branch):
  - stop immediately; do not edit code and do not commit
  - surface: `⚠️ CRITICAL: You are on a protected branch. A new branch must be created before proceeding.`
  - sync the canonical branch before branching:
    - `git switch <canonical-branch> && git pull origin <canonical-branch>`
  - create a dedicated branch using the naming rules above
- If already on a non-protected branch, proceed within scope.
- After the task is merged:
  - `git switch <canonical-branch>`
  - `git pull origin <canonical-branch>`
  - Delete the local branch with `git branch -d <completed-branch>` only when
    it is fully merged and has no uncommitted work.
  - Remote branch deletion is optional. Before running
    `git push origin --delete <completed-branch>`, obtain explicit user
    approval for that branch immediately beforehand, regardless of the
    auto-push policy. If approval is not given, leave the remote branch in
    place. See `COMMIT_DISCIPLINE.md` → Auto-push policy.
- If a merge conflict occurs at any stage, stop and ask for guidance before resolving.

### Phase execution rules
- Before starting a phase:
  - verify pre-implementation gates are filled in the plan (see `PLANNING.md`)
  - verify every implementation deliverable is represented by an approved merge unit with acceptance criteria and validation
  - update the plan phase status to `🟡 In Progress`
- Before starting each merge unit:
  - create its task branch from the latest canonical branch
  - ensure the branch scope matches exactly that merge unit
- During the phase:
  - keep changes limited to the active merge unit
  - do not mix unrelated refactors or opportunistic cleanup unless explicitly documented
  - do not combine or split merge units; revise and re-approve the plan first if the boundary must change
  - keep phase, merge-unit, and step statuses updated as work progresses
- When a merge unit is implemented:
  - run its required validation
  - prepare its task branch as one pull request for review
  - do not mark the merge unit complete until its pull request is merged and acceptance criteria are verified
- Mark the phase complete only after all of its merge units are complete.

### Pull request rules
- Every merge unit must be merged through exactly one pull request, and no pull request may contain more than one merge unit.
- No task branch may be merged without review.
- Every pull request must be scoped to one phase and identify its merge-unit ID.
- PR titles should identify the plan, phase, and merge unit clearly.
- Recommended PR title format:
  - `[Plan: <name>] Phase <n> / <merge-unit-id> - <deliverable>`
- A phase is not complete until all its merge-unit pull requests are merged. Closing a required pull request unmerged while marking the phase complete is prohibited.

### PR template rules
- Every PR must use the standard PR structure below.
- PR descriptions must be concise, factual, and traceable to the plan.

```markdown
## Plan
- Plan: <plan name>
- Phase: <phase number and name>
- Merge unit: <ID and name>

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

Pre-implementation gates (verified before implementation began and before
the first merge-unit branch was created):
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
  reasoning). A reviewer must verify both were filled before the first
  merge-unit branch was created, not retrofitted during PR preparation.
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
  the template in this rule.
- Every merge unit defined for the phase has one merged pull request, and its
  acceptance criteria are verified. A dedicated phase branch is not required.

### Enforcement
- Applies to: every phase of every plan across every repository with
  active development.
- Consequence on breach: a reviewer must block any PR that violates the
  phase, merge-unit, task-branch, or PR-template rules; a phase must not transition to
  `🟡 In Progress` without the pre-implementation gates in `PLANNING.md`
  filled; a phase must not be marked `🟢 Complete` while any applicable
  Definition-of-Done item is unmet; a phase must not be marked complete
  until all of its merge units have been merged and verified.
