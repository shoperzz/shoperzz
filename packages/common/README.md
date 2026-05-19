# @shoperzz/common

> Shared interfaces, types, and utilities for the Shoperzz ecosystem.

This package serves as the "source of truth" for all contracts between the Shoperzz core and its plugins. It ensures strict typing and architectural consistency across the entire monorepo.

## Key Components

- **Interfaces**: Definitions for `ShoperzzPlugin`, `PaymentProvider`, `SmsProvider`, etc.
- **Universal Types**: Domain objects for orders, customers, and inventory.
- **Schemas**: Shared validation schemas for API and configuration.
- **Constants**: Framework-wide constants and error codes.

## Installation

```bash
pnpm add @shoperzz/common
```

## Usage

```typescript
import { IShopperzzPlugin, PluginConfig } from "@shoperzz/common";

export class MyPlugin implements IShopperzzPlugin {
  // Implementation
}
```

## License

Apache-2.0 © Shoperzz
