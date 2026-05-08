# Primitives (@shoperzz/plugins)

This directory represents the second layer of logistics: fully autonomous NPM packages designed to augment the core engine.

Each subdirectory here is a standalone, independently testable project with its own configuration (package.json, TSConfig). A plugin must adhere to a strict rule: it exposes standardized logical interfaces that address a deep-local African requirement without creating any coupling with other modules.

Planned examples:
- Mobile Money payment with network retries (Pro)
- WhatsApp Business Notifications (Pro)
- Intelligent shipping calculation by geographic zone (Pro)
- E-commerce Analytics (Community)
