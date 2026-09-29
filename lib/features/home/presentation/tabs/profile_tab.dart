import 'package:flutter/material.dart';

import '../../../../core/strings.dart';
import '../../../../core/utils/snackbar.dart';
import '../../../../core/widgets/loading_overlay.dart';
import '../../../auth/data/auth_service.dart';
import '../../../auth/presentation/auth_scope.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key, required this.user});

  final AppUser user;

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  bool _signingOut = false;

  Future<void> _confirmSignOut() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.signOutTitle),
        content: const Text(AppStrings.signOutMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(AppStrings.signOut),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    setState(() => _signingOut = true);
    try {
      // AuthGate switches back to login when the auth stream emits null.
      await AuthScope.of(context).signOut();
    } catch (_) {
      if (mounted) {
        setState(() => _signingOut = false);
        showAppSnackBar(context, AppStrings.genericError);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final user = widget.user;
    final initial = (user.name.isNotEmpty ? user.name : user.email)
        .substring(0, 1)
        .toUpperCase();

    return LoadingOverlay(
      isLoading: _signingOut,
      child: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text(
              AppStrings.tabProfile,
              style: theme.textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: CircleAvatar(
                radius: 40,
                backgroundColor: scheme.primary.withValues(alpha: 0.12),
                child: Text(
                  initial,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: scheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              user.name,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              user.email,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 32),
            _Group(
              children: [
                _tile(Icons.person_outline_rounded, AppStrings.account),
                _tile(
                  Icons.notifications_none_rounded,
                  AppStrings.notifications,
                ),
                _tile(Icons.shield_outlined, AppStrings.privacy),
              ],
            ),
            const SizedBox(height: 16),
            _Group(
              children: [
                ListTile(
                  leading: Icon(Icons.logout_rounded, color: scheme.error),
                  title: Text(
                    AppStrings.signOut,
                    style: TextStyle(color: scheme.error),
                  ),
                  onTap: _signingOut ? null : _confirmSignOut,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _tile(IconData icon, String title) => ListTile(
    leading: Icon(icon),
    title: Text(title),
    trailing: const Icon(Icons.chevron_right_rounded),
    onTap: () => showAppSnackBar(context, AppStrings.comingSoon),
  );
}

/// iOS-style grouped list section.
class _Group extends StatelessWidget {
  const _Group({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surfaceContainerHigh,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) const Divider(indent: 56),
            children[i],
          ],
        ],
      ),
    );
  }
}
