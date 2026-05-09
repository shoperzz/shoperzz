# Packages — Shoperzz Engine

This directory groups the fundamental framework building blocks published on the npm registry under the `@shoperzz` scope.

## Packages
- **core/**: The central orchestrator (NestJS). Manages plugin lifecycle, registry, and the Vendure engine.
- **common/**: TypeScript types, constants, and utilities shared between core, plugins, and the CLI.
- **testing/**: Testing helpers for plugin developers (mocks, bootstrappers).

## Role
This is the product's heart. These packages are designed to be imported by plugins and storefronts.
