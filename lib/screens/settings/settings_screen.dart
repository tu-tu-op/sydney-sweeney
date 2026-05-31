import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/routes.dart';
import '../../design/tokens.dart';
import '../../providers/auth_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _configuringPush = false;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authControllerProvider).asData?.value.user;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(SydneySpacing.page),
          children: [
            Text(
              user?.displayName ?? 'Sydney user',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: SydneySpacing.xs),
            Text(
              user?.email ?? 'Signed in',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: SydneyColors.mutedInk),
            ),
            const SizedBox(height: SydneySpacing.xl),
            _SettingsAction(
              icon: Icons.notifications_outlined,
              title: 'Push notifications',
              body:
                  _configuringPush
                      ? 'Checking permission...'
                      : 'Enable message and agent status alerts.',
              trailing: TextButton(
                onPressed: _configuringPush ? null : _configurePush,
                child: const Text('Enable'),
              ),
            ),
            const SizedBox(height: SydneySpacing.md),
            _SettingsAction(
              icon: Icons.hub_outlined,
              title: 'Connectors',
              body: 'Review accounts approved for backend access.',
              trailing: IconButton(
                tooltip: 'Open connectors',
                onPressed:
                    () => Navigator.of(context).pushNamed(AppRoutes.connectors),
                icon: const Icon(Icons.chevron_right_rounded),
              ),
            ),
            const SizedBox(height: SydneySpacing.md),
            const _SettingsAction(
              icon: Icons.security_outlined,
              title: 'Session storage',
              body: 'This app stores only your Sydney session token on device.',
            ),
            const SizedBox(height: SydneySpacing.xxl),
            OutlinedButton.icon(
              onPressed: _signOut,
              icon: const Icon(Icons.logout_rounded),
              label: const Text('Sign out'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _configurePush() async {
    setState(() => _configuringPush = true);
    try {
      final result = await ref.read(pushServiceProvider).configure();
      if (!mounted) {
        return;
      }
      final message =
          result.isEnabled
              ? 'Push notifications are enabled.'
              : 'Push notifications were not approved.';
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.toString())));
    } finally {
      if (mounted) {
        setState(() => _configuringPush = false);
      }
    }
  }

  Future<void> _signOut() async {
    await ref.read(authControllerProvider.notifier).signOut();
    if (!mounted) {
      return;
    }
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(AppRoutes.signIn, (route) => false);
  }
}

class _SettingsAction extends StatelessWidget {
  const _SettingsAction({
    required this.icon,
    required this.title,
    required this.body,
    this.trailing,
  });

  final IconData icon;
  final String title;
  final String body;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(SydneySpacing.lg),
      decoration: BoxDecoration(
        color: SydneyColors.surfaceRaised,
        borderRadius: BorderRadius.circular(SydneyRadius.md),
        border: Border.all(color: SydneyColors.line),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: SydneyColors.primary),
          const SizedBox(width: SydneySpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: SydneySpacing.xs),
                Text(
                  body,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: SydneyColors.mutedInk,
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: SydneySpacing.sm),
            trailing!,
          ],
        ],
      ),
    );
  }
}
