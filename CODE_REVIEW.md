## Code review rules

This rule covers code-review concerns that are specific to reviewing a change in flight. Topics that are owned by other rules are linked below rather than restated, to keep a single source of truth.
### Canonical rules this rule defers to
- Security and access control: see `SECURITY_BY_DEFAULT.md` and `SECRETS_AND_CREDENTIALS_HANDLING.md`.
- Test coverage and TDD expectations: see `TEST_DRIVEN_DEVELOPMENT.md`.
- Code hygiene, dead code, TODO/FIXME, magic numbers, dependency health, documentation currency: see `PERIODIC_CODEBASE_HYGIENE_REVIEW.md`.
- Migration reversibility, ORM usage, and DDL/DML discipline: see `DATABASE_MIGRATIONS.md`.
- Shared/canonical business logic and single-source-of-truth: see `CENTRALISED_BUSINESS_LOGIC.md`.
- Codebase conformity, refactoring scope, and readability standard: see `CODEBASE_ALIGNMENT_POLICY.md`.
- Planning conformance (phase status, plan-vs-implementation): see `PLANNING.md` and `DEVELOPMENT_PROCESS.md`.
### Correctness
- Verify the implementation matches the approved plan exactly, including all explicitly called-out edge cases.
- Check that all conditional branches are reachable, meaningful, and covered by tests.
- Ensure defaults are applied in the correct resolution layer and are never silently skipped.
- Ensure early-return paths behave consistently with the happy path.
### Access boundary checks (review-time)
- Every scoped query or data access path must include the correct ownership, tenancy, or visibility filters. No exceptions.
- No out-of-scope data may appear in partial responses, warnings, logs, or error messages.
- Principal, actor, or permission constraints must follow existing codebase patterns exactly.
- Do not introduce new auth or access paths implicitly.
- Visibility must not be broadened accidentally through aggregation, fallback logic, or convenience helpers.
- For broader security-by-design expectations, defer to `SECURITY_BY_DEFAULT.md`.
### Data integrity
- All foreign keys must have explicit `ON DELETE` behaviour where applicable.
- Unique constraints must enforce the actual invariants described in the plan.
- Partial indexes must correctly cover all intended cases, including `NULL` and coalesced edge cases.
- For migration reversibility, `down_revision` linkage, and ORM/DDL discipline, defer to `DATABASE_MIGRATIONS.md`.
### Error handling
- Every external or optional dependency call must have an explicit graceful failure path.
- Errors must be classified correctly: retryable vs non-retryable, hard vs soft.
- Error responses must never expose stack traces, raw SQL errors, or internal implementation details.
- Status code distinctions must be applied consistently, especially `404` vs `422` vs `503`.
### Contract stability
- New schema fields must be additive, optional where required, and have explicit defaults where appropriate.
- Existing contracts must not be silently broken.
- Event metadata changes must be additive only; do not rename or remove existing keys without explicit approval.
- Equivalent surfaces must remain contract-aligned for the same inputs unless divergence is explicitly justified.
- API or schema artefacts must be regenerated and must match the implemented contract.
### Service layer discipline
- Business logic belongs in the service layer or domain layer, not in route handlers, transport handlers, or workers.
- Route handlers should only do auth, input validation, and response mapping.
- Transport handlers should only do input mapping, auth/context wiring, and response mapping.
- Do not place raw SQL in route or transport handlers.
- Do not place business-rule decisions in background jobs if they belong in shared services.
### Fallback chain implementation
- For canonical-location and reuse expectations, defer to `CENTRALISED_BUSINESS_LOGIC.md`.
- Request-provided invalid values must be rejected where the contract says so.
- Config-derived invalid values must be clamped, corrected, or warned exactly as specified.
- `NULL`, missing-key, empty-string, and whitespace semantics must be handled consistently across the full chain.
### Concurrency and race conditions
- Upserts and replacement flows must be atomic or explicitly race-safe.
- Avoid select-then-insert patterns unless the race is explicitly handled.
- Jobs that operate per scope must resolve configuration per scope, not once globally.
- Do not introduce shared mutable state across requests or job executions.
### Observability
- Every mutating operation must emit the event(s), logs, or metrics required by the plan.
- Event metadata must never include secrets, raw API keys, passwords, or sensitive payloads (see `SECRETS_AND_CREDENTIALS_HANDLING.md`).
- Emitted telemetry must support measurement of latency, partial-response rate, and dependency/source failure rate where required.
- Warnings must be informative enough for diagnosis without exposing internals.
### Duplication and alignment (reviewer must verify)
- No function added duplicates an existing one: reviewer searches by name, signature, and behaviour before approving.
- Shared logic lives in the canonical location per `CENTRALISED_BUSINESS_LOGIC.md`, not beside a single caller.
- New module placement matches established patterns in the surrounding code.
- Naming, error handling, and layering match the nearest relevant files per `CODEBASE_ALIGNMENT_POLICY.md`.
- If a new abstraction is introduced, the plan's "Pre-implementation gates → Prior-art and reuse check" section justifies it.
- The PR's "Reuse and alignment" section is complete and the duplication-scan result is attached (see `CI_GATES.md`).
### TODO discipline at review time
- TODO/FIXME/HACK comments are only acceptable if they link to a tracked ticket, in line with `PERIODIC_CODEBASE_HYGIENE_REVIEW.md`.
- TODOs that represent unresolved design decisions must be resolved before the change is approved, not deferred via a ticket.

### Enforcement
- Applies to: every PR under review.
- Consequence on breach: a reviewer must withhold approval and request
  changes until every concern listed above is resolved or explicitly
  justified. Approving a PR with unresolved items is itself a review
  defect.
