## Rule: Test-driven development

TDD is the default development approach. Tests are written before
implementation. No work is complete without test coverage or an explicit
documented exception.

### Why
Tests written after implementation tend to confirm the implementation rather
than specify the behaviour. Writing tests first forces clarity about what a
function must do before decisions are made about how it does it. It also
produces a suite that genuinely catches regressions rather than one that
merely accompanies the code.

---

### Core workflow

1. Write a failing test that specifies the required behaviour.
2. Implement the minimum code required to make the test pass.
3. Refactor only after the test is passing.
4. Repeat in small increments.

No implementation work should begin on a behaviour until a failing test for
that behaviour exists.

---

### TDD red-first commits

When recording a TDD red-first commit (a failing test as the starting point
of a cycle), follow the full conventional-commit format in
`MANDATORY_CONVENTIONAL_COMMITS.md` with the `[tdd-red]` marker on the
subject line:

```
test(auth): add failing test for negative authz [tdd-red]
- added test asserting 403 for unauthorised principal
- aligned with scope-leak expectations in SECURITY_BY_DEFAULT.md
NO-TICKET
```

A red-first commit must be followed by a green commit in the same session.
Do not leave a red-first commit as the last commit on a branch.

---

### When TDD is not appropriate

TDD may not be the right approach in a small number of cases, for example:
- exploratory or spike work where the shape of the solution is unknown
- infrastructure or configuration changes with no testable unit boundary
- purely generative output (e.g. OpenAPI artefact regeneration)

When TDD is not used:
- testing is still mandatory
- add the most suitable tests or verification for the implemented behaviour
- state explicitly in the PR why TDD was not used
- state what validation was performed instead

This is an exception path, not a default. It must be documented; it must not
be assumed.

---

### Test categories and expectations

**Unit tests**
- Cover individual functions, methods, and classes in isolation.
- Mock external dependencies.
- Must cover: happy path, boundary conditions, and failure modes.
- Edge cases called out explicitly in the plan must have explicit test cases.

**Integration tests**
- Cover interactions between components: service layer to database, handler
  to service, MCP surface to REST surface parity.
- Must cover: correct data flow end to end, not just that no exception is raised.

**Security and authorisation tests**
- Required for any feature touching authentication, authorisation, or data
  scoping, per `SECURITY_BY_DEFAULT.md`.
- Must include:
  - A positive authorisation test (allowed principal receives data).
  - A negative authorisation test (forbidden principal is denied with the
    correct status code).
  - A scope-leak test (results contain only the requesting principal's data).
  - A rate-limit or abuse test where applicable.
- Security tests must be written first (red-first), per `SECURITY_BY_DEFAULT.md`.

**Failure-mode tests**
- For any optional or external dependency, verify the degraded behaviour
  explicitly — not just that the code does not crash, but that the correct
  warning, partial response, or fallback is produced.

---

### Coverage expectations

- Coverage delta must not be negative on any PR.
- Skipped tests must be flagged and justified.
- Tests with no assertions are not acceptable.
- Flaky tests must be investigated and fixed, not ignored or re-run silently.

---

### Test hygiene

- Tests must be written before implementation, not retrofitted.
- A test that only confirms the implementation does what it does is not a
  specification — it is a mirror. Mirrors do not catch regressions.
- Do not test implementation details; test observable behaviour.
- Keep tests readable: a failing test should tell a reviewer exactly what
  broke and why without requiring them to read the implementation.

---

### Completion standard

No work is complete until:
- All required test categories are present and passing.
- Coverage delta is non-negative.
- Any exception to TDD is documented in the PR with reasoning and alternative
  validation stated.
- CI test gate is green per `CI_GATES.md`.

---

### Relationship to other rules

- **CI_GATES.md**: defines the CI test and coverage gates that enforce this rule
  automatically.
- **SECURITY_BY_DEFAULT.md**: defines security test expectations and the
  requirement to write negative authorisation tests first.
- **DEVELOPMENT_PROCESS.md**: TDD compliance is part of the Definition of Done
  for every phase; the PR template requires test results to be reported.
- **PLANNING.md**: plans must identify which test categories are required for
  each phase so expectations are set before implementation begins.

---

### Enforcement
- Applies to: all implementation phases across all repositories with
  active development.
- Consequence on breach: the CI test and coverage gates defined in
  `CI_GATES.md` fail; a reviewer must block a PR that ships without the
  required test categories or without documented TDD-exception
  reasoning. Undocumented absence of tests is not an exception; it is
  non-compliance.
