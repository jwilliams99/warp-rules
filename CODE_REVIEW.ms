## Code review rules

### Correctness
- Verify the implementation matches the approved plan exactly, including all explicitly called-out edge cases.
- Check that all conditional branches are reachable, meaningful, and covered by tests.
- Ensure defaults are applied in the correct resolution layer and are never silently skipped.
- Ensure early-return paths behave consistently with the happy path.

### Security and access control
- Every scoped query or data access path must include the correct ownership, tenancy, or visibility filters. No exceptions.
- No out-of-scope data may appear in partial responses, warnings, logs, or error messages.
- Principal, actor, or permission constraints must follow existing codebase patterns exactly.
- Do not introduce new auth or access paths implicitly.
- Visibility must not be broadened accidentally through aggregation, fallback logic, or convenience helpers.

### Data integrity
- All foreign keys must have explicit `ON DELETE` behaviour where applicable.
- Unique constraints must enforce the actual invariants described in the plan.
- Partial indexes must correctly cover all intended cases, including `NULL` and coalesced edge cases.
- Migrations must be reversible and must reference the correct `down_revision` or migration parent.

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
- Resolution chains must be implemented once in a canonical location and reused consistently.
- Do not reimplement fallback logic independently in multiple callers.
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
- Event metadata must never include secrets, raw API keys, passwords, or sensitive payloads.
- Emitted telemetry must support measurement of latency, partial-response rate, and dependency/source failure rate where required.
- Warnings must be informative enough for diagnosis without exposing internals.

### Test coverage quality
- Prefer TDD: tests should define expected behaviour before or alongside implementation, not only after.
- Every edge case explicitly named in the plan must have its own explicit test coverage.
- Isolation and access-boundary rules must have dedicated test coverage.
- Fallback chains must be tested end-to-end, not only in isolated unit tests.
- Failure-mode tests must assert degraded behaviour explicitly, not merely assert that no exception occurred.

### Code hygiene
- Remove dead code and retired paths from previous implementations.
- Constants must be defined once and reused, not hardcoded in multiple places.
- Module placement must follow established codebase patterns.
- Do not hide domain or service primitives in generic `utils` modules if a dedicated module is the established pattern.
- Do not leave `TODO` comments that represent unresolved design decisions.

### Documentation and artefact sync
- `README`, operational guidance, skills/docs, current-state docs, and related contract docs must be updated in the same change set when required.
- API/schema artefacts must reflect the actual implemented endpoints and schemas.
- Retired guidance must be removed, not left in place beside replacement guidance.

### Consistency and codebase conformity
- Prefer reuse or extension of existing contracts, helpers, patterns, and service boundaries over introducing new ones.
- Do not introduce duplicate abstractions, overlapping rules, parallel workflows, or competing sources of truth.
- Where an existing codebase pattern already solves the problem, follow it unless deviation is explicitly justified.
- Ensure naming, layering, error semantics, event structure, schema style, and module placement remain consistent with the surrounding codebase.