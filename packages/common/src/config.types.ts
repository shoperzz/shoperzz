import type { ShoperzzPluginStatic } from "./plugin.types";

// Core engine options. These fine-tune the Shoperzz bootstrap process.
// All fields are optional — the core applies sane defaults when omitted.
export interface ShoperzzCoreConfig {
  // Base path mounted by the API router. Default: '/api'
  apiPath?: string;

  // Default language (ISO 639-1). Default: 'en'
  defaultLanguage?: string;

  // Active currency codes (ISO 4217). First entry is the default currency.
  // Example: ['XOF', 'EUR']
  currencies?: string[];
}

// The master configuration object written by the developer in shoperzz.config.ts.
// This is the single source of truth for everything that runs in the application.
// The core reads it once at startup. Nothing else is read.
//
// Usage in shoperzz.config.ts:
//
//   export const config: ShoperzzConfig = {
//     core: {
//       apiPath: '/api',
//       defaultLanguage: 'fr',
//       currencies: ['XOF'],
//     },
//     plugins: [
//       OrangeMoneyPlugin.init({ apiKey: process.env.ORANGE_API_KEY! }),
//       WhatsappPlugin.init({ accessToken: process.env.WA_TOKEN! }),
//     ],
//   }
//
export interface ShoperzzConfig {
  core?: ShoperzzCoreConfig;

  // Each plugin must be configured via its static .init() method before being listed here.
  // Plugins are registered in array order. The PluginRegistry validates each one at startup.
  plugins: ShoperzzPluginStatic<unknown>[];
}
