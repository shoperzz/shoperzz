# Contribution Guide — Shoperzz

Welcome. You want to contribute to Shoperzz — the open-source commerce engine built for African markets. This is exactly what this project needs.

This guide covers everything: how to set up your environment, how to submit a PR, how to create a plugin, and how the community works.

---

## Table of Contents

1. [Before You Start](#1-before-you-start)
2. [Setting Up the Environment](#2-setting-up-the-environment)
3. [Understanding the Structure](#3-understanding-the-structure)
4. [Types of Contributions](#4-types-of-contributions)
5. [Git Workflow](#5-git-workflow)
6. [Commit Convention](#6-commit-convention)
7. [Code Standards](#7-code-standards)
8. [Tests](#8-tests)
9. [Creating a Plugin](#9-creating-a-plugin)
10. [Opening a Pull Request](#10-opening-a-pull-request)
11. [Review Process](#11-review-process)
12. [Versions and Releases](#12-versions-and-releases)

---

## 1. Before You Start

### Search Before Creating

Before opening an issue or starting to code:

- **Existing Issues** — someone might already be working on it
- **Ongoing PRs** — the feature might already exist in review
- **Documentation** — https://docs.shoperzz.dev
- **Discord** — https://discord.gg/shoperzz — ask the community

### What is Welcome

Anything that improves Shoperzz for African markets is welcome. In particular:

- New payment plugins (Flutterwave, M-Pesa, Airtel Money, etc.)
- Integrations specific to local markets
- Bug fixes
- Performance improvements
- Documentation in French or local languages
- Typo corrections — yes, they count

---

## 2. Setting Up the Environment

### Prerequisites

```
Node.js  >= 20 LTS
pnpm     >= 8
Git      >= 2.38
```

### Installation

```bash
# 1. Fork the repo on GitHub (the "Fork" button at the top right)

# 2. Clone your fork
git clone https://github.com/[your-username]/shoperzz.git
cd shoperzz

# 3. Run the setup script — it does everything automatically
pnpm setup
```

The `setup` script installs dependencies, configures Husky (git hooks), activates the commit template, and checks that everything is in order.

### Add the Upstream Remote

```bash
git remote add upstream https://github.com/shoperzz/shoperzz.git

# Verify
git remote -v
# origin    https://github.com/[your-username]/shoperzz.git
# upstream  https://github.com/shoperzz/shoperzz.git
```

### Verify Everything Works

```bash
pnpm doctor
```

If everything is green, you're ready. If something is red, the script tells you exactly what to fix.

---

## 3. Understanding the Structure

```
shoperzz/
├── apps/          ← deployable applications (api, dashboard)
├── packages/      ← libraries published to npm
│   ├── core/      ← @shoperzz/core — the engine
│   ├── common/    ← @shoperzz/common — shared types
│   ├── cli/       ← @shoperzz/cli — the `npx shoperzz` command
│   └── testing/   ← @shoperzz/testing — test helpers
├── plugins/       ← official plugins
├── demos/         ← demonstration projects
├── e2e/           ← end-to-end cross-package tests
├── tooling/       ← shared configurations and scripts
└── docs/          ← source documentation
```

Each package in `packages/` and `plugins/` is published independently to npm. They are versioned separately via Changesets.

---

## 4. Types of Contributions

### Bug Fix

1. Open an issue with the **Bug Report** template if it doesn't exist
2. Comment on the issue to indicate you're working on it
3. Create your branch from `develop`: `fix/short-description`
4. Fix + add a test that reproduces the bug
5. Open a PR

### New Feature

1. First, open a **Feature Request** issue for discussion
2. Wait for a maintainer's approval before coding (avoids unmerged work)
3. Create your branch from `develop`: `feat/short-description`
4. Implement + tests
5. Open a PR

### New Plugin

See the [Creating a Plugin](#9-creating-a-plugin) section.

### Documentation

Branch: `docs/short-description`
No need for prior validation for doc corrections.

---

## 5. Git Workflow

### Staying Up-to-Date Before Starting

```bash
git fetch upstream
git checkout develop
git rebase upstream/develop
```

### Creating Your Working Branch

```bash
# Always from develop — never from main
git checkout -b feat/payment-mtn-momo
```

**Branch Naming Convention:**
```
feat/[description]      ← new feature
fix/[description]       ← bug fix
docs/[description]      ← documentation
refactor/[description]  ← refactoring
chore/[description]     ← maintenance
```

### Staying Synchronized During Development

```bash
git fetch upstream
git rebase upstream/develop

# If conflicts → resolve, then
git rebase --continue

# Force push required after a rebase
git push origin feat/payment-mtn-momo --force-with-lease
```

### Using the Sync Script

```bash
# Simpler — the script handles everything
pnpm sync
```

---

## 6. Commit Convention

Shoperzz uses **Conventional Commits**. The format is automatically validated by Husky at commit time.

### Format

```
type(scope): short description in lowercase
```

### Available Types

| Type       | When                               | Version Effect |
|------------|------------------------------------|----------------|
| `feat`     | New feature                        | bump MINOR     |
| `fix`      | Bug fix                            | bump PATCH     |
| `perf`     | Performance improvement            | bump PATCH     |
| `security` | Security fix                       | bump PATCH     |
| `refactor` | Refactoring without visible change | no bump        |
| `test`     | Tests only                         | no bump        |
| `docs`     | Documentation only                 | no bump        |
| `chore`    | Maintenance, deps                  | no bump        |
| `ci`       | CI/CD                              | no bump        |

### Available Scopes

```
core · common · cli · payment · whatsapp · webhook
graphql · database · testing · docs · deps · config
plugin-orange-money · plugin-wave · plugin-mtn-momo
```

### Correct Examples

```bash
feat(payment): add MTN MoMo payment handler with sandbox support
fix(webhook): handle Orange Money duplicate webhook idempotently
security(webhook): add timing-safe hmac signature comparison
docs(contributing): add plugin submission checklist
chore(deps): update vendure to 2.3.0
test(plugin-wave): add webhook expiry edge case tests
```

### Breaking Change

```bash
feat(core)!: rename ShoperzzPlugin.getNestModule to getModule

BREAKING CHANGE: ShoperzzPlugin.getNestModule() is renamed to getModule()
to align with NestJS convention. Update all existing plugins.
```

### Commit Template

When you type `git commit` without `-m`, a template opens in your editor with all types, scopes, and examples. It was configured by `pnpm setup`.

### What Happens if the Format is Incorrect?

```bash
$ git commit -m "add wave payment"
✖  type may not be empty
✖  subject may not be empty

husky - commit-msg hook exited with code 1
```

The commit is rejected locally. You see exactly which rule is violated.

---

## 7. Code Standards

### Strict TypeScript

All code is in strict TypeScript. No explicit `any`. No `// @ts-ignore` without commented justification.

### Naming — Essential Rules

```typescript
// Classes → PascalCase + role suffix
class OrangeMoneyPlugin {}
class OrangeMoneyService {}
class OrangeMoneyTransaction {}      // entity

// Files → kebab-case.role.ts
// orange-money.plugin.ts
// orange-money.service.ts
// orange-money.entity.ts

// Constants → SCREAMING_SNAKE_CASE
const ORANGE_MONEY_TIMEOUT_MINUTES = 5

// Events → domain.entity.action
'payment.orange-money.confirmed'

// DB Tables → prefix_name_plural
// omoney_transactions
// whatsapp_messages

// Env Variables → SHOPERZZ_PLUGIN_VAR
// SHOPERZZ_ORANGE_MONEY_API_KEY
```

### What We Never Do

- Directly import another plugin's service — use the event bus
- `synchronize: true` in TypeORM outside of local dev
- Physically delete data — always soft delete
- Store API keys or tokens in code
- Log phone numbers, emails, or personal data in plain text

### Lint and Format

```bash
pnpm lint          # ESLint
pnpm format        # Prettier
pnpm typecheck     # TypeScript
```

These three commands automatically run on the files you modify via `lint-staged` at commit time.

---

## 8. Tests

### Where Tests Live

```
plugin-payment-orange-money/
└── __tests__/
    ├── unit/
    │   ├── orange-money.service.spec.ts
    │   └── orange-money.handler.spec.ts
    ├── integration/
    │   └── orange-money.integration.spec.ts
    └── fixtures/
        ├── webhook-confirmed.json      ← anonymized real payload
        └── webhook-failed.json
```

### Running Tests

```bash
# Test everything
pnpm test:all

# A specific package
pnpm --filter @shoperzz/plugin-payment-orange-money test

# With coverage
pnpm --filter @shoperzz/plugin-payment-orange-money test --coverage

# Watch mode
pnpm --filter @shoperzz/plugin-payment-orange-money test --watch
```

### Mandatory Coverage Thresholds

- **Global:** 80% minimum
- **Webhook Handlers:** 100% — no exceptions
- **Payment Services:** 100% — no exceptions

A PR that lowers coverage below these thresholds will be rejected by CI.

### Writing Good Tests

```typescript
// ✓ Test that describes expected behavior
it('rejects a webhook with an invalid signature', async () => {
  const payload = loadFixture('webhook-confirmed.json')
  await expect(handler.handleWebhook(payload, 'invalid-sig'))
    .rejects.toThrow(InvalidWebhookSignatureException)
})

// ✓ Idempotency test — critical for payments
it('does not process the same webhook twice', async () => {
  const payload = loadFixture('webhook-confirmed.json')
  transactionRepo.setExistingTransaction({ status: 'confirmed' })
  await handler.handleWebhook(payload)
  expect(eventBus.emitted).toHaveLength(0)
})
```

### Fixtures — Mandatory Rule

JSON files in `fixtures/` are **anonymized** real payloads. Replace phone numbers with `771234567`, names with `Test User`, IDs with identically formatted but fictitious IDs.

---

## 9. Creating a Plugin

### Generating the Structure

```bash
pnpm plugin:create payment-mtn-momo
```

The script asks you a few questions and generates the complete structure with all standard files.

### Plugin Structure

```
plugins/payment-mtn-momo/
├── src/
│   ├── index.ts                    ← public exports only
│   ├── mtn-momo.plugin.ts          ← implements ShoperzzPlugin
│   ├── mtn-momo.module.ts          ← NestJS module
│   ├── mtn-momo.service.ts         ← business logic
│   ├── mtn-momo.handler.ts         ← webhooks and events
│   ├── mtn-momo.events.ts          ← typed event definitions
│   └── mtn-momo.config.ts          ← configuration interface
├── __tests__/
│   ├── unit/
│   └── fixtures/
├── shoperzz.plugin.yml             ← mandatory manifest
├── package.json
└── README.md
```

### The `shoperzz.plugin.yml` Manifest

```yaml
name: "@shoperzz/plugin-payment-mtn-momo"
version: "1.0.0"
category: "payment"

permissions:
  - order.read
  - order.write
  - payment.write
  - webhook.receive

emits:
  - payment.mtn-momo.initiated
  - payment.mtn-momo.confirmed
  - payment.mtn-momo.failed

listens:
  - order.created
```

### Community Plugin

If you create a plugin that is not intended to be official:

```bash
pnpm plugin:create payment-flutterwave --community
```

It will be under `@shoperzz-community/plugin-payment-flutterwave` on npm. To submit it to the official registry, use the **Plugin Submission** issue template.

---

## 10. Opening a Pull Request

### Before Opening the PR

```bash
# 1. Tests pass
pnpm test:all

# 2. Clean lint
pnpm lint && pnpm typecheck

# 3. Changeset created if packages modified
pnpm changeset
# → interactive interface → choose package → patch/minor/major → describe

# 4. Everything is committed and pushed
pnpm push    # the script checks everything before pushing
```

### Creating the PR

- **Base:** always `develop` — never `main`
- **Title:** same format as commits — `feat(payment): add MTN MoMo plugin`
- **Description:** fill out the template honestly — especially the checklist

### What CI Checks

The PR is blocked if:

- Lint fails
- TypeScript has errors
- Tests fail
- Coverage is insufficient
- A `.changeset` file is missing when packages have been modified
- The PR's commit format does not follow the convention

---

## 11. Review Process

### Deadlines

- **First response:** 3 business days
- **Full review:** 7 business days

If you don't hear back after 7 days, ping the maintainer in the PR comments.

### What Reviewers Look For

- The code does what the PR says
- Tests cover important cases (especially webhook edge cases)
- Naming conventions are respected
- No sensitive data in code or tests
- The PR does not introduce regressions

### Responding to Feedback

- Each review comment is a conversation, not an injunction
- If you disagree, state why — it's legitimate
- When you've applied a change, mark the thread as resolved
- Add a commit with the corrections (do not rebase history during review)

---

## 12. Versions and Releases

Shoperzz uses **Changesets** to manage versions. You don't have to worry about it too much — here's how it works from your side.

### Declaring Your Change

After coding, before pushing:

```bash
pnpm changeset
```

Interactive interface:

```
🦋  Which packages changed?
    ◉ @shoperzz/plugin-payment-mtn-momo

🦋  Type of change?
    ○ patch (bug fix)
    ◉ minor (new feature)
    ○ major (breaking change)

🦋  Describe the change:
    › Add MTN MoMo payment plugin for Cameroon and Central Africa
```

A `.changeset/[hash].md` file is created. Commit it with your PR.

### What Happens Next

It's automatic. When your PR is merged, Changesets accumulates the changesets. At the next release, it bumps versions, updates CHANGELOGs, publishes to npm, and creates git tags — without manual intervention.

---

## Questions?

- **Discord:** https://discord.gg/shoperzz — the fastest way
- **GitHub Discussions:** for longer questions
- **Issues:** only for bugs and feature requests

Thank you for contributing to Shoperzz. This project exists because African developers deserve tools designed for their markets.
