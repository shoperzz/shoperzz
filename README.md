<div align="center">

  <img src="./assets/logos/LOGO-COLORED-SVG.svg" alt="Shoperzz" width="380" />
  <br/>
  <p>
    <strong>The modern, headless, open-source e-commerce engine for serious builders.</strong><br/>
    Built on NestJS & Vendure. Designed for Africa.
  </p>

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

  <p>
    <a href="https://docs.shoperzz.dev">📚 Documentation</a> ·
    <a href="https://shoperzz.dev">🌐 Website</a> ·
    <a href="https://discord.gg/shoperzz">💬 Discord</a> ·
    <a href="https://github.com/shoperzz/shoperzz/issues">🔊 Report Bug</a>
  </p>

</div>

<br/>
<br/>
<br/>

Shoperzz is an Enterprise-Grade Headless E-commerce Engine built first for TypeScript Developers. It is designed for modularity, performance, and developer freedom. It decouples the core commerce logic from the storefront and features, allowing you to build exactly what you need without the bloat.

Inspired by NestJS and **[Vendure](https://github.com/vendurehq/vendure)** (8,200+ ⭐ - a battle-tested headless commerce framework in TypeScript), Shoperzz operates on a strict plugin-first philosophy. Nothing is imposed; everything from local payment gateways (Orange Money, Wave) to WhatsApp notifications is an optional, decoupled plugin. This architecture ensures your build remains clean, only including the code your specific use-case requires.

## Key Features

| Feature                     | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| --------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **Plugin-First Philosophy** | Shoperzz operates on a strict plugin-first system, inspired by NestJS and Vendure. Nothing is hardcoded into the core; all functionalities, from payment gateways and shipping methods to communication channels and business automations, are implemented as optional, decoupled plugins. This architecture ensures your build remains clean and efficient, allowing you to precisely control what goes into your infrastructure. You gain the power to audit, replace, and extend each component independently, tailoring the platform to any market or business model.            |
| **Independent Modules**     | Each plugin functions as an autonomous unit with its own logic, events, and handlers. This modularity ensures Shoperzz adapts to your project's unique requirements, rather than the other way around. Whether you need specific payment providers, custom CRM integrations, or unique communication flows (e.g., WhatsApp for certain regions), you only install the plugins relevant to your use case. This fosters an ecosystem that grows independently of the core, enabling the Shoperzz team, the community, or even you to create and publish new services and integrations. |
| **Robust GraphQL API**      | A well-documented, unified API provides maximum flexibility for any frontend integration. Whether you're building a mobile app, a high-performance Next.js storefront, or a custom dashboard, Shoperzz provides the clean, typed data you need without the bloat of monolithic legacy platforms.                                                                                                                                                                                                                                                                                     |
| **Africa-Native Focus**     | Native, out-of-the-box integration for local payment gateways pervasive in the African market (Orange Money, Wave, MTN MoMo, Airtel Money). It also prioritizes WhatsApp as a first-class citizen for customer communication and business automation, recognizing its central role in the regional commerce landscape.                                                                                                                                                                                                                                                               |
| **Enterprise Scalability**  | Designed for performance, speed, and serious builders. Shoperzz handles complex marketplace logic or specialized B2B scenarios by leveraging a modern tech stack (Node.js, TypeScript, NestJS, TypeORM). It avoids the "ready-made application" trap by empowering developers with an architecture they understand and control entirely.                                                                                                                                                                                                                                             |
| **Total Sovereignty**       | Reclaim control over your e-commerce stack. By moving away from opaque monoliths to a transparent, plugin-based architecture, you gain the sovereignty needed to innovate faster. You start with a lightweight core and build up only with the specific modules your use-case requires.                                                                                                                                                                                                                                                                                              |

## Project Structure

| Directory   | Description                                                    |
| ----------- | -------------------------------------------------------------- |
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
