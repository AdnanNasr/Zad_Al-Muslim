import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zad_al_muslim/core/l10n/app_localizations.dart';
import 'package:zad_al_muslim/core/services/app_update/app_update_model.dart';
import 'package:zad_al_muslim/core/services/app_update/app_update_providers.dart';

class UpdateDialog extends ConsumerStatefulWidget {
  const UpdateDialog({super.key, required this.update});
  final AppUpdateModel update;

  @override
  ConsumerState<UpdateDialog> createState() => _UpdateDialogState();
}

class _UpdateDialogState extends ConsumerState<UpdateDialog> {
  bool _loading = false;
  String? _error;

  Future<void> _update() async {
    if (_loading) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await ref.read(playStoreUpdateServiceProvider).startFlexibleUpdate();
      if (mounted) Navigator.of(context).pop();
    } catch (_) {
      if (!mounted) return;
      setState(() => _error = AppLocalizations.of(context)!.updateFailed);
      try {
        await ref
            .read(playStoreUpdateServiceProvider)
            .openStore(widget.update.storeUrl);
      } catch (_) {
        if (mounted) {
          setState(() => _error = AppLocalizations.of(context)!.storeOpenFailed);
        }
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      icon: const Icon(Icons.system_update_alt_rounded, size: 42),
      title: Text(widget.update.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(widget.update.message),
          if (_error != null) ...[
            const SizedBox(height: 12),
            Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: _loading ? null : () => Navigator.of(context).pop(),
          child: Text(l10n.updateLater),
        ),
        FilledButton(
          onPressed: _loading ? null : _update,
          child: _loading
              ? const SizedBox.square(
                  dimension: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(l10n.updateNow),
        ),
      ],
    );
  }
}
