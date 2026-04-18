•  Priority: CRITICAL
•  Importance: EXTREME
•  Never Ignore: true
•  Description:
  Security must be designed into systems from inception, not bolted on afterward.
•  Enforcement: security gates are required at every stage of the lifecycle (see "Security gates" below), not only before deployment.
•  Philosophy: security is not a feature, it is a foundational requirement.

Approach

Existing Systems:

•  Step 1: understand current security mechanisms.
•  Step 2: document existing patterns and infrastructure.
•  Step 3: reuse and extend existing security controls (per `CENTRALISED_BUSINSS_LOGIC.md`).
•  Step 4: maintain consistency with established patterns (per `CODEBASE_ALIGNMENT_POLICY.md`).
•  Rationale: leverage existing, tested security infrastructure; avoid fragmentation.

New Systems:

•  Step 1: security architecture planning during initial design.
•  Step 2: complete the Threat model section in the plan (see `PLANNING.md` → Pre-implementation gates).
•  Step 3: implement security controls as foundational components.
•  Step 4: make security part of system DNA, not an afterthought.
•  Rationale: security by design is more effective than security by retrofit.

Security gates (enforced; non-advisory)

Gates apply at every stage of the lifecycle. Specific tools per stack are listed in `CI_GATES.md`; this rule defines what must be gated.

•  Pre-commit:
◦  Secrets scanning (see `SECRETS_AND_CREDENTIALS_HANDLING.md`).
◦  Lint, format, and type checks per `STANDARD_TOOLING.md`.
•  On pull request:
◦  SAST.
◦  Dependency vulnerability scan.
◦  IaC / container scans where applicable.
◦  Required-reviewer rules via CODEOWNERS on security-relevant paths (auth, authz, IaC, migrations touching sensitive tables, new external endpoints).
•  Pre-merge:
◦  Authorisation-path tests pass (see "Security tests" below).
◦  Threat model delta reconciled if the PR's "Security" section indicates a security-relevant surface was touched.
•  Pre-deploy:
◦  SBOM generated and stored with the artefact.
◦  Images and release artefacts are signed and verified.
◦  Runtime configuration reviewed (least-privilege check, network egress review).
•  Post-deploy:
◦  DAST or runtime scanning where applicable.
◦  Dependency drift monitoring (automated updates for CVEs; SLA: critical within 72 hours).
◦  Audit log review for the first operational window of any new surface.

Mandatory controls

Input validation:

•  Requirement: validate all user inputs.
•  Scope: every endpoint, every input field, every event or message payload.
•  Techniques: type checking; length limits; format validation; allow-list over deny-list; sanitisation where appropriate.
•  Enforcement: reject invalid input. Never trust client data.

Least privilege:

•  Principle: every identity, role, token, and credential must have the minimum permissions required to perform its function, for the minimum time required.
•  Database:
◦  Per-service DB roles with table-level grants; do not grant `ALL`.
◦  Row-level scoping helpers must be used for any tenanted data; see the access-boundary rules in `CODE_REVIEW.md`.
•  Cloud / IAM:
◦  Policies must be scoped to resources and actions actually used; avoid `*` in actions or resources.
◦  Prefer workload identity and short-lived tokens; long-lived credentials are an exception requiring documented justification.
•  Tokens and sessions:
◦  Default to short-lived tokens; rotate regularly.
◦  "Break-glass" admin paths are time-boxed and fully logged.
•  Review: every PR that adds or modifies IAM, DB grants, or tokens must record a least-privilege review in the PR template's Security section.

Secrets management:

•  The authoritative rule for handling and avoiding secret leakage is `SECRETS_AND_CREDENTIALS_HANDLING.md`.
•  Named secrets manager: every project must declare its canonical secrets backend in its README (for example Vault, AWS Secrets Manager, Google Secret Manager, Doppler, 1Password). Plaintext secrets in config files are prohibited.
•  Detection tooling (pre-commit and CI) is defined in `CI_GATES.md`.
•  Rotation policy: API keys, service-account keys, and long-lived tokens must have a documented maximum age and an owner.
•  Incident playbook: on detection — rotate, revoke, audit access, patch, post-mortem. A secret committed to history must be treated as compromised even after removal.

Secure-by-default scaffolding:

•  New services must start from a vetted template that includes authentication middleware, rate limiting, CORS locked down, CSRF protection, a content-security policy, structured logging with PII redaction, a secrets loader that refuses plaintext, and a data-access layer with row-level scoping helpers.
•  Rule of thumb: if a control is required by this document, it must be present in the scaffolding so the secure path is the default path.

Security tests (first-class tests):

•  Any feature touching authentication, authorisation, or data scoping must ship with:
◦  A positive authorisation test (allowed principal receives data).
◦  A negative authorisation test (forbidden principal is denied with the correct status code).
◦  A scope-leak test (results contain only the requesting principal's data; no cross-tenant bleed).
◦  A rate-limit or abuse test where applicable.
•  Follow TDD per `TEST_DRIVEN_DEVELOPEMNT.md`: write the negative test first.
•  These tests are part of the Definition of Done in `DEVELOPMENT_PROCESS.md`.

Dependency and supply-chain hygiene:

•  All dependencies pinned via lockfiles; CI must reject unpinned installs.
•  Automated dependency-update PRs (for example Dependabot or Renovate) with an SLA (critical within 72 hours, high within 7 days).
•  SBOM generated on every build and stored with the artefact.
•  Verify signatures on base images and release artefacts.

Incident feedback loop:

•  Every security incident or near-miss produces: a factual timeline, one or more additions or clarifications to this rule (or a linked rule), a regression test that would have caught it, and an ADR where a design decision changes.
•  Retired guidance must be removed, not left beside the replacement.

Related canonical rules:

•  `SECRETS_AND_CREDENTIALS_HANDLING.md` — authoritative rule for secrets.
•  `CI_GATES.md` — authoritative list of required CI checks and tooling per stack.
•  `PLANNING.md` — Threat model section (Pre-implementation gates).
•  `DEVELOPMENT_PROCESS.md` — Security section of the PR template and Definition of Done.
•  `TEST_DRIVEN_DEVELOPEMNT.md` — expectations for authorisation and scope-leak tests.
