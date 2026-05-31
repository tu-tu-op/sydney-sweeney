import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/routes.dart';
import '../../design/tokens.dart';
import '../../providers/agents_provider.dart';
import '../../services/agent_service.dart';
import 'create_screen.dart';

class ConfirmScreen extends ConsumerStatefulWidget {
  const ConfirmScreen({required this.draft, super.key});

  final AgentCreationDraft draft;

  @override
  ConsumerState<ConfirmScreen> createState() => _ConfirmScreenState();
}

class _ConfirmScreenState extends ConsumerState<ConfirmScreen> {
  bool _creating = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Confirm')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(SydneySpacing.page),
          children: [
            Text(
              'This agent will start simple',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: SydneySpacing.sm),
            Text(
              'You can add connectors after it exists. Sydney only asks for access when it is needed.',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: SydneyColors.mutedInk),
            ),
            const SizedBox(height: SydneySpacing.xl),
            Container(
              padding: const EdgeInsets.all(SydneySpacing.lg),
              decoration: BoxDecoration(
                color: SydneyColors.surfaceRaised,
                borderRadius: BorderRadius.circular(SydneyRadius.md),
                border: Border.all(color: SydneyColors.line),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SummaryRow(
                    icon: Icons.chat_bubble_outline_rounded,
                    title: 'What it does',
                    body: widget.draft.prompt,
                  ),
                  const SizedBox(height: SydneySpacing.lg),
                  const _SummaryRow(
                    icon: Icons.schedule_rounded,
                    title: 'When it runs',
                    body:
                        'When new approved context arrives, plus whenever you message it.',
                  ),
                  const SizedBox(height: SydneySpacing.lg),
                  _SummaryRow(
                    icon: Icons.lock_outline_rounded,
                    title: 'What it needs',
                    body:
                        '${widget.draft.templateLabel} context and connectors you approve later.',
                  ),
                ],
              ),
            ),
            const SizedBox(height: SydneySpacing.xxl),
            FilledButton.icon(
              onPressed: _creating ? null : _create,
              icon: const Icon(Icons.check_rounded),
              label: Text(_creating ? 'Creating...' : 'Create agent'),
            ),
            const SizedBox(height: SydneySpacing.sm),
            TextButton(
              onPressed: _creating ? null : () => Navigator.of(context).pop(),
              child: const Text('Edit sentence'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _create() async {
    setState(() => _creating = true);
    var didNavigate = false;
    try {
      final agent = await ref
          .read(agentsProvider.notifier)
          .createAgent(
            CreateAgentRequest(
              prompt: widget.draft.prompt,
              templateId: widget.draft.templateId,
            ),
          );
      if (!mounted) {
        return;
      }
      didNavigate = true;
      Navigator.of(context).pushNamedAndRemoveUntil(
        AppRoutes.thread,
        (route) => route.settings.name == AppRoutes.inbox,
        arguments: agent,
      );
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.toString())));
    } finally {
      if (mounted && !didNavigate) {
        setState(() => _creating = false);
      }
    }
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: SydneyColors.primarySoft,
            borderRadius: BorderRadius.circular(SydneyRadius.sm),
          ),
          child: Icon(icon, color: SydneyColors.primary, size: 20),
        ),
        const SizedBox(width: SydneySpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: SydneySpacing.xs),
              Text(
                body,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: SydneyColors.mutedInk),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
