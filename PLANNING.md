## Rule: Planning document requirements

Every plan follows a single structure so that status, gates, and
conformance can be checked uniformly across plans.

### Planning document requirements
- Every plan must begin with:
  - Created: YYYY-MM-DD HH:MM TZ
  - Completed: Not completed
  - Approved by: <human who approves>
  - Approved date: YYYY-MM-DD HH:MM TZ
- Set Created when the plan is first written.
- Leave Completed as Not completed until the plan is fully finished.
- When the plan is complete, update Completed immediately with the actual date and time.
- A plan is not complete until the Completed field has been updated.
- Timezone: all timestamps in the plan (`Created`, `Completed`, and any other dated fields) must be recorded in the user's local timezone, not UTC and not the agent's default timezone. Include an explicit IANA timezone name (for example `Australia/Sydney`) or an offset (for example `+10:00`) after the time so the value is unambiguous. Example: `Created: 2026-04-18 11:39 Australia/Sydney`.
- The Warp Drive copy and every repo mirror must use the same timezone for the same timestamp; do not convert between zones when mirroring.

Post-approval deviation log (mandatory):
- Every plan must include a `## Deviations` section before or at the time of approval.
  - Before approval: `Not applicable; plan not yet approved`
  - At approval, if no deviations exist yet: `None recorded`
- After `Approved by` and `Approved date` are set, any substantive change to the approved scope, approach, phase/step content, acceptance criteria, pre-implementation gates, threat model, contracts, affected repositories, or implementation strategy must be logged explicitly as a deviation in the same plan document.
- Routine lifecycle updates — phase/step status changes, blocker notes, test results, mirror sync metadata, and setting the `Completed` timestamp — do not constitute deviations unless they alter the approved plan.
- Adding the deviation entry in the same change-set as the modification satisfies the logging requirement for that modification.
- Logging a deviation is an edit and triggers the mirroring rule. The deviation entry and any corresponding plan changes must be mirrored to every affected repository in the same change-set. Affected work must pause until the mirror reflects the deviation.
- If a deviation changes the set of affected repositories, the `Mirrors:` field and repo mirror set must be updated in the same change-set.
- If a deviation invalidates any pre-implementation gate answer, the relevant gate must be updated before affected work continues.
- Material deviations require human re-approval before affected implementation continues. Material deviations include changes to scope, security posture, user-data handling, public/internal contracts, acceptance criteria, affected repositories, dependencies, deployment/rollback approach, or completion criteria.
- Deviations may only be logged while the plan is active. Once a plan is marked complete and moved to `docs/ai-planning/complete/`, the plan document is immutable; subsequent issues must be handled in a new follow-up plan that references the completed plan.
- Deviation entries must be append-only and listed in chronological order.
- Silent edits to approved plans are prohibited.

Each deviation entry must include:

- Date: `YYYY-MM-DD HH:MM TZ` (using the same local timezone standard as the plan header)
- Recorded by: <human or agent identifier>
- Deviation: what changed compared with the most recent approved baseline (as modified by prior logged deviations)
- Reason: why the change was necessary
- Impact: affected phases, steps, repositories, contracts, or gates
- Remedy: corrective action, mitigation, `Accepted Risk`, `Verified`, follow-up plan reference, or `n/a`
- Requires re-approval: yes / no
- Re-approved by: <human> or `n/a`
- Re-approved date: `YYYY-MM-DD HH:MM TZ` or `n/a`

Phase status requirements:

- Every phase must include exactly one status:
  - 🔵 Not Started
  - 🟡 In Progress
  - 🟢 Complete
  - 🔴 Failed
  - 🟣 Other

Phase status rules:

- When a phase begins, update it immediately to 🟡 In Progress.
- When a phase finishes successfully, update it immediately to 🟢 Complete.
- When a phase cannot proceed or has irrecoverable issues, update it immediately to 🔴 Failed.
- Use 🟣 Other only when the state does not fit the predefined categories, and state the specific condition clearly.
- A phase must never remain 🔵 Not Started once work has begun. The gating condition for the transition to 🟡 In Progress is defined in the "Pre-implementation gates" section below; work must not begin until those gates are filled.
- If a branch was created for a phase, the phase must not be marked 🟢 Complete until that branch is merged.
- Status must reflect reality, not optimism.

Step-level tracking:

- If a phase contains multiple steps, each step must include its own status.
- Allowed step statuses:
  - ✅ Complete
  - ❌ Failed
  - ⏳ In Progress
  - ⛔ Blocked
  - ⏸️ On Hold
  - 🔎 Under Review
  - 🧪 Testing
  - 📝 Pending Approval
  - 🟪 Other may only be used when no defined status applies. If selected, an explanation is mandatory.

