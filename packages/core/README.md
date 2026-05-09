# Core (@shoperzz/core)

The brain of Shoperzz. A headless package based on NestJS and Vendure.

## Responsibilities
- **Plugin Registry**: Dynamic loading and isolation of plugin modules.
- **Event Bus**: Asynchronous messaging system for inter-plugin communication.
- **Vendure Engine**: Integration and extension of the core commerce engine.
- **GraphQL Schema**: Unification of Admin and Shop API schemas.

## Role
It provides the API and business logic that everything else depends on.