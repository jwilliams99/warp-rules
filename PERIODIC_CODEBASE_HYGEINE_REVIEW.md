## Rule: Periodic codebase hygiene review

•  Priority: HIGH
•  Importance: HIGH
•  Never Ignore: true
•  Description:
  Perform regular code hygiene reviews to eliminate waste, reduce risk, and maintain a clean, navigable codebase. This complements the canonical-function rule by catching broader decay.

### Why
Codebases accumulate cruft over time — dead code, stale comments, unused dependencies, outdated documentation, and latent bugs. Without periodic review, these compound into slower development, harder onboarding, and hidden security risks.

### Review Cadence
•  Recommended: once per sprint or at minimum once per month
•  Trigger on: major feature completion, dependency upgrades, or team member transitions

### Hygiene Checklist

1. **Duplicate / near-duplicate code**
   •  Identify functions or blocks with overlapping logic.
   •  Consolidate into canonical functions per the shared-logic rule.

2. **Dead code & unreachable paths**
   •  Remove functions, classes, methods, and variables that are never called.
   •  Remove code behind impossible conditions or after unconditional returns.
   •  Remove commented-out code blocks — version control is the archive.

3. **Unused imports & dependencies**
   •  Strip unused imports from source files.
   •  Audit package manifests (package.json, requirements.txt, go.mod) for unused deps.

4. **TODO / FIXME / HACK audit**
   •  Every TODO must have a linked ticket or be resolved.
   •  TODOs older than 90 days without a ticket should be resolved or removed.

5. **Stale & misleading comments**
   •  Remove or rewrite comments that no longer match the code's behaviour.
   •  Prefer self-documenting code over explanatory comments where possible.

6. **Complexity reduction**
   •  Flag functions with high cyclomatic complexity (threshold: language-dependent, e.g. >10).
   •  Extract sub-functions or simplify conditionals.

7. **Naming consistency**
   •  Enforce project naming conventions (casing, prefixes, verb/noun patterns).
   •  Rename vague identifiers (data, temp, result, handle) to domain-specific names.

8. **Magic numbers & hardcoded strings**
   •  Extract to named constants, config files, or environment variables.

9. **Error handling**
   •  No bare/blanket exception catches without logging or re-raising.
   •  Ensure errors propagate meaningful context.

10. **Dependency health**
    •  Check for known CVEs (e.g., npm audit, pip-audit, govulncheck).
    •  Update deps that are >1 major version behind.
    •  Ensure all deps are pinned for reproducible builds.

11. **Test hygiene**
    •  Remove or fix permanently skipped tests.
    •  Flag tests with no assertions.
    •  Investigate and fix flaky tests.

12. **Security surface**
    •  Scan for hardcoded secrets, tokens, or credentials.
    •  Verify input validation on all public endpoints.
    •  Review permissions and scopes for least-privilege.

13. **Unused config & environment variables**
    •  Remove env vars and config keys that no code path references.
    •  Keep .env.example in sync with actual usage.

14. **Documentation currency**
    •  **README accuracy**
      ◦  Verify setup/install instructions work on a clean checkout.
      ◦  Confirm listed prerequisites, versions, and commands are current.
      ◦  Ensure project description reflects actual scope and purpose.
    •  **API documentation**
      ◦  All public endpoints / exported functions must have accurate docs.
      ◦  Request/response schemas, parameters, and return types must match implementation.
      ◦  Deprecated endpoints must be marked as such (not silently left).
    •  **Architecture & design docs**
      ◦  Diagrams and flowcharts must reflect the current system topology.
      ◦  Remove references to decommissioned services, old database schemas, or retired patterns.
      ◦  If architecture has diverged from docs, update docs or file a ticket to reconcile.
    •  **Inline documentation (docstrings / JSDoc / GoDoc)**
      ◦  Public functions, classes, and modules must have accurate docstrings.
      ◦  Parameter descriptions, return values, and exceptions/errors must match the signature.
      ◦  Remove docstrings that describe behaviour the code no longer implements.
    •  **Runbooks & operational docs**
      ◦  Deployment steps must match the current CI/CD pipeline.
      ◦  Incident response procedures must reference current tooling and contacts.
      ◦  Verify monitoring/alerting references point to active dashboards and channels.
    •  **Changelog / ADRs (Architecture Decision Records)**
      ◦  Significant changes must be recorded in a changelog or ADR.
      ◦  ADRs for superseded decisions should be marked as such, not deleted.
    •  **Onboarding & contributing guides**
      ◦  New-contributor setup steps must work end to end.
      ◦  Coding standards, branch naming, and PR process docs must be current.
      ◦  Verify links to external resources (wikis, Confluence, Notion) are not broken.

### Outputs
Each review should produce:
•  A summary of findings (categorised by severity: critical / warning / info).
•  A list of actionable items, each linked to a ticket.
•  Confirmation that critical items are addressed before the next release.

### PR Checklist (for hygiene PRs)
•  Does this PR only remove / clean up code (no new features mixed in)?
•  Were removed items verified as unused (not just suspected)?
•  Do all tests still pass after cleanup?
•  Is the change set small enough for meaningful review?
•  Is documentation updated to reflect any removals or changes?

### Enforcement
•  mandatory
•  Applies to: all repositories with active development
•  Owner: rotating among team members each cycle