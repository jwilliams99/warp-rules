## Rule: Centralise shared business logic in a single canonical function

•  Priority: HIGH
•  Importance: HIGH
•  Never Ignore: true
•  Description:
  When a function implements shared business rules or validation logic (e.g., password complexity, email/phone validation, eligibility checks, pricing, permissions), it must exist in exactly one canonical place and be reused everywhere else.

### Why
Duplicate implementations drift. Even small differences can create conflicting behaviour across UI/API/services, leading to bugs, security issues, and inconsistent user experiences.

### Requirements

1. **Single source of truth**
   •  There must be one canonical implementation per rule-set.
   •  All consumers must call it rather than reimplementing logic.

2. **No duplicates**
   •  Do not copy/paste or "recreate" similar functions elsewhere.
   •  If you need different behaviour, add explicit configuration/parameters to the canonical function (or define a separate clearly named rule-set).

3. **Shared library placement**
   •  Put canonical logic in a shared module/package (e.g., `packages/validation`, `packages/security`, `lib/rules`), not inside a single app unless it's app-specific.

4. **Consistency across boundaries**
   •  If both frontend and backend need the same validation, prefer:
     ◦  shared package used by both, or
     ◦  backend is authoritative + frontend mirrors using the same shared logic (not a reimplementation).

5. **Tests live with the canonical logic**
   •  Unit tests must cover the rule-set in the central module.
   •  Consumers should not re-test the same rules; they test integration/usage.

6. **Changes require impact check**
   •  Any change to canonical rules must include:
     ◦  versioning / change note (if published)
     ◦  confirmation of impacted consumers (apps/services)

### PR Checklist
•  Did you reuse an existing canonical function instead of creating a new one?
•  If you introduced a new rule-set, is it in the shared module with tests?
•  If behaviour differs by context, did you parameterise rather than duplicate?

### Enforcement
•  mandatory
•  Applies to: all shared business rules, validation logic, permission checks, pricing rules, eligibility checks