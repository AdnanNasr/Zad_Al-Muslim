import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zad_al_muslim/core/l10n/app_localizations.dart';
import 'package:zad_al_muslim/core/services/app_update/app_update_model.dart';
import 'package:zad_al_muslim/core/services/app_update/app_update_providers.dart';

class UpdateRequiredPage extends ConsumerStatefulWidget {
  const UpdateRequiredPage({super.key, required this.update});
  final AppUpdateModel update;

  @override
  ConsumerState<UpdateRequiredPage> createState() => _UpdateRequiredPageState();
}

class _UpdateRequiredPageState extends ConsumerState<UpdateRequiredPage> {
  bool _loading = false;
  bool _showStoreButton = false;
  String? _error;

  Future<void> _startUpdate() async {
    if (_loading) return;
    setState(() {
      _loading = true;
      _error = null;
      _showStoreButton = false;
    });
    try {
      await ref.read(playStoreUpdateServiceProvider).startImmediateUpdate();
    } catch (_) {
      if (mounted) {
        setState(() {
          _error = AppLocalizations.of(context)!.updateFailed;
          _showStoreButton = true;
        });
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _openStore() async {
    if (_loading) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await ref
          .read(playStoreUpdateServiceProvider)
          .openStore(widget.update.storeUrl);
    } catch (_) {
      if (mounted) {
        setState(() => _error = AppLocalizations.of(context)!.storeOpenFailed);
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(28),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.security_update_good_rounded,
                        size: 88, color: colors.primary),
                    const SizedBox(height: 24),
                    Text(widget.update.title,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 12),
                    Text(widget.update.message, textAlign: TextAlign.center),
                    if (_error != null) ...[
                      const SizedBox(height: 16),
                      Text(_error!,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: colors.error)),
                    ],
                    const SizedBox(height: 28),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: _loading ? null : _startUpdate,
                        icon: _loading
                            ? const SizedBox.square(
                                dimension: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.download_rounded),
                        label: Text(l10n.updateApp),
                      ),
                    ),
                    if (_showStoreButton) ...[
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: _loading ? null : _openStore,
                          icon: const Icon(Icons.open_in_new_rounded),
                          label: Text(l10n.openGooglePlay),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
