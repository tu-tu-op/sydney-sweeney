import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/connector.dart';
import '../services/connector_service.dart';
import 'auth_provider.dart';

final connectorServiceProvider = Provider<ConnectorService>((ref) {
  return ConnectorService(api: ref.watch(apiClientProvider));
});

final connectorsProvider =
    AsyncNotifierProvider<ConnectorsController, List<Connector>>(
      ConnectorsController.new,
    );

class ConnectorsController extends AsyncNotifier<List<Connector>> {
  @override
  Future<List<Connector>> build() {
    return ref.watch(connectorServiceProvider).listConnectors();
  }

  Future<void> link(String connectorId) async {
    final current = state.asData?.value ?? const <Connector>[];
    state = AsyncValue.data([
      for (final connector in current)
        connector.id == connectorId
            ? connector.copyWith(status: ConnectorStatus.linking)
            : connector,
    ]);

    state = await AsyncValue.guard(() async {
      final linked = await ref
          .read(connectorServiceProvider)
          .linkConnector(connectorId);
      final latest = await ref.read(connectorServiceProvider).listConnectors();
      return [
        for (final connector in latest)
          connector.id == linked.id ? linked : connector,
      ];
    });
  }
}
