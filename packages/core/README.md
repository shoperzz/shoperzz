<div align="center">
  <img src="../../assets/logos/LOGO-COLORED-SVG.svg" alt="Shoperzz" width="300" />
  <br/>
  <p>
    <strong>@shoperzz/core</strong><br/>
    The backbone of the Shoperzz headless e-commerce engine.
  </p>

  <div>
    <img src="https://img.shields.io/badge/NestJS-E0234E?style=flat-square&logo=nestjs&logoColor=white" alt="NestJS">
    <img src="https://img.shields.io/badge/TypeScript-007ACC?style=flat-square&logo=typescript&logoColor=white" alt="TypeScript">
    <img src="https://img.shields.io/badge/pnpm-F69220?style=flat-square&logo=pnpm&logoColor=white" alt="pnpm">
    <img src="https://img.shields.io/npm/v/@shoperzz/core?style=flat-square&logo=npm&color=CB3837" alt="npm version">
  </div>
</div>

<br/>

## Narrative Synthesis

@shoperzz/core is the central nervous system of the Shoperzz framework. It orchestrates the business logic, service orchestration, and the high-performance bridging between NestJS and Vendure. Designed for the specificities of the African digital economy, it provides a "White-Box" architecture that is both robust and infinitely extensible.

## Key Technical Capabilities

- **Service Orchestration**: Atomic management of complex e-commerce workflows (Orders, Payments, Logistics).
- **Plugin Architecture**: Seamless integration with the Shoperzz plugin ecosystem.
- **Security First**: Built-in protection against common vulnerabilities and transactional fraud.
- **African API Adapters**: Native handling of localization, currencies, and specialized regional services.

## Installation

```bash
pnpm add @shoperzz/core
```

## Quick Start

```typescript
import { ShoperzzCore } from "@shoperzz/core";

const engine = new ShoperzzCore({
  // Professional configuration
});

engine.bootstrap().then(() => {
  console.log("Shoperzz Engine is running.");
});
```

## Governance

This package follows the Elite Release Protocol. Versions and tags are managed automatically by the Shoperzz Release Bot.

---

[License: GPL-3.0-or-later](../../LICENSE.md) © Shoperzz
