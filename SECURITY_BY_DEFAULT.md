## Rule: Security by default

Security must be designed into systems from inception, not bolted on
afterward. Security gates are required at every stage of the lifecycle
(see "Security gates" below), not only before deployment. Security is
not a feature; it is a foundational requirement.

Approach

Existing Systems:

•  Step 1: understand current security mechanisms.
•  Step 2: document existing patterns and infrastructure.
•  Step 3: reuse and extend existing security controls (per `CENTRALISED_BUSINESS_LOGIC.md`).
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
◦  Secrets scanning (see Secrets management section below).
◦  Lint, format, and type checks (see CI_GATES.md for tools per stack).
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

Never commit secrets, credentials, or sensitive data. Treat any secret
that reaches version control as compromised from the moment of commit.
A secret in source control is not confidential regardless of how quickly it
is removed. History is not a hiding place: amended, force-pushed, or
rebased commits can still be recovered by anyone with prior access, by
cached clones, and by CI artefacts. Prevention and fast, disciplined
response are the only durable controls.

Prohibited in commits:
- API keys, passwords, private keys, certificates
- Access tokens, refresh tokens, session tokens
- Database credentials
- Signing keys, webhook secrets, OAuth client secrets
- Personally identifiable information (PII) that should not live in a source repository

Required practices:
- Use environment variables or a secrets manager; never plaintext in source.
- Every project must declare its canonical secrets backend in its README
  (for example HashiCorp Vault, AWS Secrets Manager, Google Secret Manager,
  Doppler, 1Password). Plaintext secrets in config files are prohibited.
- Maintain an `.env.example` that lists every environment variable the app
  reads, without real values.
- Add patterns for secret files to `.gitignore`.
- Use a secrets loader that refuses to start the application if a required
  secret is missing or appears to be a placeholder.

Detection tooling:
Detection must run in two places: on the developer's machine and in CI.
Specific tools per stack are listed in `CI_GATES.md`.
- Pre-commit: a secrets scanner runs on staged content before the commit is recorded.
- CI: a secrets scanner runs on the PR diff and on full history for new branches.
- Positive detection is blocking. Allowlists are permitted only with documented rotation, owner, and expiry.

Rotation policy:
- Every long-lived credential must have a documented maximum age and an owner.
- API keys, service-account keys, and long-lived tokens must be rotated before expiry and on role changes.
- Short-lived tokens (workload identity, OIDC-issued credentials) are strongly preferred over long-lived ones.
  Long-lived credentials require documented justification and a compensating control.

Incident playbook (secret leaked into version control):
1. **Rotate** the secret immediately with the issuer (new key, new password, new signing material).
2. **Revoke** the leaked value at the source (provider dashboard, IAM, KMS).
3. **Audit** access logs for the leaked value during the exposure window.
4. **Patch** the leak path: where did the secret come from, how did it reach source control, and add a preventive control.
5. **Post-mortem**. Record the fix as an ADR, or update this rule if the root cause was ambiguous or previously uncovered.

Pre-commit checks:
- Scan for hard-coded credentials using the tool configured in `CI_GATES.md`.
- Verify no sensitive patterns (high-entropy strings, known key prefixes, private-key headers) are present in the diff.
- Confirm `.env.example` is in sync with actual usage: no missing entries, no entries that no code path references.

Secure-by-default scaffolding:

•  New services must start from a vetted template that includes authentication middleware, rate limiting, CORS locked down, CSRF protection, a content-security policy, structured logging with PII redaction, a secrets loader that refuses plaintext, and a data-access layer with row-level scoping helpers.
•  Rule of thumb: if a control is required by this document, it must be present in the scaffolding so the secure path is the default path.

Security tests (first-class tests):

•  Any feature touching authentication, authorisation, or data scoping must ship with:
◦  A positive authorisation test (allowed principal receives data).
◦  A negative authorisation test (forbidden principal is denied with the correct status code).
◦  A scope-leak test (results contain only the requesting principal's data; no cross-tenant bleed).
◦  A rate-limit or abuse test where applicable.
•  Follow TDD per `TEST_DRIVEN_DEVELOPMENT.md`: write the negative test first.
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

- `CI_GATES.md` — authoritative list of required CI checks and tooling per stack.
- `PLANNING.md` — Threat model section (Pre-implementation gates).
- `DEVELOPMENT_PROCESS.md` — Security section of the PR template and Definition of Done.
- `TEST_DRIVEN_DEVELOPMENT.md` — expectations for authorisation and scope-leak tests.

### Enforcement
- Applies to: every system, every change that touches a
  security-relevant surface, every deployment.
- Consequence on breach: the required CI security gates (`CI_GATES.md`)
  block the PR from merging; a reviewer must block a PR that touches a
  security-relevant surface without an updated threat model; any control
  gap identified by a security review blocks deployment until closed.
