## Standard PR template

Every PR must use this structure. PR descriptions must be concise, factual, and traceable to the plan.

```markdown
## Plan
- Plan: <plan name>
- Phase: <phase number and name>

## Purpose
- What this phase implements

## Scope
- What is included
- What is intentionally not included

## Changes
- Summary of the code, schema, contract, or documentation changes

## Reuse and alignment
- Existing functions / modules reused (paths)
- New abstractions introduced, with justification (link plan's Prior-art section)
- Duplication scan result (tool, findings, allowlist deltas)
- Nearest relevant files consulted for style and alignment

## Hygiene
- Dead code / unused imports removed in touched files: yes / no / n-a
- New TODO / FIXME comments link to tickets: yes / no / n-a
- Docs / README / docstrings updated: yes / no / n-a
- Complexity, file-size, and coverage budgets respected: yes / no / n-a

## Gates
Two-part gate: first that the Pre-implementation gates were filled in the
plan before work began (per PLANNING.md), and second that the during-
implementation updates have been reconciled.

Pre-implementation gates (verified before the phase branch was created):
- Prior-art and reuse check:
  - [ ] Completed — plan section filled; see "Reuse and alignment" above
  - [ ] n/a — state which surfaces were checked and why none applied
- Threat model:
  - [ ] Completed — link to the filled threat model in the plan
  - [ ] n/a — state which security-relevant surfaces were checked and
        confirmed not touched (auth, authz, user data, external surfaces,
        secrets, infra, supply chain)

If either gate was not completed before work began, state that explicitly
and do not check the box. A reviewer must not approve a PR where gates
were skipped or filled after implementation started.

Security updates during implementation:
- Security-relevant surfaces touched (auth, authz, data egress, secrets,
  infra, deps): yes / no
- Threat model updated (link plan's Threat model section) if the answer
  above is yes
- CI security gates green (see CI_GATES.md): secrets scan, SAST,
  dependency vulnerability scan
- Least-privilege review performed for any new IAM / DB grants / tokens:
  yes / no / n-a

## Validation
- Tests run (unit, integration, security, authz)
- Manual verification performed

## Contract impact
- API / schema / event / migration impact
- State whether changes are additive, breaking, or internal-only

## Risks / notes
- Known risks, follow-ups, or rollout considerations

## Plan conformance
- Confirm whether implementation matches the approved plan exactly
- If not, describe the deviation explicitly
```