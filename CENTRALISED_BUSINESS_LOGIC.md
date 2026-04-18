## Rule: Centralise shared business logic in a single canonical function

When a function implements shared business rules or validation logic (for
example password complexity, email or phone validation, eligibility
checks, pricing, permissions), it must exist in exactly one canonical
place and be reused everywhere else.

### Why
Duplicate implementations drift. Even small differences create conflicting
behaviour across UI, API, and services, leading to bugs, security issues,
and inconsistent user experiences.

### Principles
1. **Single source of truth** — one canonical implementation per rule-set.
   All consumers call it rather than reimplementing the logic.
2. **Shared library placement** — canonical logic lives in a shared module
   or package (for example `packages/validation`, `packages/security`,
   `lib/rules`), not inside a single app unless the rule is app-specific.
3. **Consistency across boundaries** — when frontend and backend need the
   same validation, either a shared package is used by both, or the
   backend is authoritative and the frontend mirrors using the same shared
   logic. Never a reimplementation.
4. **Tests live with the canonical logic** — unit tests cover the rule-set
   in the central module. Consumers test integration and usage, not the
   rule-set itself.
5. **Changes require an impact check** — any change to canonical rules
   must include a versioning or change note (if published) and
   confirmation of impacted consumers.

### Workflow: before writing a new function
1. **Search first, write second.** Search by:
   - keyword and partial name;
   - function signature (argument shape, return shape);
   - behavioural match (what it does, not just what it is called).
2. **Search locations in order**:
   - canonical shared modules (for example `packages/validation`,
     `packages/security`, `lib/rules`);
   - the service layer and domain layer;
   - neighbouring files in the same package or module.
3. **Parameterise, do not duplicate.** If a near-match exists, prefer
   adding an explicit parameter or configuration option to the existing
   function over creating a variant.
4. **Record the decision.** If reuse is genuinely impossible, record it
   in the plan's "Pre-implementation gates → Prior-art and reuse check"
   section (see `PLANNING.md`) and in the PR's "Reuse and alignment"
   section (see `DEVELOPMENT_PROCESS.md`).
5. **Run the duplication scan.** Before opening a PR, run the duplication
   scan defined in `CI_GATES.md` locally.

### PR checklist
- Did you reuse an existing canonical function instead of creating a new one?
- If you introduced a new rule-set, is it in the shared module with tests?
- If behaviour differs by context, did you parameterise rather than
  duplicate?

### Relationship to other rules
- `CODEBASE_ALIGNMENT_POLICY.md` — matching local style while centralising
  logic; escalate to `RULE_CONFLICT_RESOLUTION.md` if the two conflict.
- `CI_GATES.md` — automated duplication scan and tooling per stack.
- `PLANNING.md` — Prior-art and reuse check in pre-implementation gates.
- `DEVELOPMENT_PROCESS.md` — Reuse and alignment section of the PR
  template.

### Enforcement
- Applies to: all shared business rules, validation logic, permission
  checks, pricing rules, and eligibility checks.
- Consequence on breach: the duplication scan defined in `CI_GATES.md`
  fails CI; a reviewer must block any PR that introduces a parallel
  implementation of canonical logic.
