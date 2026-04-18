## Rules index

This file maps each rule to the domain it owns. It is a navigation aid,
not a policy. It does not override any individual rule; it complements
`RULE_CONFLICT_RESOLUTION.md` by making rule ownership explicit.

### How to use this index
- To find the authoritative source for a concern, scan the domains below.
- Each domain lists one canonical rule file. If a concern appears in more
  than one rule file, the canonical file is the one named here; the others
  must defer to it.
- If a concern has no canonical rule, that is a gap. Raise it per
  `RULE_CONFLICT_RESOLUTION.md` and propose a new rule or an extension.

### Domain map

**Security and trust**
- Broad security design, gates, least privilege, security tests:
  `SECURITY_BY_DEFAULT.md`.
- Secrets, credentials, detection, rotation, incident playbook:
  `SECRETS_AND_CREDENTIALS_HANDLING.md`.
- Required CI checks and detection tooling per stack: `CI_GATES.md`.

**Planning and delivery**
- Plan document structure, phase status, pre-implementation gates:
  `PLANNING.md`.
- Phase execution, branching, PR template, Definition of Done:
  `DEVELOPMENT_PROCESS.md`.
- Commit message format (including TDD and WIP carve-outs):
  `MANDATORY_CONVENTIONAL_COMMITS.md`.
- When auto-commit is allowed and how it batches:
  `GIT_AUTOCOMMIT.md`.

**Code quality and correctness**
- TDD, test categories, coverage expectations:
  `TEST_DRIVEN_DEVELOPMENT.md`.
- Code-review concerns specific to reviewing a change in flight:
  `CODE_REVIEW.md`.
- Codebase alignment, refactoring scope, readability, Boy Scout rule:
  `CODEBASE_ALIGNMENT_POLICY.md`.
- Single-source-of-truth for shared business logic:
  `CENTRALISED_BUSINESS_LOGIC.md`.
- Periodic hygiene review (dead code, TODOs, naming, docs currency):
  `PERIODIC_CODEBASE_HYGIENE_REVIEW.md`.

**Data layer**
- ORM usage, migrations, seed data, production DDL/DML discipline:
  `DATABASE_MIGRATIONS.md`.

**Agent behaviour and communication**
- Factual grounding, uncertainty handling, prohibited patterns:
  `FACTUAL_AND_TRANSPARENT_RESPONSE.md`.
- Natural-language standard (Australian / UK English):
  `NATURAL_LANGUAGE_STANDARD.md`.

**Process meta**
- What to do when rules conflict: `RULE_CONFLICT_RESOLUTION.md`.
- Standard tooling per language: `STANDARD_TOOLING.md`.
- This index: `RULES_INDEX.md`.

### Cross-cutting pointers
Some concerns are touched by multiple rules; the canonical source is
listed first, the references are listed in parentheses.

- Duplication and reuse: `CENTRALISED_BUSINESS_LOGIC.md` (plus
  `CODEBASE_ALIGNMENT_POLICY.md`, `CODE_REVIEW.md`, `CI_GATES.md`).
- Security gates: `SECURITY_BY_DEFAULT.md` (plus `CI_GATES.md` for the
  specific tools, `DEVELOPMENT_PROCESS.md` for the DoD bullets).
- Documentation currency: `PERIODIC_CODEBASE_HYGIENE_REVIEW.md` (plus
  `DEVELOPMENT_PROCESS.md` DoD).
- Commit format: `MANDATORY_CONVENTIONAL_COMMITS.md` (plus
  `GIT_AUTOCOMMIT.md` for auto-commit rules and
  `TEST_DRIVEN_DEVELOPMENT.md` for the red-first marker).

### Updating this index
Whenever a rule is added, renamed, or split, update this file in the same
change set. Missing or outdated entries here are a defect, not a nuisance:
they cause rule drift and make conflict resolution harder.

### Enforcement
- Applies to: the rule set itself; this file is navigational, not
  policy-bearing.
- Consequence on breach: an outdated entry is a hygiene defect. It must
  be corrected in the same change set as the rule addition, rename, or
  split that made it outdated.
