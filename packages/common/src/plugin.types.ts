import type { Type } from "./utils.types";

// Contract that every Shoperzz plugin class must satisfy.
// The plugin itself is a static class — it's never instantiated by NestJS directly.
// The PluginRegistry reads these static properties to orchestrate the bootstrap sequence.
export interface ShoperzzPluginStatic<TOptions = unknown> {
  readonly label: string;
  readonly description: string;
  readonly version: string;

  // Configures the plugin before it's passed to the core.
  // Always called in shoperzz.config.ts — never inside application code.
  // Returns `this` so the call can be inlined: OrangeMoneyPlugin.init({ ... })
  init(options: TOptions): ShoperzzPluginStatic<TOptions>;

  // The NestJS module the plugin registers into the global container.
  // Called once by the PluginRegistry during app bootstrap.
  getNestModule(): Type<unknown>;

  // Optional. GraphQL resolvers or type extensions this plugin contributes.
  // Called when the ShoperzzCoreModule builds the unified GraphQL schema.
  getGraphQLExtensions?(): Type<unknown>[];
}
