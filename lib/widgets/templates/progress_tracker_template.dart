import 'package:flutter/material.dart';

import '../../design/tokens.dart';

class ProgressTrackerTemplate extends StatelessWidget {
  const ProgressTrackerTemplate({required this.data, super.key});

  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    final title = data['title']?.toString() ?? 'Progress';
    final steps = _maps(data['steps']);
    final total = _number(data['total']) ?? steps.length;
    final current =
        _number(data['current']) ??
        steps.where((step) => step['done'] == true).length;
    final progress =
        total <= 0 ? 0.0 : (current / total).clamp(0.0, 1.0).toDouble();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: SydneySpacing.md),
        ClipRRect(
          borderRadius: BorderRadius.circular(SydneyRadius.full),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 7,
            color: SydneyColors.primary,
            backgroundColor: SydneyColors.primarySoft,
          ),
        ),
        const SizedBox(height: SydneySpacing.sm),
        Text(
          '$current of $total complete',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        if (steps.isNotEmpty) ...[
          const SizedBox(height: SydneySpacing.md),
          for (final step in steps)
            Padding(
              padding: const EdgeInsets.only(bottom: SydneySpacing.sm),
              child: Row(
                children: [
                  Icon(
                    step['done'] == true
                        ? Icons.check_circle_rounded
                        : Icons.radio_button_unchecked_rounded,
                    color:
                        step['done'] == true
                            ? SydneyColors.primary
                            : SydneyColors.subtleInk,
                    size: 18,
                  ),
                  const SizedBox(width: SydneySpacing.sm),
                  Expanded(
                    child: Text(
                      step['label']?.toString() ?? 'Untitled step',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ],
    );
  }
}

int? _number(Object? value) {
  if (value is int) {
    return value;
  }
  if (value is num) {
    return value.toInt();
  }
  if (value is String) {
    return int.tryParse(value);
  }
  return null;
}

List<Map<String, dynamic>> _maps(Object? value) {
  if (value is! List) {
    return const [];
  }
  return value
      .whereType<Map>()
      .map((item) => Map<String, dynamic>.from(item))
      .toList();
}
