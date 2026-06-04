import { Injectable, Logger } from "@nestjs/common";
import { EventEmitter2 } from "eventemitter2";
import { ShoperzzEvent, ShoperzzEventHandler } from "@shoperzz/common";
import { PluginRegistry } from "../plugin-registry/plugin-registry.service";
import { getCallerFile } from "../utils/caller-resolver";
import { isEventAllowed } from "./event-matcher";

@Injectable()
export class ShoperzzEventBus {
  private emitter = new EventEmitter2({
    wildcard: true,
    delimiter: ".",
    maxListeners: 150,
  });
  private logger = new Logger("ShoperzzEventBus");
  private registry = PluginRegistry.getInstance();

  /**
   * Emits an event asynchronously to all registered listeners.
   * Enforces that the emitting plugin has declared the event in its manifest.
   */
  public async emit<TPayload = Record<string, unknown>>(type: string, payload: TPayload): Promise<void> {
    const callerFile = getCallerFile();
    let pluginSource = "core";

    if (callerFile) {
      const mappedSource = this.registry.findPluginNameByCallerFile(callerFile);
      if (mappedSource) {
        pluginSource = mappedSource;
      }
    }

    if (pluginSource !== "core") {
      const manifest = this.registry.getManifestByName(pluginSource);
      if (!manifest || !manifest.emits.includes(type)) {
        const errorMsg = `Plugin "${pluginSource}" is not authorized to emit event "${type}". You must list it in the "emits" array in its shoperzz.plugin.yml manifest.`;
        this.logger.error(errorMsg);
        throw new Error(errorMsg);
      }
    }

    const event: ShoperzzEvent<TPayload> = {
      type,
      payload,
      timestamp: new Date(),
      pluginSource,
    };

    this.logger.debug(`Emitting event "${type}" from source "${pluginSource}"`);

    const listeners = this.emitter.listeners(type) as Array<(event: ShoperzzEvent<TPayload>) => void | Promise<void>>;

    for (const listener of listeners) {
      Promise.resolve()
        .then(() => listener(event))
        .catch((err: Error) => {
          this.logger.error(
            `Error executing handler for event "${type}" emitted by "${pluginSource}": ${err.message}`,
            err.stack,
          );
        });
    }
  }

  /**
   * Subscribes to an event pattern.
   * Enforces that the listening plugin has declared the event in its listens manifest.
   */
  public on<T extends Record<string, unknown> = Record<string, unknown>>(type: string, handler: ShoperzzEventHandler<ShoperzzEvent<T>>): void {
    this.registerListener(type, handler, false);
  }

  /**
   * Subscribes to an event pattern once.
   * Enforces that the listening plugin has declared the event in its listens manifest.
   */
  public once<T extends Record<string, unknown> = Record<string, unknown>>(type: string, handler: ShoperzzEventHandler<ShoperzzEvent<T>>): void {
    this.registerListener(type, handler, true);
  }

  /**
   * Synchronous Request/Response pattern over the EventBus.
   * Returns the value returned by the first registered handler.
   */
  public async request<TResponse = unknown, TPayload = unknown>(type: string, payload: TPayload): Promise<TResponse> {
    const callerFile = getCallerFile();
    let pluginSource = "core";

    if (callerFile) {
      const mappedSource = this.registry.findPluginNameByCallerFile(callerFile);
      if (mappedSource) {
        pluginSource = mappedSource;
      }
    }

    if (pluginSource !== "core") {
      const manifest = this.registry.getManifestByName(pluginSource);
      if (!manifest || !manifest.emits.includes(type)) {
        const errorMsg = `Plugin "${pluginSource}" is not authorized to request event "${type}". You must list it in the "emits" array in its shoperzz.plugin.yml manifest.`;
        this.logger.error(errorMsg);
        throw new Error(errorMsg);
      }
    }

    const event: ShoperzzEvent<TPayload> = {
      type,
      payload,
      timestamp: new Date(),
      pluginSource,
    };

    this.logger.debug(
      `Request-response event "${type}" initiated by "${pluginSource}"`,
    );

    const listeners = this.emitter.listeners(type) as Array<(event: ShoperzzEvent<TPayload>) => TResponse | Promise<TResponse>>;
    if (listeners.length === 0) {
      throw new Error(
        `No handler registered to process request event "${type}".`,
      );
    }

    return listeners[0]!(event);
  }

  private registerListener<T extends Record<string, unknown> = Record<string, unknown>>(
    type: string,
    handler: ShoperzzEventHandler<ShoperzzEvent<T>>,
    once: boolean,
  ): void {
    const callerFile = getCallerFile();
    let pluginSource = "core";

    if (callerFile) {
      const mappedSource = this.registry.findPluginNameByCallerFile(callerFile);
      if (mappedSource) {
        pluginSource = mappedSource;
      }
    }

    if (pluginSource !== "core") {
      const manifest = this.registry.getManifestByName(pluginSource);
      const isAllowed = isEventAllowed(type, manifest?.listens || []);
      if (!isAllowed) {
        const errorMsg = `Plugin "${pluginSource}" is not authorized to listen to event "${type}". You must list it in the "listens" array in its shoperzz.plugin.yml manifest.`;
        this.logger.error(errorMsg);
        throw new Error(errorMsg);
      }
    }

    const emitterHandler = handler as unknown as (...args: unknown[]) => void;
    if (once) {
      this.emitter.once(type, emitterHandler);
    } else {
      this.emitter.on(type, emitterHandler);
    }
  }
}
