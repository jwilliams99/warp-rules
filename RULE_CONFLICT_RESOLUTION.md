## Rule: Rule Conflict Resolution

- Priority: CRITICAL
- Importance: HIGH
- Never Ignore: true
- Description:
  When two or more rules give conflicting direction for the same situation,
  the agent must not resolve the conflict silently. Stop, surface the conflict
  to a human, and propose a resolution that can be incorporated into the
  ruleset to prevent recurrence.

### Why
Silent conflict resolution is a form of undocumented decision-making. When an
agent picks one rule over another without flagging it, the human loses
visibility into both the decision and the gap in the ruleset. Over time this
produces behaviour that is inconsistent and untraceable. Making conflict
resolution explicit keeps the ruleset accurate and the human in control.

---

### Priority ordering (unambiguous cases)

When two rules conflict, apply the following priority ordering before
escalating to a human. Only use this ordering when the conflict is clear and
the higher-priority rule unambiguously applies:

1. SECRETS_AND_CREDENTIALS_HANDLING.md
2. SECURITY_BY_DEFAULT.md
3. FACTUAL_AND_TRANSPARENT_RESPONSE.md
4. PLANNING.md
5. DEVELOPMENT_PROCESS.md
6. CI_GATES.md
7. TEST_DRIVEN_DEVELOPMENT.md
8. DATABASE_MIGRATIONS.md
9. CENTRALISED_BUSINESS_LOGIC.md
10. CODEBASE_ALIGNMENT_POLICY.md
11. PERIODIC_CODEBASE_HYGIENE_REVIEW.md
12. GIT_AUTOCOMMIT.md
13. MANDATORY_CONVENTIONAL_COMMITS.md
14. STANDARD_TOOLING.md
15. NATURAL_LANGUAGE_STANDARD.md

Higher position in this list takes precedence. If applying this ordering
still leaves genuine ambiguity — for example because the rules operate on
different concerns and neither clearly overrides the other — escalate to a
human immediately. Do not guess.

---

### When to escalate to a human

Escalate whenever any of the following are true:

- The priority ordering does not resolve the conflict clearly.
- Both rules appear to apply to the same concern at the same level.
- Applying the higher-priority rule would require violating the intent (not
  just the letter) of the lower-priority rule in a way that seems wrong.
- The conflict involves a security, tenancy, or data integrity concern where
  the safe choice is not obvious.
- The conflict has not been seen before and no precedent exists in the ruleset.

When in doubt, escalate. A unnecessary escalation costs seconds. A silent
wrong resolution can cost much more.

---

### How to escalate

When escalating, the agent must provide the human with all of the following:

1. **The conflict** — state the two (or more) rules that are in tension and
   the specific guidance in each that conflicts.

2. **The context** — describe the situation that triggered the conflict: what
   task is being performed, what decision point was reached, and what the
   consequences of each option appear to be.

3. **A proposed resolution** — provide a concrete recommendation for how the
   conflict should be resolved in this situation, with reasoning. Do not just
   present the conflict and wait; give the human something to react to.

4. **A proposed rule update** — draft specific wording that could be added to
   one or more of the affected rule files to prevent the same conflict from
   recurring. This may be:
   - a clarification to an existing rule
   - an explicit tiebreaker added to this file's priority ordering
   - a new exception or carve-out in one of the conflicting rules

The human decides. The agent does not proceed until a decision is made.

---

### After resolution

Once the human has made a decision:

- Apply the resolution to the current task.
- Update the relevant rule file(s) with the agreed wording, or record that
  the human chose not to update the rules and why.
- Commit the rule update as a separate commit from the task work, using the
  format:
    docs(rules): clarify conflict between <rule-a> and <rule-b>
- Do not silently absorb the resolution without updating the rules. If the
  same conflict recurs and the rules have not been updated, the agent will
  have no basis for resolving it consistently.

---

### Common known conflict patterns

The following conflicts are known to arise and should be escalated immediately
rather than resolved by priority ordering alone, as they require human
judgement:

**CODEBASE_ALIGNMENT_POLICY vs CENTRALISED_BUSINESS_LOGIC**
Following local conventions may mean replicating logic that should be
canonical. Consolidating into a canonical location may mean deviating from
local patterns. Neither rule clearly overrides the other in all cases —
the right answer depends on whether the local pattern is an intentional
convention or accumulated drift.

**DEVELOPMENT_PROCESS vs GIT_AUTOCOMMIT**
Phase boundary rules and auto-commit batching rules can conflict when a
coherent logical change spans what the phase boundary would consider separate
concerns. Escalate rather than deciding unilaterally which boundary takes
precedence.

**PLANNING vs FACTUAL_AND_TRANSPARENT_RESPONSE**
A plan may describe expected behaviour that the agent cannot verify without
reading source files. Proceeding on plan-derived assumptions without reading
the implementation violates FACTUAL_AND_TRANSPARENT_RESPONSE. Stop, state
what needs to be verified, and ask before proceeding.

---

### Relationship to other rules

- All other rule files may reference this file when they anticipate conflict
  with another rule.
- This file does not override any individual rule — it defines the process
  for resolving conflicts between them.

---

### Enforcement
- Mandatory.
- Applies to: all situations where two or more rules give conflicting direction.
- Silent conflict resolution is non-compliant regardless of whether the
  outcome was correct.