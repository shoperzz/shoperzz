import { ShoperzzEventBus } from "../../src/event-bus/shoperzz-event-bus.service";
import { PluginRegistry } from "../../src/plugin-registry/plugin-registry.service";
import { ShoperzzPluginStatic, ShoperzzPluginManifest } from "@shoperzz/common";

describe("ShoperzzEventBus", () => {
  let eventBus: ShoperzzEventBus;
  let registry: PluginRegistry;

  beforeEach(() => {
    eventBus = new ShoperzzEventBus();
    registry = PluginRegistry.getInstance();
    // Reset registry maps
    const reg = registry as unknown as {
      pluginMap: Map<ShoperzzPluginStatic<unknown>, ShoperzzPluginManifest>;
      nameToPluginMap: Map<string, ShoperzzPluginStatic<unknown>>;
    };
    reg.pluginMap.clear();
    reg.nameToPluginMap.clear();
    jest.restoreAllMocks();
  });

  function registerMockPlugin(
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

    registry.registerPlugins([pluginClass]);
    return pluginClass;
  }

  describe("emit validation", () => {
    it("should allow emitting event declared in emits[]", async () => {
      const pluginName = "@shoperzz/plugin-orange-money";
      registerMockPlugin(pluginName, {
        emits: ["payment.orange-money.confirmed"],
      });

      // Stub findPluginNameByCallerFile to return our mock plugin name
      jest
        .spyOn(registry, "findPluginNameByCallerFile")
        .mockReturnValue(pluginName);

      const handler = jest.fn();
      // Temporarily mock permission for listening to make the subscription pass
      jest
        .spyOn(registry, "findPluginNameByCallerFile")
        .mockReturnValue("core");
      eventBus.on("payment.orange-money.confirmed", handler);

      // Now mock it as coming from the plugin during emission
      jest
        .spyOn(registry, "findPluginNameByCallerFile")
        .mockReturnValue(pluginName);

      await expect(
        eventBus.emit("payment.orange-money.confirmed", { orderId: "123" }),
      ).resolves.not.toThrow();

      // Wait a tick for async execution of listener
      await new Promise((resolve) => process.nextTick(resolve));
      expect(handler).toHaveBeenCalledWith(
        expect.objectContaining({
          type: "payment.orange-money.confirmed",
          payload: { orderId: "123" },
          pluginSource: pluginName,
        }),
      );
    });

    it("should reject emitting event NOT declared in emits[]", async () => {
      const pluginName = "@shoperzz/plugin-orange-money";
      registerMockPlugin(pluginName, {
        emits: [],
      });

      jest
        .spyOn(registry, "findPluginNameByCallerFile")
        .mockReturnValue(pluginName);

      await expect(
        eventBus.emit("payment.orange-money.confirmed", { orderId: "123" }),
      ).rejects.toThrow(/not authorized to emit event/);
    });
  });

  describe("listen validation", () => {
    it("should allow subscribing to event declared in listens[]", () => {
      const pluginName = "@shoperzz/plugin-whatsapp";
      registerMockPlugin(pluginName, {
        listens: ["payment.orange-money.confirmed"],
      });

      jest
        .spyOn(registry, "findPluginNameByCallerFile")
        .mockReturnValue(pluginName);

      expect(() =>
        eventBus.on("payment.orange-money.confirmed", () => {}),
      ).not.toThrow();
    });

    it("should reject subscribing to event NOT declared in listens[]", () => {
      const pluginName = "@shoperzz/plugin-whatsapp";
      registerMockPlugin(pluginName, {
        listens: [],
      });

      jest
        .spyOn(registry, "findPluginNameByCallerFile")
        .mockReturnValue(pluginName);

      expect(() =>
        eventBus.on("payment.orange-money.confirmed", () => {}),
      ).toThrow(/not authorized to listen to event/);
    });

    it("should support wildcard matching for listens[]", () => {
      const pluginName = "@shoperzz/plugin-whatsapp";
      registerMockPlugin(pluginName, {
        listens: ["payment.*.confirmed"],
      });

      jest
        .spyOn(registry, "findPluginNameByCallerFile")
        .mockReturnValue(pluginName);

      expect(() =>
        eventBus.on("payment.orange-money.confirmed", () => {}),
      ).not.toThrow();
    });
  });

  describe("fault isolation", () => {
    it("should isolate failing event handlers and not disrupt the emitter or other handlers", async () => {
      const pluginName = "@shoperzz/plugin-emitter";
      registerMockPlugin(pluginName, {
        emits: ["test.event"],
      });

      jest
        .spyOn(registry, "findPluginNameByCallerFile")
        .mockReturnValue("core");

      const goodHandler = jest.fn();
      const badHandler = jest.fn().mockImplementation(() => {
        throw new Error("Boom");
      });

      eventBus.on("test.event", badHandler);
      eventBus.on("test.event", goodHandler);

      jest
        .spyOn(registry, "findPluginNameByCallerFile")
        .mockReturnValue(pluginName);

      await expect(
        eventBus.emit("test.event", { data: 42 }),
      ).resolves.not.toThrow();

      // Wait a tick for async tasks to execute
      await new Promise((resolve) => setTimeout(resolve, 10));

      expect(badHandler).toHaveBeenCalled();
      expect(goodHandler).toHaveBeenCalled();
    });
  });

  describe("request-response", () => {
    it("should return the value from the registered handler", async () => {
      const pluginName = "@shoperzz/plugin-requester";
      registerMockPlugin(pluginName, {
        emits: ["payment.authorize"],
      });

      jest
        .spyOn(registry, "findPluginNameByCallerFile")
        .mockReturnValue("core");

      eventBus.on<{ amount: number }>("payment.authorize", (event) => {
        return { authorized: true, amount: event.payload.amount } as unknown as void;
      });

      jest
        .spyOn(registry, "findPluginNameByCallerFile")
        .mockReturnValue(pluginName);

      const result = await eventBus.request("payment.authorize", {
        amount: 5000,
      });
      expect(result).toEqual({ authorized: true, amount: 5000 });
    });

    it("should reject request if plugin NOT authorized to request the event", async () => {
      const pluginName = "@shoperzz/plugin-requester-unauth";
      registerMockPlugin(pluginName, {
        emits: [],
      });

      jest
        .spyOn(registry, "findPluginNameByCallerFile")
        .mockReturnValue(pluginName);

      await expect(
        eventBus.request("payment.authorize", { amount: 5000 }),
      ).rejects.toThrow(/not authorized to request event/);
    });

    it("should throw if no handler is registered for request", async () => {
      const pluginName = "@shoperzz/plugin-requester";
      registerMockPlugin(pluginName, {
        emits: ["payment.authorize"],
      });

      jest
        .spyOn(registry, "findPluginNameByCallerFile")
        .mockReturnValue(pluginName);

      await expect(
        eventBus.request("payment.authorize", { amount: 5000 }),
      ).rejects.toThrow(/No handler registered to process/);
    });
  });

  describe("once subscription", () => {
    it("should subscribe to event only once", async () => {
      const pluginName = "@shoperzz/plugin-once";
      registerMockPlugin(pluginName, {
        listens: ["test.once-event"],
        emits: ["test.once-event"],
      });

      const handler = jest.fn();
      
      jest
        .spyOn(registry, "findPluginNameByCallerFile")
        .mockReturnValue(pluginName);
        
      eventBus.once("test.once-event", handler);

      await eventBus.emit("test.once-event", { val: 1 });
      await eventBus.emit("test.once-event", { val: 2 });

      await new Promise((resolve) => setTimeout(resolve, 10));

      expect(handler).toHaveBeenCalledTimes(1);
    });
  });
});
