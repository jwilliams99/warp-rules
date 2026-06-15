## Rule: Rule conflict resolution

When two or more rules give conflicting direction for the same situation,
the agent must not resolve the conflict silently. Stop, surface the
conflict to a human, and propose a resolution that can be incorporated
into the ruleset to prevent recurrence.

### Why
Silent conflict resolution is undocumented decision-making. When an agent
picks one rule over another without flagging it, the human loses visibility
into both the decision and the gap in the ruleset. Over time this produces
behaviour that is inconsistent and untraceable. Making conflict resolution
explicit keeps the ruleset accurate and the human in control.

### Domain separation, not ordering
Each rule in this ruleset covers a distinct domain (security, planning,
testing, commits, hygiene, and so on). Domains do not have a total ordering;
a rule in one domain does not automatically override a rule in another. This
rule therefore does not publish a priority list. When two rules appear to
conflict, the agent must treat the conflict as a gap in the ruleset, not a
question of rank.

### Domain map
This section maps each remaining rule to its domain.

**Security and trust**
- Broad security design, gates, least privilege, secrets, credentials,
  detection, rotation, incident playbook, security tests:
  `SECURITY_BY_DEFAULT.md`.
- Required CI checks and detection tooling per stack: `CI_GATES.md`.

**Planning and delivery**
- Plan document structure, phase status, pre-implementation gates:
  `PLANNING.md`.
- Phase execution, branching, PR template, Definition of Done:
  `DEVELOPMENT_PROCESS.md`.
- Commit format, auto-commit rules, TDD red-first, WIP markers:
  `COMMIT_DISCIPLINE.md`.

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
- Factual grounding, uncertainty handling, prohibited patterns,
  Australian / UK English language standard:
  `FACTUAL_AND_TRANSPARENT_RESPONSE.md`.
- Safewill GCP requests must use the dedicated operations skill first:
  `SAFEWILL_GCP_OPERATIONS.md`.

**Process meta**
- This file: `RULE_CONFLICT_RESOLUTION.md`.

### Cross-cutting pointers
Some concerns are touched by multiple rules; the canonical source is
listed first, the references are listed in parentheses.

- Duplication and reuse: `CENTRALISED_BUSINESS_LOGIC.md` (plus
  `CODEBASE_ALIGNMENT_POLICY.md`, `CODE_REVIEW.md`, `CI_GATES.md`).
- Security gates: `SECURITY_BY_DEFAULT.md` (plus `CI_GATES.md` for the
  specific tools, `DEVELOPMENT_PROCESS.md` for the DoD bullets).
- Documentation currency: `PERIODIC_CODEBASE_HYGIENE_REVIEW.md` (plus
  `DEVELOPMENT_PROCESS.md` DoD).
- Commit format: `COMMIT_DISCIPLINE.md` (plus
  `TEST_DRIVEN_DEVELOPMENT.md` for the red-first marker).

### When to escalate
Escalate to a human whenever any of the following are true:

- Two rules give directly contradictory direction for the same situation.
- A rule's guidance in one domain would require violating the intent of a
  rule in another domain.
- The safe choice is not obvious, especially where security, tenancy, data
  integrity, or user-facing behaviour is involved.
- The conflict has not been seen before and no precedent exists in the
  ruleset.

When in doubt, escalate. An unnecessary escalation costs seconds. A silent
wrong resolution can cost much more.

### How to escalate
When escalating, provide the human with all of the following:

1. **The conflict** — state the two (or more) rules in tension and the
   specific guidance in each that conflicts.
2. **The context** — describe the situation that triggered the conflict:
   what task is being performed, what decision point was reached, and what
   the consequences of each option appear to be.
3. **A proposed resolution** — give a concrete recommendation for how the
   conflict should be resolved in this situation, with reasoning. Do not
   present the conflict and wait; give the human something to react to.
4. **A proposed rule update** — draft wording that could be added to one or
   more of the affected rule files to prevent the same conflict from
   recurring. This may be a clarification, an explicit carve-out, or a new
   cross-reference.

The human decides. The agent does not proceed until a decision is made.

### After resolution
- Apply the resolution to the current task.
- Update the affected rule file(s) with the agreed wording, or record that
  the human chose not to update the rules and why.
- Commit the rule update as a separate commit from the task work, per
  `COMMIT_DISCIPLINE.md`. Example:

```
docs(rules): clarify conflict between codebase-alignment and centralised-logic
- added tie-break guidance to CODEBASE_ALIGNMENT_POLICY.md
- cross-referenced CENTRALISED_BUSINESS_LOGIC.md workflow section
- recorded precedent in RULE_CONFLICT_RESOLUTION.md known patterns
NO-TICKET
```

### Known conflict patterns
The following conflicts are known to arise and must be escalated explicitly
rather than resolved unilaterally.

**`CODEBASE_ALIGNMENT_POLICY.md` vs `CENTRALISED_BUSINESS_LOGIC.md`**
Following local conventions may mean replicating logic that should be
canonical. Consolidating into a canonical location may mean deviating from
local patterns. The right answer depends on whether the local pattern is an
intentional convention or accumulated drift.

**`DEVELOPMENT_PROCESS.md` vs `COMMIT_DISCIPLINE.md`**
Phase-boundary rules and auto-commit batching rules can conflict when a
coherent logical change spans what the phase boundary would consider
separate concerns. Escalate rather than deciding unilaterally which
boundary takes precedence.

**`PLANNING.md` vs `FACTUAL_AND_TRANSPARENT_RESPONSE.md`**
A plan may describe expected behaviour the agent cannot verify without
reading source files. Proceeding on plan-derived assumptions without
reading the implementation violates `FACTUAL_AND_TRANSPARENT_RESPONSE.md`.
Stop, state what needs to be verified, and ask before proceeding.

### Relationship to other rules
- This rule defines the process for resolving conflicts; it does not itself
  adjudicate between rules.
- All other rule files may reference this file when they anticipate a
  conflict with another rule.
- The domain map above replaces the former `RULES_INDEX.md` file.

### Enforcement
- Applies to: all situations where two or more rules give conflicting
  direction.
- Consequence on breach: the agent must stop and escalate with the four
  required artefacts (the conflict, the context, a proposed resolution,
  and a proposed rule update). Silent conflict resolution is
  non-compliant regardless of whether the outcome was correct.
