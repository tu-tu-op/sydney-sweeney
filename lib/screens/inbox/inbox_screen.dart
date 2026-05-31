import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/routes.dart';
import '../../design/tokens.dart';
import '../../models/agent.dart';
import '../../providers/agents_provider.dart';
import '../../widgets/inbox/agent_tile.dart';

class InboxScreen extends ConsumerWidget {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final agents = ref.watch(agentsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sydney'),
        actions: [
          IconButton(
            tooltip: 'Connectors',
            onPressed:
                () => Navigator.of(context).pushNamed(AppRoutes.connectors),
            icon: const Icon(Icons.hub_outlined),
          ),
          IconButton(
            tooltip: 'Settings',
            onPressed:
                () => Navigator.of(context).pushNamed(AppRoutes.settings),
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          color: SydneyColors.primary,
          onRefresh: () => ref.read(agentsProvider.notifier).refresh(),
          child: agents.when(
            data: (items) => _InboxList(agents: items),
            loading: () => const _InboxLoading(),
            error:
                (error, _) => _InboxError(
                  message: error.toString(),
                  onRetry: () => ref.read(agentsProvider.notifier).refresh(),
                ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: SydneyColors.primary,
        foregroundColor: Colors.white,
        onPressed: () => Navigator.of(context).pushNamed(AppRoutes.create),
        icon: const Icon(Icons.add_rounded),
        label: const Text('New'),
      ),
    );
  }
}

class _InboxList extends StatelessWidget {
  const _InboxList({required this.agents});

  final List<Agent> agents;

  @override
  Widget build(BuildContext context) {
    final visibleAgents = agents.isEmpty ? [_assistantFallback()] : agents;
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        SydneySpacing.page,
        SydneySpacing.sm,
        SydneySpacing.page,
        96,
      ),
      itemCount: visibleAgents.length + (visibleAgents.length == 1 ? 1 : 0),
      separatorBuilder: (_, index) {
        if (index >= visibleAgents.length - 1) {
          return const SizedBox(height: SydneySpacing.lg);
        }
        return const Divider(height: 1, indent: 68);
      },
      itemBuilder: (context, index) {
        if (index >= visibleAgents.length) {
          return const _WarmInvitation();
        }
        final agent = visibleAgents[index];
        return AgentTile(
          agent: agent,
          onTap:
              () => Navigator.of(
                context,
              ).pushNamed(AppRoutes.thread, arguments: agent),
        );
      },
    );
  }
}

class _WarmInvitation extends StatelessWidget {
  const _WarmInvitation();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(SydneySpacing.lg),
      decoration: BoxDecoration(
        color: SydneyColors.surfaceWarm,
        borderRadius: BorderRadius.circular(SydneyRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Start with one sentence',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: SydneySpacing.xs),
          Text(
            'Create an agent for something you want watched, summarized, or prepared.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: SydneyColors.mutedInk),
          ),
        ],
      ),
    );
  }
}

class _InboxLoading extends StatelessWidget {
  const _InboxLoading();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(SydneySpacing.page),
      itemCount: 4,
      separatorBuilder: (_, _) => const SizedBox(height: SydneySpacing.lg),
      itemBuilder: (context, index) {
        return Container(
          height: 64,
          decoration: BoxDecoration(
            color: SydneyColors.surfaceRaised,
            borderRadius: BorderRadius.circular(SydneyRadius.md),
            border: Border.all(color: SydneyColors.line),
          ),
        );
      },
    );
  }
}

class _InboxError extends StatelessWidget {
  const _InboxError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(SydneySpacing.page),
      children: [
        Text(
          'Messages could not load',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: SydneySpacing.sm),
        Text(
          message,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: SydneyColors.mutedInk),
        ),
        const SizedBox(height: SydneySpacing.lg),
        FilledButton(onPressed: onRetry, child: const Text('Try again')),
      ],
    );
  }
}

Agent _assistantFallback() {
  return Agent(
    id: 'assistant',
    threadId: 'thread_assistant',
    name: 'Assistant',
    avatarInitials: 'S',
    description: 'Your home base for delegation.',
    lastMessagePreview: 'Create your first agent when you are ready.',
    latestMessageAt: DateTime.now(),
    isAssistant: true,
    isPinned: true,
  );
}
