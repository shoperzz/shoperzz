// Base shape of every event flowing through the ShoperzzEventBus.
//
// Rules enforced by the PluginRegistry:
//   - `type` must match a value declared in the emitting plugin's manifest (emits[]).
//   - `pluginSource` must be the plugin's canonical npm package name.
//   - Payload is typed per event via the generic parameter.
//
// Example — defining a concrete event:
//
//   interface PaymentConfirmedPayload {
//     orderId: string
//     amount: number
//     currency: 'XOF' | 'XAF'
//     customerPhone: string
//   }
//
//   type PaymentConfirmedEvent = ShoperzzEvent<PaymentConfirmedPayload>
//
export interface ShoperzzEvent<T = Record<string, unknown>> {
  // Unique event identifier. Format: "domain.plugin-slug.action"
  // Example: "payment.orange-money.confirmed"
  readonly type: string

  readonly payload: T
  readonly timestamp: Date

  // The canonical npm package name of the emitting plugin.
  // Example: "@shoperzz/plugin-payment-orange-money"
  readonly pluginSource: string
}

// Extracts payload type from a ShoperzzEvent.
// Useful when writing handlers that infer their input type from the event type.
export type EventPayload<E extends ShoperzzEvent> = E['payload']

// Signature of an event handler registered on the EventBus.
// Handlers can be async — the bus awaits them before processing the next event.
export type ShoperzzEventHandler<E extends ShoperzzEvent = ShoperzzEvent> = (
  event: E,
) => void | Promise<void>
