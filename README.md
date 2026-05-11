<div align="center">
  <img src="./assets/logos/LOGO-COLORED-SVG.svg" alt="Shoperzz Banner" width="300" height="" style="object-fit: cover;">

  <p align="center">
    <strong>The modern, headless, self-hosted, open-source commerce engine for serious builders. Powered by NestJS & Vendure.
</strong>
  </p>

  <div align="center">
    <img src="https://img.shields.io/badge/NestJS-E0234E?style=flat-square&logo=nestjs&logoColor=white" alt="NestJS">
    <img src="https://img.shields.io/badge/TypeScript-007ACC?style=flat-square&logo=typescript&logoColor=white" alt="TypeScript">
    <img src="https://img.shields.io/badge/JavaScript-F7DF1E?style=flat-square&logo=javascript&logoColor=black" alt="JavaScript">
    <img src="https://img.shields.io/badge/Vendure-2F3542?style=flat-square&logo=shoperzz&logoColor=white" alt="Vendure">
    <img src="https://img.shields.io/badge/GraphQL-E10098?style=flat-square&logo=graphql&logoColor=white" alt="GraphQL">
    <img src="https://img.shields.io/badge/PostgreSQL-336791?style=flat-square&logo=postgresql&logoColor=white" alt="PostgreSQL">
    <img src="https://img.shields.io/badge/TypeORM-FE0808?style=flat-square&logo=typeorm&logoColor=white" alt="TypeORM">
    <img src="https://img.shields.io/badge/Node.js-339933?style=flat-square&logo=node.js&logoColor=white" alt="Node.js">
    <img src="https://img.shields.io/badge/npm-CB3837?style=flat-square&logo=npm&logoColor=white" alt="npm">
    <img src="https://img.shields.io/badge/pnpm-F69220?style=flat-square&logo=pnpm&logoColor=white" alt="pnpm">
    <img src="https://img.shields.io/badge/Turborepo-EF4444?style=flat-square&logo=turborepo&logoColor=white" alt="Turborepo">
    <img src="https://img.shields.io/github/stars/shoperzz/shoperzz?style=flat-square&logo=github&color=FFD700" alt="GitHub Stars">
  </div>
</div>

---

## About Shoperzz

Shoperzz is an Enterprise-Grade Headless E-commerce Engine built for modularity, performance, and developer freedom. It decouples the core commerce logic from the storefront and features, allowing you to build exactly what you need without the bloat.

Inspired by NestJS and [Vendure](https://github.com/vendurehq/vendure), Shoperzz operates on a strict plugin-first philosophy. Nothing is imposed; everything from local payment gateways (Orange Money, Wave) to WhatsApp notifications is an optional, decoupled plugin. This architecture ensures your build remains clean, only including the code your specific use-case requires.

## Key Features

- **Modular Architecture**: Facilitates adding new functionalities and integrating with third-party services.
- **Robust API**: A well-documented API for flexible frontend integration.
- **Plugin System**: Shoperzz operates entirely on a plugin system, similar to Vendure. Local payments, WhatsApp, etc., are not hardcoded into the core. Nothing is imposed. The core framework remains lightweight, clean, and universal. What you see as "integrated features" is actually an ecosystem of official plugins that you install only if you need them.
  - Want Orange Money? Install the plugin. Want Wave? Plugin. Want both plus MTN MoMo? Add them, configure them, and move on.
  - Don't use WhatsApp in your project? Don't install the plugin; it won't exist for you. Your build remains clean.
  - This philosophy, inspired by NestJS, ensures independent, decoupled modules that activate only when needed. Each plugin is an autonomous unit with its own logic, events, and handlers, integrating seamlessly without creating unnecessary dependencies.
  - This means Shoperzz adapts to your project, not the other way around. You build a marketplace? Activate marketplace plugins. You're doing B2B? You have no reason to have the consumer WhatsApp plugin. You work in a market where Stripe works? Use the Stripe plugin; Orange Money plugins won't exist in your project. You start from scratch with only what you need.
  - The ecosystem grows independently of the core. A plugin can be maintained by the Shoperzz team, the community, or by you directly for your specific use case. You can create your own payment plugin for a gateway no one has integrated yet. You contribute, you publish, others use it. This is how serious tools grow.
  - This is where the comparison with "a ready-made application" completely falls apart. A ready-made application dictates to you. A plugin system empowers you. You decide what goes into your infrastructure, you know exactly what's running, you can audit, replace, and extend each component independently. It's the difference between an opaque monolith and an architecture you understand and control 100%.
- **Optimized Performance**: Designed for speed and efficiency.
- **Modern Tech Stack**: Utilizes the latest technologies for a pleasant development experience.
- **Flexible Content Management**: Allows easy management of products, categories, and other content.
- **Africa-Centric Features**: Native integration for local payment gateways (Orange Money, Wave, MTN MoMo, Airtel Money) and WhatsApp for customer communication and automations.

## Getting Started

### Prerequisites

- Node.js (>= 18)
- pnpm

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/shoperzz/shoperzz.git
   cd shoperzz
   ```

2. **Install dependencies**
   ```bash
   pnpm install
   ```

3. **Run in Development mode**
   To start the entire monorepo (core, apps, and demos) in development mode:
   ```bash
   pnpm dev
   ```

### Running Demos
If you want to run a specific demo, such as the basic storefront:
```bash
pnpm turbo run dev --filter store-basic
```

## Project Structure

| Directory   | Description                                                    |
|-------------|----------------------------------------------------------------|
| `apps/`     | Web applications (Platform, Docs, Dashboard)                   |
| `assets/`   | Project assets: svg logos, png banners and others              |
| `packages/` | Core framework engines (`/core`, `/cli`,`/common`, `/testing`) |
| `plugins/`  | Official feature extensions and modules                        |
| `demos/`    | Ready-to-use storefront and API examples                       |
| `docs/`     | Documentation of Shoperzz project                              |
| `tooling/`  | Shared build, lint, and test configurations                    |
| `e2e/`      | Cross-package end-to-end test scenarios                        |

## Contributors

<a href="https://github.com/shoperzz/shoperzz/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=shoperzz/shoperzz" alt="Contributors" />
</a>

## Maintainer

**[The Shoperzz Lead](https://github.com/shoperzz)** — lead maintainer

## Contributing

We encourage and appreciate community contributions! If you wish to improve Shoperzz, please consult our [Contributing Guidelines](CONTRIBUTING.md) to learn how to report bugs, suggest enhancements, or submit code.

## Security

Security is a priority. If you discover a vulnerability, please consult our [Security Policy](SECURITY.md) to learn how to report it responsibly.

## License

This project is licensed under the [GNU General Public License version 3 (GPLv3)](LICENSE). For more details, please refer to the `LICENSE` file.

## Stats

![Repobeats analytics](https://repobeats.axiom.co/api/embed/b1bf4dc0226458617adbdbf5586f2df953eb0922.svg 'Repobeats analytics image')

---

<p align="center">
  Built with love for serious builders.
</p>
