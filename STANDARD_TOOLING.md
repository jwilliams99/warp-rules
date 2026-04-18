## Rule: Standard tooling

Use the standard, community-blessed formatter, linter, and type-check
tools for each language. When generating commands, instructions, or CI
configuration, prefer these tools over bespoke alternatives.

### Why
Standard tooling reduces review noise, eliminates style debates, and
produces consistent output across repositories and contributors. Agents
should default to these tools unless a repository explicitly configures
a different choice.

### Tools by language
- **Python**: `black` (formatter), `isort` (imports), `ruff` (linter and
  import-checker; may replace `isort` where configured), `mypy` or
  `pyright` (type-check).
- **JavaScript**: `prettier` (formatter), `eslint` (linter).
- **TypeScript**: `prettier` (formatter), `eslint` (linter),
  `tsc --noEmit` (type-check).
- **Go**: `gofmt` (or `goimports`), `go vet`, `staticcheck`.
- **Rust**: `rustfmt`, `clippy`.
- **Terraform**: `terraform fmt`, `tflint`.
- **Shell**: `shellcheck`, `shfmt`.
- **Markdown**: `markdownlint` where configured.

### Generic fallback
If the repository defines a project-standard formatter or linter that does
not match this list, follow the repository's choice. Record any deliberate
deviation in the repository's README so the choice is discoverable by
future contributors.

### Relationship to other rules
- `CI_GATES.md` — automates enforcement of these tools as required checks.
- `CODEBASE_ALIGNMENT_POLICY.md` — defers to the repository's configured
  tooling where it differs from the defaults listed here.

### Enforcement
- Applies to: every repository with active development and every
  generated instruction or command that touches formatting, linting, or
  type-checking.
- Consequence on breach: the CI lint, format, and type-check gates
  defined in `CI_GATES.md` fail; a reviewer must block a PR that ships
  with the required tooling absent or disabled.
