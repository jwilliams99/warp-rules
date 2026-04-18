Planning document requirements:

- Every plan must begin with:
  - Created: YYYY-MM-DD HH:MM
  - Completed: Not completed
- Set Created when the plan is first written.
- Leave Completed as Not completed until the plan is fully finished.
- When the plan is complete, update Completed immediately with the actual date and time.
- A plan is not complete until the Completed field has been updated.

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
- A phase must never remain 🔵 Not Started once work has begun.
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
  - For shared/canonical logic, follow `CENTRALISED_BUSINSS_LOGIC.md`.
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
- For shared/canonical business logic specifically, defer to `CENTRALISED_BUSINSS_LOGIC.md`.
