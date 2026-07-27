import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zad_al_muslim/core/services/app_update/app_update_model.dart';
import 'package:zad_al_muslim/core/services/app_update/app_update_providers.dart';
import 'package:zad_al_muslim/core/services/app_update/update_dialog.dart';
import 'package:zad_al_muslim/core/services/app_update/update_required_page.dart';
import 'package:zad_al_muslim/core/utils/log/app_logger.dart';

class AppUpdateGate extends ConsumerStatefulWidget {
  const AppUpdateGate({super.key, required this.child});
  final Widget child;

  @override
  ConsumerState<AppUpdateGate> createState() => _AppUpdateGateState();
}

class _AppUpdateGateState extends ConsumerState<AppUpdateGate>
    with WidgetsBindingObserver {
  bool _optionalDialogShown = false;
  bool _resumeCheckInProgress = false;
  AppUpdateModel? _lastTrustedRequired;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _recheckOnResume();
  }

  Future<void> _recheckOnResume() async {
    if (_resumeCheckInProgress) return;
    _resumeCheckInProgress = true;
    try {
      await ref.read(appUpdateProvider.notifier).recheck();
    } finally {
      _resumeCheckInProgress = false;
    }
  }

  void _showOptionalOnce(AppUpdateModel update) {
    if (_optionalDialogShown) return;
    _optionalDialogShown = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (_) => UpdateDialog(update: update),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(appUpdateProvider);
    return state.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stackTrace) {
        AppLogger.logger.e(
          'فشل فحص تحديث التطبيق: $error',
          stackTrace: stackTrace,
        );
        return _lastTrustedRequired == null
            ? widget.child
            : UpdateRequiredPage(update: _lastTrustedRequired!);
      },
      data: (update) {
        if (update.isRequired && update.fromTrustedRemoteValue) {
          _lastTrustedRequired = update;
        }
        if (update.isRequired) return UpdateRequiredPage(update: update);
        if (update.type == AppUpdateType.optional) {
          _showOptionalOnce(update);
        }
        return widget.child;
      },
    );
  }
}
