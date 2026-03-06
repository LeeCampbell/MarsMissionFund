# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

MarsMissionFund is a sample application for coding workshops — a fake product for crowdfunding projects that help get us to Mars.

## Specifications

The [specs/README.md](./specs/README.md) document acts as index for the Product Mission and the standards for the project.
Before implementing any feature, consult the specifications in [specs/README.md](./specs/README.md).

## Development Environment

The local dev environment requires PostgreSQL running and accessible. All other external services (Stripe, Clerk, Veriff, AWS SES) are mocked — see `.env.example` for configuration.

### Prerequisites

- Node.js 22.x LTS and npm
- PostgreSQL 16 (via Docker Compose: `docker compose up -d`)
- dbmate for migrations (`npm run migrate` or `dbmate up`)

### Already provided — do not recreate

- **PostgreSQL** is provisioned via Docker Compose (see `docker-compose.yml` at project root). Do not create additional database infrastructure.
- **Dev stack** starts with `npm run dev` (backend at `localhost:3000`, frontend at `localhost:5173`). Restart with `make dev-stack` if needed.
- **Database migrations** live in `db/migrations/` and are applied with dbmate. Do not create alternative migration tooling.
- **Pre-installed tooling:** dbmate, Biome (lint/format), Playwright (E2E), Vitest (unit/integration).

Do not create features or specs for "project setup", "monorepo scaffolding", "Docker Compose configuration", or "local dev environment". This infrastructure exists. Features should deliver application-level user value.

## Development Workflow

TODO: Document the development workflow, including git standards, testing, reviews etc.
