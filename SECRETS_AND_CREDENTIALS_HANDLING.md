## Rule: Secrets and credentials handling

Never commit secrets, credentials, or sensitive data. Treat any secret
that reaches version control as compromised from the moment of commit.
This rule is the authoritative source for handling secrets; other rules
point here.

### Why
A secret in source control is not confidential regardless of how quickly it
is removed. History is not a hiding place: amended, force-pushed, or
rebased commits can still be recovered by anyone with prior access, by
cached clones, and by CI artefacts. Prevention and fast, disciplined
response are the only durable controls.

### Prohibited in commits
- API keys
- Passwords
- Private keys and certificates
- Access tokens, refresh tokens, session tokens
- Database credentials
- Signing keys, webhook secrets, OAuth client secrets
- Personally identifiable information (PII) that should not live in a
  source repository

### Required practices
- Use environment variables or a secrets manager; never plaintext in source.
- Every project must declare its canonical secrets backend in its README
  (for example HashiCorp Vault, AWS Secrets Manager, Google Secret Manager,
  Doppler, 1Password). Plaintext secrets in config files are prohibited.
- Maintain an `.env.example` that lists every environment variable the app
  reads, without real values.
- Add patterns for secret files to `.gitignore`.
- Use a secrets loader that refuses to start the application if a required
  secret is missing or appears to be a placeholder.

### Detection tooling
Detection must run in two places: on the developer's machine and in CI.
Specific tools per stack are listed in `CI_GATES.md`.

- **Pre-commit**: a secrets scanner runs on staged content before the
  commit is recorded.
- **CI**: a secrets scanner runs on the PR diff and on full history for
  new branches.
- Any positive detection is blocking. Allowlists are permitted only with
  documented rotation, owner, and expiry.

### Rotation policy
- Every long-lived credential must have a documented maximum age and an
  owner recorded in the repository's operational documentation.
- API keys, service-account keys, and long-lived tokens must be rotated
  before expiry and on role changes.
- Short-lived tokens (workload identity, OIDC-issued credentials) are
  strongly preferred over long-lived ones. Long-lived credentials require
  documented justification and a compensating control.

### Incident playbook (secret leaked into version control)
Treat any secret present in version control as compromised, even if the
commit is later amended or force-pushed away.

1. **Rotate** the secret immediately with the issuer (new key, new
   password, new signing material).
2. **Revoke** the leaked value at the source (provider dashboard, IAM, KMS).
3. **Audit** access logs for the leaked value during the exposure window.
4. **Patch** the leak path: where did the secret come from, how did it
   reach source control, and add a preventive control so the same path
   cannot leak again.
5. **Post-mortem**. Record the fix as an ADR, or update this rule if the
   root cause was ambiguous or previously uncovered.

### Pre-commit checks
- Scan for hard-coded credentials using the tool configured in `CI_GATES.md`.
- Verify no sensitive patterns (high-entropy strings, known key prefixes,
  private-key headers) are present in the diff.
- Confirm `.env.example` is in sync with actual usage: no missing entries,
  no entries that no code path references.

### Relationship to other rules
- `SECURITY_BY_DEFAULT.md` — broader security controls; defers to this rule
  for anything secrets-related.
- `CI_GATES.md` — automated enforcement and specific scanning tools.
- `CODEBASE_ALIGNMENT_POLICY.md` — the secrets loader and env-loader
  pattern must match the local project convention.

### Enforcement
- Applies to: every repository, every commit, every developer, every
  agent.
- Consequence on breach: any positive detection blocks CI. Any secret
  that reaches version control, even transiently, triggers the incident
  playbook immediately and is treated as compromised.
