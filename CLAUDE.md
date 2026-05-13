# CLAUDE.md — Context for AI Coding Agents

> This file is the single source of truth for any AI coding agent (Claude, Copilot, Cursor, etc.) working on the Shoperzz codebase.
> Read this entirely before writing a single line of code.
> This is not optional documentation — it defines the rules of the system.

---

## What is Shoperzz

Shoperzz is a **headless commerce engine** built on **NestJS** and **[Vendure](https://github.com/vendurehq/vendure)**. It is designed for African markets and operates on a strict **plugin-first architecture**.

- Everything beyond the core is a **plugin**
- Plugins communicate **only via a typed event bus** — never via direct imports
- The core (`@shoperzz/core`) wraps Vendure and adds the plugin orchestration layer
- Developers install plugins, configure them in `shoperzz.config.ts`, and never touch the core

---

## Monorepo Structure

```
shoperzz/
├── apps/               
│   ├── api/            ← A NestJS API of web platform
│   ├── web/            ← A frontend marketing website code source
│   └── docs/           ← Documentation application of Shoperzz
├── packages/
│   ├── core/           ← @shoperzz/core — the orchestrator
│   ├── cli/            ← @shoperzz/cli — the `npx shoperzz` command
│   ├── common/         ← @shoperzz/common — shared types, interfaces, constants
│   └── testing/        ← @shoperzz/testing — helpers for plugin tests
├── plugins/            ← official plugins (each is an npm package)
├── demos/              ← Example/template applications built with Shoperzz
├── e2e/                ← cross-package end-to-end tests only
├── tooling/            ← shared tsconfig, jest config, eslint config
└── docs/               ← markdown documentation
```

**Package manager:** pnpm (workspaces)
**Build orchestration:** Turborepo
**Language:** TypeScript strict mode everywhere

---

## Core Concepts — Understand These Before Touching Anything

### 1. The Plugin System

Every feature is a plugin. A plugin is a self-contained NestJS module that:
- Implements the `ShoperzzPlugin` interface
- Declares its entities, migrations, GraphQL extensions, emitted events, and listened events
- Has a `shoperzz.plugin.yml` manifest that the core reads at startup
- Communicates with the rest of the system only via `ShoperzzEventBus`

```typescript
// Minimal plugin structure
export class WavePlugin implements ShoperzzPlugin {
  static entities   = [WaveSession]
  static migrations = [CreateWaveSessionsTable]

  static init(options: WaveConfig): typeof WavePlugin {
    this.options = options
    return this
  }

  static getNestModule()           { return WaveModule }
  static getShopApiExtensions()    { return { schema: waveShopSchema, resolvers: [WaveResolver] } }
}
```

### 2. The Event Bus

**CRITICAL RULE: Plugins NEVER import each other directly.**

All inter-plugin communication goes through `ShoperzzEventBus`.

```typescript
// ✓ Correct — emit an event
this.eventBus.emit('payment.wave.confirmed', { orderId, amount, currency })

// ✓ Correct — listen to an event
this.eventBus.on('payment.wave.confirmed', this.onPaymentConfirmed.bind(this))

// ✗ WRONG — never do this
import { OrangeMoneyService } from '@shoperzz/plugin-payment-orange-money'
```

Event naming convention: `domain.entity.action` (e.g., `payment.orange-money.confirmed`)

### 3. Database Rules

- **Every entity extends `ShoperzzBaseEntity`** (provides `id`, `createdAt`, `updatedAt`, `deletedAt`)
- **Soft delete is mandatory** — never `DELETE FROM` or `remove()`, always use soft delete
- **No physical foreign keys between plugins** — store IDs, resolve via services
- **Table names are prefixed** — `omoney_transactions`, `wave_sessions`, `whatsapp_messages`
- **`synchronize: false` always in production** — only use migrations
- **Status columns are `varchar`** — never PostgreSQL enums (impossible to modify without destructive migration)
- Sensitive data (phone numbers) must be masked — never stored in full in logs

### 4. Vendure Integration

Shoperzz builds on Vendure. When writing payment plugins, implement Vendure's `PaymentMethodHandler`:

```typescript
export const wavePaymentHandler = new PaymentMethodHandler({
  code: 'wave',
  createPayment: async (ctx, order, amount, args, metadata) => { ... },
  settlePayment:  async (ctx, order, payment, args) => { ... },
})
```

Available Vendure services (injectable in any plugin):
- `OrderService` — order lifecycle
- `CustomerService` — customer data
- `ProductVariantService` — inventory
- `RequestContextService` — channel and auth context

**Do not reinvent these.** Use them.

### 5. GraphQL Extensions

Plugins extend the schema via SDL:

```typescript
static getShopApiExtensions() {
  return {
    schema: gql`
      type WaveSession { id: ID!, status: String!, paymentUrl: String! }
      extend type Mutation {
        initiateWavePayment(orderId: ID!): WaveSession!
      }
    `,
    resolvers: [WaveResolver],
  }
}
```

**All custom GraphQL types must be prefixed with the plugin name** — `WaveSession`, `OrangeMoneyTransaction`, `WhatsappMessage` — never generic names like `Session`, `Transaction`.

---

## File Naming Conventions

```
[plugin-name].plugin.ts       ← main plugin class
[plugin-name].module.ts       ← NestJS module
[plugin-name].service.ts      ← business logic
[plugin-name].handler.ts      ← event/webhook handlers
[plugin-name].resolver.ts     ← GraphQL resolvers
[plugin-name].events.ts       ← event type definitions
[plugin-name].config.ts       ← typed config interface
[plugin-name].entity.ts       ← TypeORM entity
[plugin-name].dto.ts          ← GraphQL input types

# Tests
[plugin-name].service.spec.ts         ← unit test
[plugin-name].integration.spec.ts     ← integration test (with SQLite in-memory)
[plugin-name].e2e.ts                  ← e2e test (in e2e/ folder only)
```

---

## Naming Conventions

| What          | Convention                       | Example                                    |
|---------------|----------------------------------|--------------------------------------------|
| Classes       | PascalCase + suffix              | `WavePlugin`, `WaveService`, `WaveSession` |
| Files         | kebab-case.role.ts               | `wave.service.ts`                          |
| Functions     | camelCase, clear verb            | `initiateWavePayment()`                    |
| Constants     | SCREAMING_SNAKE_CASE             | `WAVE_TIMEOUT_MINUTES`                     |
| DB tables     | `prefix_plural`                  | `wave_sessions`                            |
| Events        | `domain.entity.action`           | `payment.wave.confirmed`                   |
| Env vars      | `SHOPERZZ_PLUGIN_VAR`            | `SHOPERZZ_WAVE_API_KEY`                    |
| GraphQL types | PascalCase, plugin-prefixed      | `WavePaymentSession`                       |
| npm packages  | `@shoperzz/plugin-[type]-[name]` | `@shoperzz/plugin-payment-wave`            |
| Git branches  | `type/description`               | `feat/plugin-payment-wave`                 |

---

## Key Files to Know

| File                                 | Purpose                                           |
|--------------------------------------|---------------------------------------------------|
| `apps/api/src/shoperzz.config.ts`    | The master config — active plugins, their options |
| `apps/api/src/app.module.ts`         | One line: `ShoperzzCoreModule.forRoot(config)`    |
| `packages/core/src/plugin-registry/` | How plugins are loaded — read before modifying    |
| `packages/core/src/event-bus/`       | The event system — central nervous system         |
| `tooling/tsconfig.base.json`         | TypeScript config — all packages extend this      |
| `tooling/jest.base.config.ts`        | Jest config — coverage thresholds are here        |
| `pnpm-workspace.yaml`                | Workspace packages declaration                    |
| `turbo.json`                         | Build pipeline                                    |

---

## Commands

```bash
pnpm setup                              # first-time setup after clone
pnpm dev                                # start full monorepo in dev mode
pnpm build                             # build all packages
pnpm test:all                          # run all tests
pnpm --filter @shoperzz/[pkg] test     # test a specific package
pnpm --filter @shoperzz/[pkg] build    # build a specific package
pnpm lint                              # lint all
pnpm typecheck                         # TypeScript check all
pnpm doctor                            # diagnose environment issues
pnpm sync                              # sync with upstream
pnpm push                              # push with pre-flight checks
pnpm changeset                         # declare a version change
pnpm migrate                           # run pending DB migrations
pnpm plugin:create [name]              # scaffold a new plugin
```

---

## Testing Rules

- **Unit tests** → `__tests__/unit/` inside each package — mock all external deps
- **Integration tests** → `__tests__/integration/` — use `createTestApp()` from `@shoperzz/testing` with SQLite in-memory
- **E2E tests** → `e2e/` at repo root — cross-package only
- **Coverage thresholds (non-negotiable):**
  - Global: 80% minimum
  - Webhook handlers: **100%**
  - Payment services: **100%**
- Test files use real anonymized fixtures from `__tests__/fixtures/` — never hardcoded payloads in test files
- Always test idempotency for webhook handlers — processing the same webhook twice must be safe

---

## What the AI Must NEVER Do

- ❌ Import a service from one plugin into another plugin directly
- ❌ Use `synchronize: true` in TypeORM DataSource outside local dev
- ❌ Use `DELETE FROM` or `remove()` — always soft delete
- ❌ Create physical foreign keys between plugin tables
- ❌ Store API keys, secrets, or phone numbers in plain text in logs
- ❌ Modify `@vendure/core` source — extend via interfaces only
- ❌ Name GraphQL types generically (`Transaction`, `Session`) — always prefix with plugin name
- ❌ Skip the `shoperzz.plugin.yml` manifest when creating a plugin
- ❌ Use PostgreSQL native enums for status columns
- ❌ Write migrations manually — use TypeORM CLI to generate them from entity changes
- ❌ Touch `packages/core/` internals unless explicitly asked to work on the core

---

## When Adding a New Plugin

1. Run `pnpm plugin:create [name]` — don't scaffold manually
2. Fill in `shoperzz.plugin.yml` — permissions, emits, listens
3. Implement the `ShoperzzPlugin` interface
4. Extend `ShoperzzBaseEntity` on all entities
5. Prefix all table names
6. Type all events in `[name].events.ts`
7. Write unit tests for the service
8. Write integration tests with `createTestApp()`
9. Webhook handlers must reach 100% coverage
10. Run `pnpm changeset` before the first PR

---

## When Modifying an Existing Plugin

1. Read the plugin's `shoperzz.plugin.yml` to understand its declared contract
2. If adding a new entity column → generate a migration, never modify the entity without one
3. If changing an event payload → update the type in `.events.ts` AND check all handlers that listen to it
4. If adding a new GraphQL type → prefix it with the plugin name
5. Run the plugin's tests: `pnpm --filter @shoperzz/plugin-[name] test`
6. Run `pnpm changeset` and declare `patch` or `minor` depending on the change

---

## Environment Variables

All Shoperzz env vars follow the pattern `SHOPERZZ_[PLUGIN]_[VAR]`.
Never use bare env var names like `API_KEY` or `SECRET`.

Example:
```bash
SHOPERZZ_ORANGE_MONEY_API_KEY=...
SHOPERZZ_ORANGE_MONEY_API_SECRET=...
SHOPERZZ_WAVE_API_KEY=...
SHOPERZZ_WHATSAPP_ACCESS_TOKEN=...
```

A `.env.example` at the root lists all required variables with placeholder values.

---

## Current Status

See [roadmap.md](docs/roadmap.md) for the current development phase and priorities.
