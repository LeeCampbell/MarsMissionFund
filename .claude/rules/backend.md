# Backend Rules

> Applied to all files in `packages/backend/src/*/domain/**`, `packages/backend/src/*/ports/**`, `packages/backend/src/*/adapters/**`, `packages/backend/src/*/application/**`, `packages/backend/src/*/api/**`

## Hexagonal Architecture

- Domain layer: ZERO infrastructure imports — no `pg`, no `express`, no `fetch`, no `fs`, no `process.env`
- Ports: interfaces only — no implementations
- Adapters: implement port interfaces — the only place that touches infrastructure
- Application services: orchestrate via injected ports — never import concrete adapters
- Controllers: HTTP concerns only — delegate to application services

## Domain Layer

- Entities: private constructor, `create()` (validates), `reconstitute()` (no validation)
- All entity properties `readonly` — immutable after creation
- Value objects: immutable, return new instances from operations
- Domain errors: extend `DomainError` with unique `code` — no generic `Error`
- Domain services: injected dependencies are port interfaces only

## Monetary Values

- Single currency: USD — all amounts stored as integer minor units (cents)
- ALL monetary values in domain code: `number` (integer cents) — NEVER floating point dollars
- Amounts: stored as `BIGINT` in database — integer cents everywhere
- JSON serialisation: monetary amounts as STRINGS — never numbers (precision loss)
- Display formatting is frontend responsibility — backend returns raw cents

## Database

- Raw SQL via `pg` only — no ORM, no query builder
- Parameterised queries always ($1, $2) — NEVER string interpolation
- Every query scoped to the authenticated `user_id` from auth context — data isolation is non-negotiable
- Repositories are dumb data access — no business logic
- Migrations: dbmate format in `db/migrations/YYYYMMDDHHMMSS_description.sql`, with `-- migrate:up` and `-- migrate:down` sections, append-only

## API

- All endpoints require Clerk JWT auth (except /health)
- `user_id` from auth context — never from request body
- Zod validation on every request body
- Consistent error format: `{ error: { code, message } }`
- HTTP status codes: 200, 201, 400, 401, 403, 404, 409, 500

## External Service Adapters

- Stripe: behind payment gateway adapter interface — no direct SDK usage in application/domain code
- Clerk: JWT verification middleware — auth context injected into request
- Veriff: behind KYC adapter interface — stubbed/mocked for local demo
- AWS SES: behind email adapter interface — stubbed/mocked for local demo
- PostHog: server-side feature flags and event capture via posthog-node

## Logging

- Pino for structured JSON logging — no `console.log`
- pino-http for HTTP request logging middleware
- pino-pretty for development only
- Sensitive data (card numbers, bank details, tokens) NEVER logged

## Testing

- Domain: ≥90% unit test coverage — entities, VOs, domain services
- Application services: integration tests with mock adapters
- API endpoints: integration tests for happy + error paths
- Realistic test data — no round numbers for monetary values
