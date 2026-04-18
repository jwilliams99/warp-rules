## Rule: Codebase alignment policy

When working in an existing codebase, match the local style and
conventions of the surrounding code. Prefer existing patterns over
introducing new ones.

### Conformity
- If working in an existing codebase, inspect nearby files before making
  changes.
- Match the local style and conventions of the surrounding code.
- Follow existing patterns for naming, formatting, structure, abstractions,
  error handling, and tests.
- Prefer existing utilities, helpers, and architectural patterns over
  introducing new ones.
- Keep changes cohesive with the nearest relevant code.

### Refactoring
- Do not over-complicate refactors.
- Prefer the smallest clear change that solves the problem.
- Avoid unnecessary abstraction, indirection, generalisation, or large
  stylistic rewrites.
- Do not expand scope without a clear reason.
- Refactor to improve clarity and maintainability, not to showcase
  cleverness.

### Readability standard
- Write code for a mid-to-senior human reader.
- Prefer clarity over cleverness.
- Keep control flow straightforward and easy to reason about.
- Use descriptive names and justified abstractions.
- Optimise for maintainability and reviewability.

### When the local codebase is inconsistent
- Follow the conventions used in the closest relevant files.
- Prefer the most established local pattern over a global preference.
- Keep the solution internally consistent.
- State any intentional deviation and why it was necessary.

### Boy Scout rule
- Leave touched files cleaner than you found them, within the phase scope
  defined in `DEVELOPMENT_PROCESS.md`.
- Do not expand the change set beyond the phase boundary to accommodate
  cleanup; file a hygiene ticket instead (see
  `PERIODIC_CODEBASE_HYGIENE_REVIEW.md`).

### Pre-PR alignment self-check (author, before opening a PR)
- Did you search the repo for existing functions with overlapping purpose
  (by keyword AND by signature)?
- Did you check shared packages (for example `packages/validation`,
  `lib/rules`, `common/`) before introducing a new helper?
- If you added a new helper, can it live beside an existing one instead of
  in a new module?
- Does the naming, layering, and error handling match the nearest two or
  three relevant files?
- Did you run the duplication scan defined in `CI_GATES.md` locally and
  resolve or justify every finding? Every repository with active
  development must have a duplication scan configured. If the repository
  does not yet have one, add it as part of this change; a missing scan is
  itself a gap that must be closed.
- Did you apply the Boy Scout rule within the phase scope defined in
  `DEVELOPMENT_PROCESS.md`?

### Completion standard
- No change is complete unless it is consistent with the surrounding
  codebase.
- Any significant deviation from local conventions must be explicitly
  justified.

### Related canonical rules
- `CENTRALISED_BUSINESS_LOGIC.md` — shared business rules, validation
  logic, permission checks, and single-source-of-truth concerns.
- `PERIODIC_CODEBASE_HYGIENE_REVIEW.md` — broader codebase decay (dead
  code, TODOs, magic numbers, documentation currency).
- `CI_GATES.md` — required CI checks and duplication-detection tooling.
- `RULE_CONFLICT_RESOLUTION.md` — if this rule appears to conflict with
  `CENTRALISED_BUSINESS_LOGIC.md`, escalate per that process.

### Enforcement
- Applies to: every change, every repository.
- Consequence on breach: a reviewer must block any PR that deviates from
  local conventions without explicit justification, and the duplication
  scan defined in `CI_GATES.md` must pass before approval.
