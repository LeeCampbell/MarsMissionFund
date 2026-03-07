# Glossary — Canonical Terminology

> Single source of truth for terms used across `.claude/agents/` files.

---

## Ralph Loop

An autonomous iterate-until-done loop used by every agent:

1. **Read** — load all required input files
2. **Implement** — draft or build the deliverable
3. **Validate** — run tests, linters, or cross-checks
4. **Self-check** — verify all completion criteria are met
5. **Repeat** — if any criterion fails, iterate; otherwise signal completion

---

## Document Hierarchy

The MMF pipeline produces four document types per feature, in order:

| Document | File pattern | Producer | Purpose |
|----------|-------------|----------|---------|
| Feature brief | `.claude/prds/feat-XXX-brief.md` | Product Strategist | Defines WHAT to build (scope, user stories, acceptance criteria) |
| Research document | `.claude/prds/feat-XXX-research.md` | Spec Researcher | Codebase context, edge cases, domain knowledge |
| Feature spec | `.claude/prds/feat-XXX-spec.md` | Spec Writer | Implementation-ready PRD (data model, API, domain, tests) |
| Design spec | `.claude/prds/feat-XXX-design.md` | Design Speccer | Visual design (layout, tokens, states, responsive, a11y) |

Use these names consistently. Avoid synonyms like "PRD" (too vague) or "spec" (ambiguous without qualifier).

---

## Naming Conventions

### Application Service Files

Canonical pattern: **`[use-case]-service.ts`** (e.g., `create-campaign-service.ts`)

- Class name: `[UseCase]Service` (e.g., `CreateCampaignService`)
- Lives in: `packages/backend/src/[context]/application/`

Do not use `[Context]AppService` as a class name.

### Port Files

Canonical pattern: **`[resource]-repository.ts`** or **`[service]-port.ts`**

- Prefix with the resource or external service name, not the bounded context name.
- Examples: `campaign-repository.ts`, `payment-port.ts`, `email-port.ts`

### Composition Root

Canonical file: **`packages/backend/src/composition-root.ts`**

Do not refer to this as "bootstrap" or "app.ts". The composition root wires all dependencies manually — no DI containers.

---

## Test Coverage Targets

| Scope | Target | Enforcement |
|-------|--------|-------------|
| Domain layer (entities, VOs, domain services) | >= 90% unit test coverage | CI gate |
| Overall project | >= 80% combined coverage | CI gate |
| CI enforcement threshold | >= 90% on domain code | Blocks merge |

When agents reference "test coverage", use the target for the specific scope, not a single blanket number.

---

## Tracking Files

### `.claude/mock-status.md`

Tracks which external services have mock adapters and their current state. If this file does not exist when an agent needs it, create it with this template:

```markdown
# Mock Status

| Service | Mock Exists | Location | Notes |
|---------|------------|----------|-------|
| Stripe | yes/no | `packages/backend/src/.../mock/` | — |
| Clerk | yes/no | — | — |
| Veriff | yes/no | — | — |
| AWS SES | yes/no | — | — |
```

### `.claude/manual-tasks.md`

Tracks tasks that require human intervention (API keys, external config, infrastructure). If this file does not exist when an agent needs it, create it with this template:

```markdown
# Manual Tasks

| # | Task | Feature | Status | Owner |
|---|------|---------|--------|-------|
| 1 | — | — | pending | — |
```

---

## Spec Layer Hierarchy

Specs follow a layered hierarchy defined in `specs/README.md`. When two specs conflict, the higher layer wins:

- **L1** — Product vision and mission
- **L2** — Standards (engineering, brand)
- **L3** — Technical specs (architecture, security, frontend, data, audit)
- **L4** — Domain specs (campaigns, payments, accounts, etc.)

Higher layer number = more specific but lower authority on cross-cutting concerns.
