## Rule: Always Use Migrations for Database Work (Project Kickoff)

When kicking off a project that touches a database, you MUST use an ORM and a migration tool from day one.

### Applies to
Any work that involves:
- Database calls (reads/writes)
- DML (INSERT/UPDATE/DELETE)
- DDL (CREATE/ALTER/DROP)
- Index changes, constraints, triggers
- Seed/reference data that must evolve over time

### Requirements
1. **ORM required**
   - All app database access must go through an ORM (or a clearly defined data access layer).
   - No ad-hoc SQL embedded in application code unless explicitly justified.

2. **Migrations required**
   - All schema changes MUST be represented as migrations.
   - Do not manually modify schemas in shared or long-lived environments.
   - Migrations must be:
     - **Idempotent where possible**
     - **Reversible** (down migration) unless explicitly documented why not
     - **Ordered** and tracked in version control

3. **Local dev must run migrations**
   - First-run bootstrap must include: create DB → run migrations → (optional) seed data.
   - CI must run migrations on a clean DB as part of tests.

4. **No direct DDL/DML in production**
   - Production changes happen via the migration pipeline only.
   - Emergency hotfix SQL is allowed only with explicit approval and must be backfilled into a migration immediately after.

5. **Seed data**
   - Any data required for the app to function (roles, enums, defaults) must be managed via:
     - migrations (preferred), or
     - a versioned seeding mechanism that is safe to rerun.

### Definition of Done (supplements the global DoD in `DEVELOPMENT_PROCESS.md`)
This list is in addition to the global Definition of Done; it does not
replace it. Migration changes must satisfy every applicable global DoD
item as well as the items below.

- Migration created and committed
- Migration runs cleanly on an empty DB
- Migration runs cleanly on an existing DB
- Rollback path exists or is explicitly documented
- App code updated to match the new schema
- CI includes migration step

### Default tooling (choose one per stack)
- Python: SQLAlchemy + Alembic
- Node: Prisma Migrate / Knex migrations / TypeORM migrations / Sequelize
- Rails: ActiveRecord migrations
- Go: SQLC + Goose / Atlas

### Enforcement
- Applies to: every repository that reads from or writes to a database.
- Consequence on breach: the CI migration gate (`CI_GATES.md`) fails; a
  reviewer must block any schema change that is not expressed as a
  migration, any migration that does not run cleanly on empty and
  existing databases, and any direct production DDL/DML that has not
  been backfilled into a migration.

