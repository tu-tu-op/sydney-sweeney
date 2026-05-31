import 'package:flutter/material.dart';

import '../../config/routes.dart';
import '../../design/tokens.dart';

class AgentCreationDraft {
  const AgentCreationDraft({
    required this.prompt,
    required this.templateId,
    required this.templateLabel,
  });

  final String prompt;
  final String templateId;
  final String templateLabel;
}

class CreateScreen extends StatefulWidget {
  const CreateScreen({super.key});

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  final _promptController = TextEditingController();
  String _selectedTemplate = _shortcuts.first.id;
  String? _error;

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selected = _shortcuts.firstWhere(
      (shortcut) => shortcut.id == _selectedTemplate,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('New agent')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(SydneySpacing.page),
          children: [
            Text(
              'What should this agent handle?',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: SydneySpacing.sm),
            Text(
              'Use one direct sentence. You can adjust details before creating it.',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: SydneyColors.mutedInk),
            ),
            const SizedBox(height: SydneySpacing.xl),
            TextField(
              controller: _promptController,
              minLines: 3,
              maxLines: 6,
              textInputAction: TextInputAction.newline,
              decoration: const InputDecoration(
                hintText:
                    'Watch my customer escalations and brief me each morning.',
              ),
              onChanged: (_) {
                if (_error != null) {
                  setState(() => _error = null);
                }
              },
            ),
            if (_error != null) ...[
              const SizedBox(height: SydneySpacing.sm),
              Text(
                _error!,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: SydneyColors.danger),
              ),
            ],
            const SizedBox(height: SydneySpacing.xl),
            Text('Shortcuts', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: SydneySpacing.md),
            Wrap(
              spacing: SydneySpacing.sm,
              runSpacing: SydneySpacing.sm,
              children: [
                for (final shortcut in _shortcuts)
                  ChoiceChip(
                    selected: shortcut.id == _selectedTemplate,
                    avatar: Icon(shortcut.icon, size: 18),
                    label: Text(shortcut.label),
                    onSelected: (_) {
                      setState(() => _selectedTemplate = shortcut.id);
                    },
                  ),
              ],
            ),
            const SizedBox(height: SydneySpacing.xl),
            Container(
              padding: const EdgeInsets.all(SydneySpacing.lg),
              decoration: BoxDecoration(
                color: SydneyColors.surfaceWarm,
                borderRadius: BorderRadius.circular(SydneyRadius.md),
              ),
              child: Text(
                selected.hint,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: SydneySpacing.xxl),
            FilledButton.icon(
              onPressed: _continue,
              icon: const Icon(Icons.arrow_forward_rounded),
              label: const Text('Review agent'),
            ),
          ],
        ),
      ),
    );
  }

  void _continue() {
    final prompt = _promptController.text.trim();
    if (prompt.isEmpty) {
      setState(() => _error = 'Write one sentence before continuing.');
      return;
    }
    final selected = _shortcuts.firstWhere(
      (shortcut) => shortcut.id == _selectedTemplate,
    );
    Navigator.of(context).pushNamed(
      AppRoutes.confirmCreate,
      arguments: AgentCreationDraft(
        prompt: prompt,
        templateId: selected.id,
        templateLabel: selected.label,
      ),
    );
  }
}

class _TemplateShortcut {
  const _TemplateShortcut({
    required this.id,
    required this.label,
    required this.hint,
    required this.icon,
  });

  final String id;
  final String label;
  final String hint;
  final IconData icon;
}

const _shortcuts = [
  _TemplateShortcut(
    id: 'summary',
    label: 'Summarize',
    hint: 'Best for digesting emails, notes, channels, or recurring updates.',
    icon: Icons.notes_rounded,
  ),
  _TemplateShortcut(
    id: 'tracker',
    label: 'Track progress',
    hint: 'Best for projects, deadlines, approvals, and recurring check-ins.',
    icon: Icons.track_changes_rounded,
  ),
  _TemplateShortcut(
    id: 'urgent',
    label: 'Flag urgency',
    hint: 'Best for priority lists, escalations, risks, and fast triage.',
    icon: Icons.priority_high_rounded,
  ),
  _TemplateShortcut(
    id: 'checklist',
    label: 'Checklist',
    hint: 'Best for repeatable routines where every step should be visible.',
    icon: Icons.checklist_rounded,
  ),
];
