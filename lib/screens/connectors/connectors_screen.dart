import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../design/tokens.dart';
import '../../models/connector.dart';
import '../../providers/connectors_provider.dart';

class ConnectorsScreen extends ConsumerWidget {
  const ConnectorsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectors = ref.watch(connectorsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Connectors')),
      body: SafeArea(
        child: connectors.when(
          data:
              (items) => ListView.separated(
                padding: const EdgeInsets.all(SydneySpacing.page),
                itemCount: items.length + 1,
                separatorBuilder:
                    (_, _) => const SizedBox(height: SydneySpacing.md),
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: SydneySpacing.sm),
                      child: Text(
                        'Connectors are approved here, but tokens stay with the backend.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: SydneyColors.mutedInk,
                        ),
                      ),
                    );
                  }
                  return _ConnectorTile(connector: items[index - 1]);
                },
              ),
          loading: () => const _ConnectorLoading(),
          error: (error, _) => _ConnectorError(message: error.toString()),
        ),
      ),
    );
  }
}

class _ConnectorTile extends ConsumerWidget {
  const _ConnectorTile({required this.connector});

  final Connector connector;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final linking = connector.status == ConnectorStatus.linking;
    return Container(
      padding: const EdgeInsets.all(SydneySpacing.lg),
      decoration: BoxDecoration(
        color: SydneyColors.surfaceRaised,
        borderRadius: BorderRadius.circular(SydneyRadius.md),
        border: Border.all(color: SydneyColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _ConnectorIcon(name: connector.iconName),
              const SizedBox(width: SydneySpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      connector.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: SydneySpacing.xs),
                    _StatusLabel(status: connector.status),
                  ],
                ),
              ),
              if (!connector.isConnected)
                TextButton(
                  onPressed:
                      linking
                          ? null
                          : () => ref
                              .read(connectorsProvider.notifier)
                              .link(connector.id),
                  child: Text(linking ? 'Opening...' : 'Link'),
                ),
            ],
          ),
          const SizedBox(height: SydneySpacing.md),
          Text(
            connector.description,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: SydneyColors.mutedInk),
          ),
          if (connector.requiredScopes.isNotEmpty) ...[
            const SizedBox(height: SydneySpacing.md),
            Wrap(
              spacing: SydneySpacing.xs,
              runSpacing: SydneySpacing.xs,
              children: [
                for (final scope in connector.requiredScopes)
                  Chip(label: Text(scope)),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _ConnectorIcon extends StatelessWidget {
  const _ConnectorIcon({required this.name});

  final String? name;

  @override
  Widget build(BuildContext context) {
    final icon = switch (name) {
      'calendar' => Icons.calendar_month_outlined,
      'chat' => Icons.forum_outlined,
      _ => Icons.mail_outline_rounded,
    };
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: SydneyColors.primarySoft,
        borderRadius: BorderRadius.circular(SydneyRadius.md),
      ),
      child: Icon(icon, color: SydneyColors.primary),
    );
  }
}

class _StatusLabel extends StatelessWidget {
  const _StatusLabel({required this.status});

  final ConnectorStatus status;

  @override
  Widget build(BuildContext context) {
    final text = switch (status) {
      ConnectorStatus.connected => 'Connected',
      ConnectorStatus.disconnected => 'Not connected',
      ConnectorStatus.actionRequired => 'Needs review',
      ConnectorStatus.linking => 'Opening OAuth',
    };
    final color = switch (status) {
      ConnectorStatus.connected => SydneyColors.primary,
      ConnectorStatus.actionRequired => SydneyColors.warning,
      ConnectorStatus.linking => SydneyColors.info,
      ConnectorStatus.disconnected => SydneyColors.mutedInk,
    };
    return Text(
      text,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: color),
    );
  }
}

class _ConnectorLoading extends StatelessWidget {
  const _ConnectorLoading();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(SydneySpacing.page),
      itemBuilder:
          (_, _) => Container(
            height: 124,
            decoration: BoxDecoration(
              color: SydneyColors.surfaceRaised,
              borderRadius: BorderRadius.circular(SydneyRadius.md),
              border: Border.all(color: SydneyColors.line),
            ),
          ),
      separatorBuilder: (_, _) => const SizedBox(height: SydneySpacing.md),
      itemCount: 3,
    );
  }
}

class _ConnectorError extends StatelessWidget {
  const _ConnectorError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(SydneySpacing.page),
      child: Text(
        message,
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(color: SydneyColors.danger),
      ),
    );
  }
}
