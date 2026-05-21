<div align="center">
  <img src="../../assets/logos/LOGO-COLORED-SVG.svg" alt="Shoperzz" width="300" />
  <br/>
  <p>
    <strong>@shoperzz/common</strong><br/>
    Universal utilities and types for the Shoperzz ecosystem.
  </p>

  <div>
    <img src="https://img.shields.io/badge/TypeScript-007ACC?style=flat-square&logo=typescript&logoColor=white" alt="TypeScript">
    <img src="https://img.shields.io/badge/pnpm-F69220?style=flat-square&logo=pnpm&logoColor=white" alt="pnpm">
    <img src="https://img.shields.io/npm/v/@shoperzz/common?style=flat-square&logo=npm&color=CB3837" alt="npm version">
  </div>
</div>

<br/>

## Narrative Synthesis

@shoperzz/common provides the essential building blocks used across all Shoperzz packages and plugins. It ensures strict type safety, consistent error handling, and shared utility functions, acting as the "glue" that maintains architectural cohesion in the monorepo.

## Key Technical Capabilities

- **Shared Domain Types**: Centralized definitions for order states, payment results, and customer profiles.
- **Validation Logic**: Universal Zod-based validators for Africa-specific data formats.
- **Security Utils**: Standardized encryption, hashing, and token handling.
- **Constants & Enums**: The single source of truth for framework-wide configurations.

## Installation

```bash
pnpm add @shoperzz/common
```

## Governance

This package follows the Elite Release Protocol. Versions and tags are managed automatically by the Shoperzz Release Bot.

---

[License: GPL-3.0-or-later](../../LICENSE.md) © Shoperzz
