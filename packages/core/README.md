# @shoperzz/core

> The central nervous system of the Shoperzz headless e-commerce framework.

`@shoperzz/core` provides the foundational architecture for building highly scalable, plugin-based e-commerce systems. It orchestrates the lifecycle of the framework, manages the plugin registry, and provides the main event-driven engine.

## Features

- **Plugin Engine**: Dynamic loading and lifecycle management for Shoperzz extensions.
- **Event Bus**: High-performance, typed communication layer for inter-module integration.
- **Provider System**: Abstraction layer for data and service providers.
- **Middleware Support**: Intercept and modify framework behavior at key injection points.

## Installation

```bash
pnpm add @shoperzz/core
```

## Usage

```typescript
import { ShoperzzCore } from "@shoperzz/core";

const engine = new ShoperzzCore({
  // configuration
});

engine.bootstrap().then(() => {
  console.log("Shoperzz Engine is running.");
});
```

## License

Apache-2.0 © Shoperzz
