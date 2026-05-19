# @shoperzz/testing

> Specialized testing utilities and mocks for Shoperzz development.

`@shoperzz/testing` provides a comprehensive suite of tools to perform unit, integration, and E2E testing on Shoperzz plugins and core components without requiring a full production environment.

## Features

- **Mock Providers**: Virtual implementations of payment gateways and SMS services.
- **Test Harnesses**: Isolated environments for plugin execution.
- **Snapshot Utilities**: Compare complex e-commerce state transitions.
- **Dummies**: Pre-configured data sets for orders, customers, and products.

## Installation

```bash
pnpm add -D @shoperzz/testing
```

## Usage

```typescript
import { MockEngine } from "@shoperzz/testing";

const testEngine = new MockEngine();
// Execute tests
```

## License

GPL-3.0-or-later © Shoperzz
