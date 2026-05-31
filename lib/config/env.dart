class Env {
  const Env._();

  static const apiBaseUrl = String.fromEnvironment(
    'SYDNEY_API_BASE_URL',
    defaultValue: 'https://api.sydney.local/v1',
  );

  static const websocketUrl = String.fromEnvironment(
    'SYDNEY_WEBSOCKET_URL',
    defaultValue: 'wss://api.sydney.local/realtime',
  );

  static const connectorCallbackScheme = String.fromEnvironment(
    'SYDNEY_CONNECTOR_CALLBACK_SCHEME',
    defaultValue: 'sydney',
  );

  static const useMockData = bool.fromEnvironment(
    'SYDNEY_USE_MOCKS',
    defaultValue: true,
  );
}
