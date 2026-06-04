import * as fs from "fs";
import * as path from "path";
import * as yaml from "js-yaml";
import { Injectable } from "@nestjs/common";
import { ShoperzzPluginManifest, ShoperzzPluginStatic } from "@shoperzz/common";
import { validateManifest } from "./manifest-validator";
import { getPackageDir } from "../utils/package-path";

@Injectable()
export class PluginRegistry {
  private static instance: PluginRegistry;
  private pluginMap = new Map<ShoperzzPluginStatic<unknown>, ShoperzzPluginManifest>();
  private nameToPluginMap = new Map<string, ShoperzzPluginStatic<unknown>>();

  public static getInstance(): PluginRegistry {
    if (!PluginRegistry.instance) {
      PluginRegistry.instance = new PluginRegistry();
    }
    return PluginRegistry.instance;
  }

  public registerPlugins(plugins: ShoperzzPluginStatic<unknown>[]): void {
    this.pluginMap.clear();
    this.nameToPluginMap.clear();

    for (const plugin of plugins) {
      const manifest = this.loadManifestForPlugin(plugin);
      this.pluginMap.set(plugin, manifest);
      this.nameToPluginMap.set(manifest.name, plugin);
    }

    for (const [plugin, manifest] of this.pluginMap.entries()) {
      if (manifest.requires) {
        for (const req of manifest.requires) {
          if (!this.nameToPluginMap.has(req)) {
            throw new Error(
              `Plugin "${manifest.name}" requires dependency "${req}" which is not active in the configuration.`,
            );
          }
        }
      }
    }
  }

  public getManifest(plugin: ShoperzzPluginStatic<unknown>): ShoperzzPluginManifest | undefined {
    return this.pluginMap.get(plugin);
  }

  public getManifestByName(name: string): ShoperzzPluginManifest | undefined {
    const plugin = this.nameToPluginMap.get(name);
    return plugin ? this.getManifest(plugin) : undefined;
  }

  public getActivePlugins(): ShoperzzPluginStatic<unknown>[] {
    return Array.from(this.pluginMap.keys());
  }

  public findPluginNameByCallerFile(callerFile: string): string | null {
    const callerPackageDir = getPackageDir(callerFile);
    if (!callerPackageDir) return null;

    for (const [plugin, manifest] of this.pluginMap.entries()) {
      const pluginFilePath = this.getModuleFilePath(plugin);
      if (pluginFilePath) {
        const pluginPackageDir = getPackageDir(pluginFilePath);
        if (pluginPackageDir === callerPackageDir) {
          return manifest.name;
        }
      }
    }
    return null;
  }

  private loadManifestForPlugin(
    plugin: ShoperzzPluginStatic<unknown>,
  ): ShoperzzPluginManifest {
    const pluginWithManifest = plugin as unknown as { manifest?: ShoperzzPluginManifest };
    if (pluginWithManifest.manifest) {
      const manifest = pluginWithManifest.manifest;
      validateManifest(manifest);
      return manifest;
    }

    const filePath = this.getModuleFilePath(plugin);
    if (!filePath) {
      throw new Error(
        `Could not find source file for plugin "${plugin.label || "unknown"}". Ensure it is imported correctly.`,
      );
    }

    let dir = path.dirname(filePath);
    while (dir && dir !== "/" && dir !== ".") {
      const manifestPath = path.join(dir, "shoperzz.plugin.yml");
      if (fs.existsSync(manifestPath)) {
        try {
          const content = fs.readFileSync(manifestPath, "utf8");
          const manifest = yaml.load(content) as ShoperzzPluginManifest;
          validateManifest(manifest);
          return manifest;
        } catch (err) {
          const error = err as Error;
          throw new Error(
            `Failed to parse manifest at ${manifestPath}: ${error.message}`,
          );
        }
      }
      const parent = path.dirname(dir);
      if (parent === dir) break;
      dir = parent;
    }

    throw new Error(
      `Could not find shoperzz.plugin.yml for plugin "${plugin.label || "unknown"}".`,
    );
  }

  private getModuleFilePath(exportedValue: ShoperzzPluginStatic<unknown>): string | null {
    for (const [file, mod] of Object.entries(require.cache)) {
      if (mod && mod.exports) {
        if (
          mod.exports === exportedValue ||
          Object.values(mod.exports).includes(exportedValue)
        ) {
          return file;
        }
        if (mod.exports.default === exportedValue) {
          return file;
        }
      }
    }
    return null;
  }
}
