# Merge Report: feat-003 — Authentication with Clerk

> Merged to main on 2026-03-05.

## Test Results

| Suite | Tests | Status |
|-------|-------|--------|
| Backend (domain + integration) | 49 | PASS |
| Frontend (components + lib) | 48 | PASS |
| **Total** | **97** | **PASS** |

## Coverage

Authentication feature — domain entity tests (22), middleware integration tests (8), route integration tests (16), health tests (3). Frontend component tests cover all auth states (loading, signed-in, signed-out). Coverage thresholds not yet enforced in CI (tracked for future iteration).

## Security Audit

- 0 critical / 0 high findings (HIGH-001 env var mismatch fixed in quality loop)
- 6 medium findings (non-blocking): CORS middleware, helmet headers, rate limiting, cache-control, production guard for MOCK_AUTH, fragile error name check
- 5 low/informational findings
- `npm audit` reports 0 vulnerabilities

## Quality Gate Results

| Gate | Verdict |
|------|---------|
| Exploratory (Playwright) | WAIVED (auth requires running Clerk instance) |
| Security Review | PASS (0 critical/high after fix) |
| Auditor | PASS (all 4 failures resolved) |
| CI/CD DevOps | PASS (0 ESLint errors, build green) |

## Quality Loop Iterations

- Iteration 1: HIGH-001 (env var mismatch), F-001 (dashboard redirect), 35 ESLint errors, Prettier formatting
- Iteration 2: All resolved — PASS across all quality agents

## Changelog

### feat-003: Authentication with Clerk
- Added Account entity with create()/reconstitute() pattern and domain errors
- Added hexagonal auth architecture: AuthPort, WebhookVerificationPort, AccountRepository interfaces
- Added ClerkAuthAdapter (@clerk/express JWT middleware) and MockAuthAdapter
- Added SvixWebhookAdapter and MockWebhookAdapter for webhook signature verification
- Added PostgresAccountRepository and InMemoryAccountRepository
- Added AccountAppService with JIT account creation and webhook event handling
- Added requireAuthentication and enrichAuthContext middleware
- Added POST /api/webhooks/clerk endpoint with Svix verification
- Added GET /api/v1/auth/me endpoint
- Added composition root with manual DI (MOCK_AUTH=true switches adapters)
- Added ClerkProvider integration with MMF-themed appearance
- Added SignIn/SignUp pages with AuthCentreLayout
- Added ProtectedRoute/PublicOnlyRoute wrappers with loading states
- Added HeaderAuthSection in PageShell header
- Added centralised API client with Bearer token injection
- Added Dashboard page with onboarding redirect check
- Added Onboarding placeholder page
- Added Clerk env vars to .env.example and docker-compose.yml

## Manual Tasks Created

- Clerk application must be provisioned and real API keys configured to use non-mock auth
- Font files in public/fonts/ remain as empty placeholders (carried from feat-001)
