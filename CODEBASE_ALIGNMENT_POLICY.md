Codebase conformity policy:
	•	If working in an existing codebase, inspect nearby files before making changes.
	•	Match the local style and conventions of the surrounding code.
	•	Follow existing patterns for naming, formatting, structure, abstractions, error handling, and tests.
	•	Prefer existing utilities, helpers, and architectural patterns over introducing new ones.
	•	Keep changes cohesive with the nearest relevant code.

Refactoring policy:
	•	Do not over-complicate refactors.
	•	Prefer the smallest clear change that solves the problem.
	•	Avoid unnecessary abstraction, indirection, generalisation, or large stylistic rewrites.
	•	Do not expand scope without a clear reason.
	•	Refactor to improve clarity and maintainability, not to showcase cleverness.

Readability standard:
	•	Write code for a mid-to-senior human reader.
	•	Prefer clarity over cleverness.
	•	Keep control flow straightforward and easy to reason about.
	•	Use descriptive names and justified abstractions.
	•	Optimise for maintainability and reviewability.

If the local codebase is inconsistent:
	•	Follow the conventions used in the closest relevant files.
	•	Prefer the most established local pattern over a global preference.
	•	Keep the solution internally consistent.
	•	State any intentional deviation and why it was necessary.

Completion standard:
	•	no change is complete unless it is consistent with the surrounding codebase
	•	any significant deviation from local conventions must be explicitly justified

Pre-PR alignment self-check (author, before opening a PR):
	•	Did you search the repo for existing functions with overlapping purpose (by keyword AND by signature)?
	•	Did you check shared packages (e.g. `packages/validation`, `lib/rules`, `common/`) before introducing a new helper?
	•	If you added a new helper, can it live beside an existing one instead of in a new module?
	•	Does the naming, layering, and error handling match the nearest 2–3 relevant files?
	•	Did you run the duplication scan defined in `CI_GATES.md` locally and resolve or justify every finding?
	•	Did you apply the Boy Scout rule within the phase scope defined in `DEVELOPMENT_PROCESS.md` (leave touched files cleaner; do not expand scope)?

Related canonical rules:
	•	For shared business rules, validation logic, permission checks, and any single-source-of-truth concerns, defer to `CENTRALISED_BUSINSS_LOGIC.md`.
	•	For broader codebase decay (dead code, TODOs, magic numbers, documentation currency), defer to `PERIODIC_CODEBASE_HYGEINE_REVIEW.md`.
	•	For required CI checks and duplication-detection tooling, see `CI_GATES.md`.
