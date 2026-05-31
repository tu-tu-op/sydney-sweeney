# Sydney Flutter Frontend

Mobile-first Flutter frontend scaffold for Sydney, an AI delegation messaging app.

## Scope

- Frontend only.
- Backend APIs are assumed to exist over REST and WebSocket.
- The app stores only the Sydney session token in `flutter_secure_storage`.
- Connector OAuth is initiated in-app, but connector tokens must remain backend-owned.
- Agent outputs are rendered as structured messages.

## Local Setup

Install Flutter, then run:

```sh
flutter pub get
flutter run
```

Useful runtime config:

```sh
flutter run \
  --dart-define=SYDNEY_API_BASE_URL=https://api.example.com/v1 \
  --dart-define=SYDNEY_WEBSOCKET_URL=wss://api.example.com/realtime \
  --dart-define=SYDNEY_CONNECTOR_CALLBACK_SCHEME=sydney \
  --dart-define=SYDNEY_USE_MOCKS=true
```

If platform folders are not present yet, generate them with the Flutter SDK before mobile builds. Android should be treated as the first target, with Firebase configuration and the `flutter_web_auth_2` callback activity added during native setup.
