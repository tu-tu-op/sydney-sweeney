import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../design/tokens.dart';
import '../../models/agent.dart';
import '../../providers/messages_provider.dart';
import '../../widgets/thread/message_bubble.dart';
import '../../widgets/thread/reply_bar.dart';
import '../../widgets/thread/typing_indicator.dart';

class ThreadScreen extends ConsumerStatefulWidget {
  const ThreadScreen({required this.agent, super.key});

  final Agent agent;

  @override
  ConsumerState<ThreadScreen> createState() => _ThreadScreenState();
}

class _ThreadScreenState extends ConsumerState<ThreadScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(messageActionsProvider).connectLiveUpdates(),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(messagesProvider(widget.agent.threadId));

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: Color(
                widget.agent.accentColor,
              ).withValues(alpha: 0.12),
              child: Text(
                widget.agent.avatarInitials,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Color(widget.agent.accentColor),
                ),
              ),
            ),
            const SizedBox(width: SydneySpacing.md),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.agent.name,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    widget.agent.availability == AgentAvailability.thinking
                        ? 'Working'
                        : 'Ready',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: messages.when(
                data:
                    (items) => ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.fromLTRB(
                        SydneySpacing.page,
                        SydneySpacing.lg,
                        SydneySpacing.page,
                        SydneySpacing.lg,
                      ),
                      itemCount: items.length + 1,
                      itemBuilder: (context, index) {
                        if (index == items.length) {
                          return widget.agent.availability ==
                                  AgentAvailability.thinking
                              ? const TypingIndicator()
                              : const SizedBox.shrink();
                        }
                        return MessageBubble(message: items[index]);
                      },
                    ),
                loading: () => const _ThreadLoading(),
                error: (error, _) => _ThreadError(message: error.toString()),
              ),
            ),
            ReplyBar(onSend: _sendReply),
          ],
        ),
      ),
    );
  }

  Future<void> _sendReply(String text) async {
    try {
      await ref
          .read(messageActionsProvider)
          .sendReply(threadId: widget.agent.threadId, text: text);
      await Future<void>.delayed(const Duration(milliseconds: 80));
      if (_scrollController.hasClients) {
        await _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
        );
      }
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }
}

class _ThreadLoading extends StatelessWidget {
  const _ThreadLoading();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(SydneySpacing.page),
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            width: 220,
            height: 72,
            decoration: BoxDecoration(
              color: SydneyColors.surfaceRaised,
              borderRadius: SydneyRadius.bubbleAgent,
              border: Border.all(color: SydneyColors.line),
            ),
          ),
        ),
        const SizedBox(height: SydneySpacing.lg),
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            width: 180,
            height: 54,
            decoration: const BoxDecoration(
              color: SydneyColors.userBubble,
              borderRadius: SydneyRadius.bubbleUser,
            ),
          ),
        ),
      ],
    );
  }
}

class _ThreadError extends StatelessWidget {
  const _ThreadError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(SydneySpacing.page),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Conversation could not load',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: SydneySpacing.sm),
          Text(
            message,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: SydneyColors.mutedInk),
          ),
        ],
      ),
    );
  }
}
