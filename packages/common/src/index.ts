// Public surface of @shoperzz/common.
// Import from this path only — never from deep internal paths.
export type { ShoperzzPluginStatic } from "./plugin.types";

export type {
  ShoperzzPluginManifest,
  PluginPermission,
} from "./manifest.types";

export type {
  ShoperzzEvent,
  EventPayload,
  ShoperzzEventHandler,
} from "./events.types";

export type { ShoperzzConfig, ShoperzzCoreConfig } from "./config.types";

export type { Type, DeepReadonly, RequireKeys } from "./utils.types";
