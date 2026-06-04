// Generic constructor type used across packages to avoid importing from @nestjs/common.
// This keeps @shoperzz/common dependency-free while still expressing NestJS DI patterns.
// Constructor args are unknown[] — NestJS resolves them via its DI container.
export interface Type<T = unknown> {
  new (...args: unknown[]): T;
}

// Makes all properties of T recursively readonly.
// Useful for config objects that should never be mutated after creation.
export type DeepReadonly<T> = {
  readonly [K in keyof T]: T[K] extends object ? DeepReadonly<T[K]> : T[K];
};

// Makes specific keys of T required while keeping the rest unchanged.
export type RequireKeys<T, K extends keyof T> = T & Required<Pick<T, K>>;
