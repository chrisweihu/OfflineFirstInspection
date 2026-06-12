import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offline_first_inspection/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:offline_first_inspection/core/theme/theme.dart';
import 'package:offline_first_inspection/features/auth/presentation/pages/login_page.dart';
import 'package:offline_first_inspection/features/home/home_page.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> with WidgetsBindingObserver {
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
    return MaterialApp(
      //showPerformanceOverlay: kDebugMode ? true : false,
      debugShowCheckedModeBanner: false,
      title: 'Offline Inspection',
      theme: AppTheme.darkThemeMode,
      home: BlocSelector<AppUserCubit, AppUserState, bool>(
        selector: (state) {
          //only trigger rebuild in the builder: if AppUserState value changed
          return state is AppUserLoggedInState;
        },
        //bool isUserLogged value comes from selector: (state){} return value
        builder: (context, isUserLogged) {
          if (isUserLogged) {
            return const HomePage();
          }
          return const LoginPage();
        },
      ),
    );
  }
}
