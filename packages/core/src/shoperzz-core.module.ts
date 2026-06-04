import { DynamicModule, Module, Global } from "@nestjs/common";
import { ShoperzzConfig } from "@shoperzz/common";
import { PluginRegistry } from "./plugin-registry/plugin-registry.service";
import { ShoperzzEventBus } from "./event-bus/shoperzz-event-bus.service";

@Global()
@Module({})
export class ShoperzzCoreModule {
  static forRoot(config: ShoperzzConfig): DynamicModule {
    // 1. Initialize and register all active plugins in the registry
    const registry = PluginRegistry.getInstance();
    registry.registerPlugins(config.plugins);

    // 2. Extract NestJS modules from all configured plugins
    const pluginModules = config.plugins.map((plugin) => plugin.getNestModule());

    return {
      module: ShoperzzCoreModule,
      imports: [...pluginModules],
      providers: [
        {
          provide: "SHOPERZZ_CONFIG",
          useValue: config,
        },
        {
          provide: PluginRegistry,
          useValue: registry,
        },
        ShoperzzEventBus,
      ],
      exports: [PluginRegistry, ShoperzzEventBus],
    };
  }
}
