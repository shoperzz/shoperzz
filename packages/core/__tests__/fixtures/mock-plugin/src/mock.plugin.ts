class DummyNestModule {}

export class MockFixturePlugin {
  static label = "Mock Fixture";
  static description = "Mock fixture plugin for testing registry resolution";
  static version = "1.0.0";

  static init(options: unknown) {
    return this;
  }

  static getNestModule() {
    return DummyNestModule;
  }
}
