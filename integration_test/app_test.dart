import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:offline_first_inspection/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:offline_first_inspection/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:offline_first_inspection/features/inspection_form/presentation/blocs/inspection_table/inspection_table_bloc.dart';
import 'package:offline_first_inspection/init_dependencies.dart';
import 'package:integration_test/integration_test.dart';
import 'package:offline_first_inspection/main_app.dart';

Future<void> main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  await initDependencies();

  group('end-to-end test', () {
    testWidgets('tap on the floating action button, verify counter', (tester) async {
      // Load app widget.
      final blocProviders = MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => getIt<AuthBloc>()),
          BlocProvider(create: (_) => getIt<AppUserCubit>()),
          BlocProvider(create: (_) => getIt<InspectionTableBloc>()),
        ],
        child: const MainApp(),
      );

      await tester.pumpWidget(blocProviders);

      // Trigger a 3 secs wait.
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verify the counter starts at 0.
      expect(find.text('Sign In'), findsOneWidget);

      expect(find.text('Email'), findsOneWidget);
      // Tap the add button.
      await tester.enterText(find.byKey(const ValueKey('login_email')), '*******@gmail.com');

      // Rebuild the widget after the state has changed.
      await tester.pumpAndSettle();

      // Tap the add button.
      await tester.enterText(find.byKey(const ValueKey('login_password')), '*****');

      // Rebuild the widget after the state has changed.
      await tester.pumpAndSettle();

      // Tap the add button.
      await tester.tap(find.text('Log In'));

      // Trigger a 3 secs wait.
      await tester.pumpAndSettle(const Duration(seconds: 5));

      //Verify the counter increments by 1.
      expect(find.text('Inspections List'), findsOneWidget);
    });
  });
}
