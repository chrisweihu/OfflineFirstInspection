import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offline_first_inspection/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:offline_first_inspection/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:offline_first_inspection/features/inspection_form/presentation/blocs/inspection_table/inspection_table_bloc.dart';
import 'package:offline_first_inspection/init_dependencies.dart';
import 'package:offline_first_inspection/main_app.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  await initDependencies();

  // Ensure binding is initialized before accessing the cache
  //WidgetsFlutterBinding.ensureInitialized(); already called in initDependencies();

  // 1. SET MEMORY LIMIT (e.g., 50 MB instead of the default 100 MB)
  // This helps prevent OOM (Out Of Memory) crashes on low-end devices.
  PaintingBinding.instance.imageCache.maximumSizeBytes = 50 * 1024 * 1024;

  // 2. SET COUNT LIMIT (e.g., store only 100 images instead of 1000)
  // Fewer images in memory means faster eviction and lower RAM overhead.
  PaintingBinding.instance.imageCache.maximumSize = 100;

  if (kDebugMode) {
    final appDocumentsDir = await getApplicationDocumentsDirectory();
    debugPrint('${appDocumentsDir.absolute}');
  }

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<AuthBloc>()),
        BlocProvider(create: (_) => getIt<AppUserCubit>()),
        BlocProvider(create: (_) => getIt<InspectionTableBloc>()),
      ],
      child: const MainApp(),
    ),
  );
}
