<div align="center">
  <img src="../../assets/logos/LOGO-COLORED-SVG.svg" alt="Shoperzz" width="300" />
  <br/>
  <p>
    <strong>@shoperzz/testing</strong><br/>
    Specialized testing utilities and mocks for Shoperzz development.
  </p>

  <div>
    <img src="https://img.shields.io/badge/Vitest-6E9F18?style=flat-square&logo=vitest&logoColor=white" alt="Vitest">
    <img src="https://img.shields.io/badge/TypeScript-007ACC?style=flat-square&logo=typescript&logoColor=white" alt="TypeScript">
    <img src="https://img.shields.io/badge/pnpm-F69220?style=flat-square&logo=pnpm&logoColor=white" alt="pnpm">
    <img src="https://img.shields.io/npm/v/@shoperzz/testing?style=flat-square&logo=npm&color=CB3837" alt="npm version">
  </div>
</div>

<br/>

## Narrative Synthesis

@shoperzz/testing provides a comprehensive suite of tools to perform unit, integration, and E2E testing on Shoperzz plugins and core components. It allows for high-fidelity simulation of the African e-commerce environment without requiring a production-ready infrastructure.

## Key Technical Capabilities

- **Mock Providers**: Virtual implementations of payment gateways (Orange Money, Wave, etc.) and SMS services.
- **Test Harnesses**: Isolated execution environments for plugin validation.
- **Snapshot Utilities**: Comparison of complex transactional state transitions.
- **African Data Dummies**: Ready-to-use profiles for orders, customers, and regional addresses.

## Installation

```bash
pnpm add -D @shoperzz/testing
```

## Quick Start

```typescript
import { MockEngine } from "@shoperzz/testing";

const testEngine = new MockEngine();
// Execute high-fidelity tests
```

## Governance

This package follows the Elite Release Protocol. Versions and tags are managed automatically by the Shoperzz Release Bot.

---

[License: GPL-3.0-or-later](../../LICENSE.md) © Shoperzz
