// Permission identifiers a plugin can request in its manifest.
// The PluginRegistry checks these at startup and refuses any plugin
// that claims a permission not listed here.
// When adding a new permission, update the PluginRegistry validation logic as well.
export type PluginPermission =
  | 'order.read'
  | 'order.write'
  | 'order.cancel'
  | 'payment.read'
  | 'payment.write'
  | 'payment.refund'
  | 'webhook.receive'
  | 'webhook.emit'
  | 'customer.read'
  | 'customer.write'
  | 'product.read'
  | 'product.write'
  | 'notification.send'
  | 'admin.read'
  | 'admin.write'

// Declarative manifest of a Shoperzz plugin.
// Maps to the contents of shoperzz.plugin.yml at the root of each plugin package.
// The PluginRegistry parses and validates this before any plugin code runs.
// A malformed manifest stops the application at startup — no silent failures.
export interface ShoperzzPluginManifest {
  // Canonical npm package name. Must be scoped under @shoperzz or @shoperzz-community.
  name: string

  // Must match the version in the plugin's package.json exactly.
  version: string

  // Human-readable label shown in logs and tooling output.
  label: string

  // Used for filtering in the npm registry and the plugin marketplace.
  category: 'payment' | 'notification' | 'shipping' | 'marketplace' | 'analytics' | 'auth' | string

  // All permissions must be declared upfront. No implicit grants at runtime.
  permissions: PluginPermission[]

  // Events this plugin emits to the bus. Convention: "domain.plugin-slug.action"
  // Example: "payment.orange-money.confirmed"
  // The PluginRegistry blocks emission of any event not listed here.
  emits: string[]

  // Events this plugin subscribes to. The bus only routes declared events to this plugin.
  listens: string[]

  // Other plugin package names that must be active before this plugin is loaded.
  requires?: string[]

  // Relative paths from the plugin src/ directory to TypeORM migration files.
  migrations?: string[]
}
