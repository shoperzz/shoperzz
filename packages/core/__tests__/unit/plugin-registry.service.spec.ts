import { PluginRegistry } from "../../src/plugin-registry/plugin-registry.service";
import { ShoperzzPluginStatic, ShoperzzPluginManifest } from "@shoperzz/common";
import { MockFixturePlugin } from "../fixtures/mock-plugin/src/mock.plugin";

describe("PluginRegistry", () => {
  let registry: PluginRegistry;

  beforeEach(() => {
    registry = PluginRegistry.getInstance();
    // Clear maps before each test to guarantee test isolation
    const reg = registry as unknown as {
      pluginMap: Map<ShoperzzPluginStatic<unknown>, ShoperzzPluginManifest>;
      nameToPluginMap: Map<string, ShoperzzPluginStatic<unknown>>;
    };
    reg.pluginMap.clear();
    reg.nameToPluginMap.clear();
  });

  // Helper to create mock static plugin classes
  function createMockPlugin(
    name: string,
    manifestData: Partial<ShoperzzPluginManifest> = {},
  ): ShoperzzPluginStatic<unknown> {
    const mockModule = class MockPluginModule {};
    const pluginClass = class MockPlugin {
      static label = manifestData.label || `${name} Plugin`;
      static description = "Mock plugin for testing";
      static version = manifestData.version || "1.0.0";
      static init(options: unknown) {
        return this;
      }
      static getNestModule() {
        return mockModule;
      }
    };

    // Embed inline manifest as an escape hatch for tests
    const pluginWithManifest = pluginClass as unknown as { manifest: ShoperzzPluginManifest };
    pluginWithManifest.manifest = {
      name,
      version: pluginClass.version,
      label: pluginClass.label,
      category: manifestData.category || "payment",
      permissions: manifestData.permissions || [],
      emits: manifestData.emits || [],
      listens: manifestData.listens || [],
      requires: manifestData.requires || [],
      ...manifestData,
    };

    return pluginClass;
  }

  it("should register valid plugins successfully", () => {
    const mockPlugin = createMockPlugin("@shoperzz/plugin-mock-one");

    expect(() => registry.registerPlugins([mockPlugin])).not.toThrow();
    expect(registry.getActivePlugins()).toContain(mockPlugin);
    expect(registry.getManifest(mockPlugin)).toBeDefined();
    expect(registry.getManifestByName("@shoperzz/plugin-mock-one")).toBeDefined();
  });

  it("should fail validation if manifest misses required fields", () => {
    const fields = ["name", "version", "label", "category", "permissions", "emits", "listens"];
    for (const field of fields) {
      const mockPlugin = createMockPlugin("@shoperzz/plugin-mock-invalid");
      const pluginWithManifest = mockPlugin as unknown as { manifest?: Record<string, unknown> };
      if (pluginWithManifest.manifest) {
        delete pluginWithManifest.manifest[field];
      }
      expect(() => registry.registerPlugins([mockPlugin])).toThrow(
        new RegExp(`missing required (?:field )?"${field}"`),
      );
    }
  });

  it("should return null for findPluginNameByCallerFile when path is invalid or outside packages", () => {
    const name = registry.findPluginNameByCallerFile("/invalid/path/file.ts");
    expect(name).toBeNull();
  });

  it("should enforce dependencies declared in the requires field", () => {
    const dependentPlugin = createMockPlugin("@shoperzz/plugin-dependent", {
      requires: ["@shoperzz/plugin-dependency"],
    });

    expect(() => registry.registerPlugins([dependentPlugin])).toThrow(
      /requires dependency "@shoperzz\/plugin-dependency" which is not active/,
    );

    const dependencyPlugin = createMockPlugin("@shoperzz/plugin-dependency");
    expect(() =>
      registry.registerPlugins([dependentPlugin, dependencyPlugin]),
    ).not.toThrow();
  });

  it("should load the manifest from the filesystem (shoperzz.plugin.yml)", () => {
    expect(() => registry.registerPlugins([MockFixturePlugin])).not.toThrow();
    
    const manifest = registry.getManifest(MockFixturePlugin);
    expect(manifest).toBeDefined();
    expect(manifest?.name).toBe("@shoperzz/plugin-mock-fixture");
    expect(manifest?.label).toBe("Mock Fixture");
    expect(manifest?.permissions).toContain("order.read");
    expect(manifest?.emits).toContain("payment.mock-fixture.confirmed");
    expect(manifest?.listens).toContain("order.created");
  });

  it("should successfully resolve plugin name from caller file", () => {
    registry.registerPlugins([MockFixturePlugin]);
    
    // Simulate a call from a file inside the mock-plugin package
    const fakeCallerFile = "/home/kali-root/Dev/Personnal Projects/!@Github Organizations/shoperzz/shoperzz/packages/core/__tests__/fixtures/mock-plugin/src/mock.service.ts";
    const pluginName = registry.findPluginNameByCallerFile(fakeCallerFile);
    expect(pluginName).toBe("@shoperzz/plugin-mock-fixture");
  });
});