Step rules:

	•	Every step must always display its current status.
	•	A step must not be marked ✅ Complete unless fully completed and verified.
	•	If a step fails, mark ❌ Failed and state the reason.
	•	If blocked, mark ⛔ Blocked and state the dependency or blocker.
	•	If 🟪 Other has been selected, an explanation is mandatory.
	•	Step status must roll up logically to the phase status.

Execution standard:

- Status must be visible at the top of each phase.
- Steps must be clearly nested under their parent phase.
- Update statuses immediately when state changes.
- No silent transitions.
- Do not rewrite history.
- When the plan is completed, update the Completed field in the header immediately with the actual date and time.

Core principle:

- Clarity over comfort.
- Accuracy over appearance.
- Visibility over assumption.
- Consistency over novelty.
- Reuse over reinvention.
- Preserve existing contracts unless change is explicit, justified, and system-wide consistent.

Pre-implementation gates (mandatory before a phase may move to 🟡 In Progress):

- Every plan must include a filled-in "Pre-implementation gates" block. Sections are proportionate to scope: trivial changes may be one-liners; larger changes must be complete.
- Prior-art and reuse check (always required):
  - Existing functions / modules / services that already solve part of the problem (list paths and what will be reused).
  - Existing abstractions or patterns this plan will extend.
  - New abstractions being introduced (requires justification: why existing options are insufficient, why extension is not appropriate, how consistency will be preserved).
  - Cross-surface equivalents checked (API, workers, frontend, tests): yes / no.
  - For shared/canonical logic, follow `CENTRALISED_BUSINESS_LOGIC.md`.
- Threat model (required whenever the plan touches authentication, authorisation, user data, external surfaces, secrets, infra, or dependency supply chain; otherwise state "n/a, reasoning"):
  - Assets at risk.
  - Trust boundaries crossed.
  - New attack surfaces introduced.
  - Mitigations (linked to controls in `SECURITY_BY_DEFAULT.md`).
  - Explicitly out of scope.
- A phase must not transition from 🔵 Not Started to 🟡 In Progress until both sub-sections above are filled or explicitly marked n/a with reasoning.

Consistency and codebase conformity:

- Plans must conform to the existing codebase. The canonical rules for conformity, refactoring scope, and readability live in `CODEBASE_ALIGNMENT_POLICY.md` and apply to plans as well as implementation.
- In addition, plans specifically must:
  - identify the existing contracts, invariants, and behavioural expectations that the change must preserve
  - keep cross-surface changes aligned: API, MCP, schemas, services, workers, docs, and operational guidance should not drift
  - if a new pattern is introduced, explicitly justify why the current pattern is insufficient, why extension is not appropriate, and how consistency will be preserved
- For shared/canonical business logic specifically, defer to `CENTRALISED_BUSINESS_LOGIC.md`.

### Plan mirroring (Warp Drive ⇄ repo)
Every plan must exist in two synchronised locations: the canonical Warp Drive plan document, and a mirrored Markdown file checked into each affected repository.

Location and naming:
- Mirror path: `docs/ai-planning/<snake_case_slug>.md` in each affected repo.
- Slug: derived from the plan title, lower-case, ASCII only, words separated by underscores.
- One file per plan. Do not date-prefix or version-suffix the filename; history is tracked via Git.
- Multi-repo plans: mirror must exist in every affected repository at the same path.
- Header fields: `Warp Drive plan:` (canonical plan identifier) and `Mirrors:` (list of repo paths).

Sync timing (mandatory):
- Every edit to the Warp Drive plan must be mirrored to every affected repo as part of the same change-set.
- A phase must not transition status until the repo mirror(s) reflect the Warp Drive content for that transition.
- Silent divergence between Warp Drive and the repo mirror(s) is a breach of this rule.

Ownership and authority:
- The Warp Drive plan is the human-facing canonical copy for discussion and status.
- The repo mirror is the machine-auditable copy for PR review, CI, and historical reference.
- When the two diverge, stop and reconcile before further work.

Completed-plan archival:
- When a plan is marked complete (its `Completed` field filled with actual date and time), the mirrored file must be moved from `docs/ai-planning/<snake_case_slug>.md` to `docs/ai-planning/complete/<snake_case_slug>.md` in every affected repository.
- Use `git mv` so history is preserved. Files under `complete/` are immutable.
- The Warp Drive copy's `Completed` field must stay consistent with the mirror location.

### Enforcement
- Applies to: every plan that gates any non-trivial change.
- Consequence on breach: a phase must not transition from `🔵 Not
  Started` to `🟡 In Progress` until the pre-implementation gates are
  filled; a plan must not be marked complete until the `Completed` field
  is set with the actual date and time AND the mirror has been moved to
  `docs/ai-planning/complete/` in every affected repository; a phase
  must not transition status at all while the Warp Drive plan and its
  repo mirror(s) under `docs/ai-planning/` are out of sync; a reviewer
  must block any PR whose plan does not meet these requirements.

