import 'dart:async';

import '../config/env.dart';
import '../models/message.dart';

enum SydneySocketState { disconnected, connecting, connected }

class WebsocketService {
  final StreamController<Message> _messages = StreamController.broadcast();
  final StreamController<SydneySocketState> _state =
      StreamController.broadcast();

  SydneySocketState _currentState = SydneySocketState.disconnected;

  Stream<Message> get messages => _messages.stream;
  Stream<SydneySocketState> get states => _state.stream;
  SydneySocketState get currentState => _currentState;

  Future<void> connect({required String sessionToken}) async {
    _setState(SydneySocketState.connecting);
    await Future<void>.delayed(const Duration(milliseconds: 120));
    _setState(SydneySocketState.connected);
  }

  Future<void> subscribeToThread(String threadId) async {
    if (_currentState != SydneySocketState.connected) {
      return;
    }
  }

  void injectMockMessage(Message message) {
    if (Env.useMockData && !_messages.isClosed) {
      _messages.add(message);
    }
  }

  Future<void> disconnect() async {
    _setState(SydneySocketState.disconnected);
  }

  void dispose() {
    _messages.close();
    _state.close();
  }

  void _setState(SydneySocketState next) {
    _currentState = next;
    if (!_state.isClosed) {
      _state.add(next);
    }
  }
}
