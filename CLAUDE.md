# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

MarsMissionFund is a sample application for coding workshops — a fake product for crowdfunding projects that help get us to Mars.

## Specifications

The [specs/README.md](./specs/README.md) document acts as index for the Product Mission and the standards for the project.
Before implementing any feature, consult the specifications in [specs/README.md](./specs/README.md).

## Monorepo Structure

- npm workspaces: `packages/backend`, `packages/frontend`
- Dependencies are hoisted to root `node_modules/` — don't look for them in package subdirectories
- Run workspace commands from root: `npm run test --workspace=packages/backend`
- Run all tests: `npm test` (runs across all workspaces)

## Development Workflow

TODO: Document the development workflow, including git standards, testing, reviews etc.
