import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offline_first_inspection/core/common/cubits/app_user/app_user_provider.dart';
import 'package:offline_first_inspection/core/theme/theme.dart';
import 'package:offline_first_inspection/features/auth/presentation/pages/login_page.dart';
import 'package:offline_first_inspection/features/home/home_page.dart';

class MainApp extends ConsumerStatefulWidget {
  const MainApp({super.key});

  @override
  ConsumerState<MainApp> createState() => _MainAppState();
}

class _MainAppState extends ConsumerState<MainApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (kDebugMode) {
      //debugRepaintRainbowEnabled = true;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (kDebugMode) {
      debugPrint("Lifecycle changed: $state");
    }
    //TODO: add app lifecycle state hanlder logic here
    switch (state) {
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.hidden:
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.detached:
        break;
    }
  }

  @override
  void didHaveMemoryPressure() {
    if (kDebugMode) {
      debugPrint("Low Memory Warning!");
    }
  }

  @override
  Widget build(BuildContext context) {
    final isUserLogged = ref.watch(
      appUserProvider.select((state) => state is AppUserLoggedInState),
    );

    return MaterialApp(
      //showPerformanceOverlay: kDebugMode ? true : false,
      debugShowCheckedModeBanner: false,
      title: 'Offline Inspection',
      theme: AppTheme.darkThemeMode,
      home: isUserLogged ? const HomePage() : const LoginPage(),
    );
  }
}
