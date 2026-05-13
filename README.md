<div align="center">

  <img src="./assets/logos/LOGO-COLORED-SVG.svg" alt="Shoperzz" width="380" />

  <p>
    <strong>The modern, headless, open-source e-commerce engine for serious builders.</strong><br/>
    Built on NestJS & Vendure. Designed for Africa.
  </p>

  <br/>

  <div>
    <img src="https://img.shields.io/badge/NestJS-E0234E?style=flat-square&logo=nestjs&logoColor=white" alt="NestJS">
    <img src="https://img.shields.io/badge/TypeScript-007ACC?style=flat-square&logo=typescript&logoColor=white" alt="TypeScript">
    <img src="https://img.shields.io/badge/GraphQL-E10098?style=flat-square&logo=graphql&logoColor=white" alt="GraphQL">
    <img src="https://img.shields.io/badge/PostgreSQL-336791?style=flat-square&logo=postgresql&logoColor=white" alt="PostgreSQL">
    <img src="https://img.shields.io/badge/Vendure-2F3542?style=flat-square&logoColor=white" alt="Vendure">
    <img src="https://img.shields.io/badge/pnpm-F69220?style=flat-square&logo=pnpm&logoColor=white" alt="pnpm">
    <img src="https://img.shields.io/badge/Turborepo-EF4444?style=flat-square&logo=turborepo&logoColor=white" alt="Turborepo">
  </div>

  <div>
    <img src="https://img.shields.io/github/stars/shoperzz/shoperzz?style=flat-square&logo=github&color=FFD700" alt="Stars">
    <img src="https://img.shields.io/github/license/shoperzz/shoperzz?style=flat-square&color=blue" alt="License">
    <a href="https://www.npmjs.com/package/@shoperzz/core">
      <img src="https://img.shields.io/npm/v/@shoperzz/core?style=flat-square&logo=npm&color=CB3837" alt="npm version">
    </a>
    <a href="https://www.npmjs.com/package/@shoperzz/core">
      <img src="https://img.shields.io/npm/dm/@shoperzz/core?style=flat-square&color=CB3837" alt="npm downloads">
    </a>
    <img src="https://img.shields.io/badge/PRs-welcome-brightgreen?style=flat-square" alt="PRs welcome">
  </div>

  <br/>

  <p>
    <a href="https://docs.shoperzz.dev">Documentation</a> ·
    <a href="https://shoperzz.dev">Website</a> ·
    <a href="https://discord.gg/shoperzz">Discord</a> ·
    <a href="https://github.com/shoperzz/shoperzz/issues">Report Bug</a>
  </p>

</div>

---

## About Shoperzz

Shoperzz is an Enterprise-Grade Headless E-commerce Engine built first for TypeScript Developers. It is designed for modularity, performance, and developer freedom. It decouples the core commerce logic from the storefront and features, allowing you to build exactly what you need without the bloat.

Inspired by NestJS and **[Vendure](https://github.com/vendure-ecommerce/vendure)** (8,200+ ⭐ - a battle-tested headless commerce framework in TypeScript), Shoperzz operates on a strict plugin-first philosophy. Nothing is imposed; everything from local payment gateways (Orange Money, Wave) to WhatsApp notifications is an optional, decoupled plugin. This architecture ensures your build remains clean, only including the code your specific use-case requires.

## Key Features

| Feature                     | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
|-----------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **Plugin-First Philosophy** | Shoperzz operates entirely on a plugin-first system, heavily inspired by NestJS and Vendure. Nothing is hardcoded or imposed into the core. What appear as "features" (local payments like Orange Money, Wave, MTN MoMo, or WhatsApp automations) are actually official, decoupled plugins. This ensures your build remains 100% clean—you decide what goes into your infrastructure, knowing exactly what's running, with the power to audit, replace, and extend each component independently. |
| **Independent Modules**     | Each plugin is an autonomous unit with its own logic, events, and handlers. This architecture means Shoperzz adapts to your project, not the other way around. If you're building a B2B platform, you won't have consumer-focused plugins like WhatsApp unless you choose to. The ecosystem grows independently of the core, maintained by the Shoperzz team or the community, allowing you to create and publish your own payment gateways or services.                                         |
| **Robust GraphQL API**      | A well-documented, unified API provides maximum flexibility for any frontend integration. Whether you're building a mobile app, a high-performance Next.js storefront, or a custom dashboard, Shoperzz provides the clean, typed data you need without the bloat of monolithic legacy platforms.                                                                                                                                                                                                 |
| **Africa-Native Focus**     | Native, out-of-the-box integration for local payment gateways pervasive in the African market (Orange Money, Wave, MTN MoMo, Airtel Money). It also prioritizes WhatsApp as a first-class citizen for customer communication and business automation, recognizing its central role in the regional commerce landscape.                                                                                                                                                                           |
| **Enterprise Scalability**  | Designed for performance, speed, and serious builders. Shoperzz handles complex marketplace logic or specialized B2B scenarios by leveraging a modern tech stack (Node.js, TypeScript, NestJS, TypeORM). It avoids the "ready-made application" trap by empowering developers with an architecture they understand and control entirely.                                                                                                                                                         |
| **Total Sovereignty**       | Reclaim control over your e-commerce stack. By moving away from opaque monoliths to a transparent, plugin-based architecture, you gain the sovereignty needed to innovate faster. You start with a lightweight core and build up only with the specific modules your use-case requires.                                                                                                                                                                                                          |

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

## Contributors

<a href="https://github.com/shoperzz/shoperzz/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=shoperzz/shoperzz" alt="Contributors" />
</a>

## Stats

![Alt](https://repobeats.axiom.co/api/embed/dc3ee4ef56a50b7b572f3cb71bbcff286342fd2a.svg "Repobeats analytics image")

[//]: # (## Maintainer)

[//]: # ()
[//]: # (|                                                                                  | Name                                      | Role                      |)

[//]: # (|----------------------------------------------------------------------------------|-------------------------------------------|---------------------------|)

[//]: # (| [![Wistant]&#40;https://github.com/wistant.png?size=50&#41;]&#40;https://github.com/wistant&#41; | **[Wistant]&#40;https://github.com/wistant&#41;** | Creator & Lead Maintainer |)

## Contributing

We encourage and appreciate community contributions! If you wish to improve Shoperzz, please consult our [Contributing Guidelines](CONTRIBUTING.md) to learn how to report bugs, suggest enhancements, or submit code.

## Security

Security is a priority. If you discover a vulnerability, please consult our [Security Policy](SECURITY.md) to learn how to report it responsibly.

## License

This project is licensed under the [GNU General Public License version 3 (GPLv3)](LICENSE). For more details, please refer to the `LICENSE` file.

---

<p align="center">
  Built with love for serious builders.
</p>
