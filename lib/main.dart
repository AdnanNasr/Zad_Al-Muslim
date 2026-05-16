import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zad_al_muslim/app_root.dart';
import 'package:zad_al_muslim/app_bootstrap.dart';

final GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  await AppBootstrap.init();

  runApp(
    ScreenUtilInit(
      minTextAdapt: true,
      designSize: const Size(392.72727272727275, 800.7272727272727),
      builder: (_, _) => const ProviderScope(child: AppRoot()),
    ),
  );
}
