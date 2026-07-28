import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:zad_al_muslim/app_bootstrap.dart';
import 'package:zad_al_muslim/core/common/widgets/custom_navigation_bar.dart';
import 'package:zad_al_muslim/core/di/injection_container.dart' as di;
import 'package:zad_al_muslim/core/utils/location/location_locator.dart';
import 'package:zad_al_muslim/core/utils/location/providers/location_status_provider.dart';
import 'package:zad_al_muslim/features/splash/presentation/pages/onboarding/onboarding_init.dart';

class LocationStartupGate extends ConsumerStatefulWidget {
  const LocationStartupGate({super.key});

  @override
  ConsumerState<LocationStartupGate> createState() =>
      _LocationStartupGateState();
}

class _LocationStartupGateState extends ConsumerState<LocationStartupGate> {
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final cachedPosition = await di
          .sl<LocationLocatorImpl>()
          .getLocationCoords();
      if (cachedPosition != null && mounted) {
        await _initialize();
      } else if (await OnboardingInit.hasSkippedLocationPrompt() && mounted) {
        _goToHome();
      }
    });
  }

  void _goToHome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const CustomNavigationBar()),
    );
  }

  Future<void> _continueWithoutLocation() async {
    await OnboardingInit.markLocationPromptSkipped();
    if (!mounted) return;
    ref.read(locationStatusProvider.notifier).clearStatus();
    _goToHome();
  }

  Future<void> _initialize() async {
    if (_loading) return;
    setState(() {
      _loading = true;
      _error = null;
    });

    final error = await AppBootstrap.initLocationAndPrayers(
      context: context,
      container: ProviderScope.containerOf(context),
    );
    if (!mounted) return;

    if (error == null) {
      _goToHome();
      return;
    }

    setState(() {
      _loading = false;
      _error = error;
    });
  }

  Future<void> _openSettings() async {
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();
    } else {
      await Geolocator.openLocationSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: colors.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.location_on_rounded,
                    size: 48,
                    color: colors.primary,
                  ),
                ),
                const SizedBox(height: 28),
                Text(
                  'موقعك لحساب أوقات الصلاة',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'نستخدم موقعك مرةً لحساب مواقيت الصلاة واتجاه القبلة بدقة، '
                  'ثم نحفظ المواقيت على جهازك. لا تتم مشاركة موقعك.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    height: 1.7,
                    fontFamily: 'Cairo',
                  ),
                ),
                if (_error != null) ...[
                  const SizedBox(height: 20),
                  Text(
                    _error!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: colors.error,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton.icon(
                    onPressed: _loading ? null : _initialize,
                    icon: _loading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.my_location_rounded),
                    label: Text(
                      _loading ? 'جاري حساب أوقات الصلاة…' : 'السماح بالموقع',
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                if (_error != null)
                  TextButton(
                    onPressed: _openSettings,
                    child: const Text(
                      'فتح إعدادات الموقع',
                      style: TextStyle(fontFamily: 'Cairo'),
                    ),
                  ),
                TextButton(
                  onPressed: _loading ? null : _continueWithoutLocation,
                  child: const Text(
                    'المتابعة بدون مشاركة الموقع',
                    style: TextStyle(fontFamily: 'Cairo'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
