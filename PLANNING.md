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

Consistency and codebase conformity:

- Plans must conform to the existing codebase unless there is a clear, explicit reason not to.
- Existing contracts, patterns, naming, layering, and behavioural conventions must be reviewed before proposing new design.
- Do not create duplicate abstractions, parallel workflows, overlapping rules, or competing sources of truth.
- Prefer reuse, extension, or refactoring of existing patterns over invention of new ones.
- If a plan introduces a new pattern, it must explicitly justify:
  - why the current codebase pattern is insufficient
  - why extension is not appropriate
  - how consistency with the rest of the system will be preserved
- Plans must identify the existing contracts, invariants, and behavioural expectations that the change must preserve.
- Cross-surface changes must remain aligned: API, MCP, schemas, services, workers, docs, and operational guidance should not drift.
