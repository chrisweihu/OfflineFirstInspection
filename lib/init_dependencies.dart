import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:offline_first_inspection/core/network/connection_checker.dart';
import 'package:offline_first_inspection/core/secrets/app_secrets.dart';
import 'package:offline_first_inspection/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:offline_first_inspection/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:offline_first_inspection/features/auth/domain/repository/auth_repository.dart';
import 'package:offline_first_inspection/features/auth/domain/usecases/current_user.dart';
import 'package:offline_first_inspection/features/auth/domain/usecases/user_login.dart';
import 'package:offline_first_inspection/features/auth/domain/usecases/user_sign_up.dart';
import 'package:offline_first_inspection/features/inspection_form/data/database.dart';
import 'package:offline_first_inspection/features/inspection_form/data/datasources/inspection_form_local_data_source.dart';
import 'package:offline_first_inspection/features/inspection_form/data/datasources/inspection_form_remote_data_source.dart';
import 'package:offline_first_inspection/features/inspection_form/data/repositories/inspection_form_repository_impl.dart';
import 'package:offline_first_inspection/features/inspection_form/domain/repositories/inspection_form_repository.dart';
import 'package:offline_first_inspection/features/inspection_form/domain/usecases/get_all_inspection_forms.dart';
import 'package:offline_first_inspection/features/inspection_form/domain/usecases/submit_inspection_form.dart';
import 'package:offline_first_inspection/features/inspection_form/domain/usecases/sync_inspection_forms.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get_it/get_it.dart';

// Create a global instance (or use GetIt.instance)
final getIt = GetIt.instance;

Future<void> initDependencies() async {
  //must ensure WidgetsFlutterBinding.ensureInitialized()
  //and the Supabase init are fully awaited before the UI tries to fire that first query.
  WidgetsFlutterBinding.ensureInitialized();

  var supabase = await Supabase.initialize(url: AppSecrets.supabaseUrl, publishableKey: AppSecrets.supabaseAnnoKey);

  getIt.registerLazySingleton<SupabaseClient>(() => supabase.client);

  //core
  getIt.registerLazySingleton<AppDatabase>(() => AppDatabase());

  _initAuth();
  _initInspectionForm();
}

void _initAuth() {
  getIt
    //DateSource
    ..registerFactory<IAuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(getIt<SupabaseClient>()))
    //Repositories
    ..registerFactory<InternetConnection>(() => InternetConnection())
    ..registerFactory<IConnectionChecker>(() => ConnectionCheckerImpl(getIt<InternetConnection>()))
    ..registerFactory<IAuthRepository>(() => AuthRepositoryImpl(getIt<IAuthRemoteDataSource>(), getIt<IConnectionChecker>()))
    //UseCase
    ..registerFactory(() => UserSignUp(getIt<IAuthRepository>()))
    ..registerFactory(() => UserLogin(getIt<IAuthRepository>()))
    ..registerFactory(() => CurrentUser(getIt<IAuthRepository>()));
}

void _initInspectionForm() {
  getIt
    //DateSource
    ..registerFactory<IInspectionFormLocalDataSource>(() => InspectionFormLocalDataSourceImpl(database: getIt<AppDatabase>()))
    ..registerFactory<IInspectionFormRemoteDataSource>(() => InspectionFormRemoteDataSourceImpl(supabaseClient: getIt<SupabaseClient>()))
    //Repositories
    ..registerFactory<IInspectionFormRepository>(
      () => InspectionFormRepositoryImpl(
        remoteDataSource: getIt<IInspectionFormRemoteDataSource>(),
        localDataSource: getIt<IInspectionFormLocalDataSource>(),
        connectionChecker: getIt<IConnectionChecker>(),
      ),
    )
    //Use cases
    ..registerFactory<GetAllLocalInspectionForms>(() => GetAllLocalInspectionForms(repo: getIt<IInspectionFormRepository>()))
    ..registerFactory<SubmitInspectionForm>(() => SubmitInspectionForm(repo: getIt<IInspectionFormRepository>()))
    ..registerFactory<SyncInspectionForms>(() => SyncInspectionForms(repo: getIt<IInspectionFormRepository>()));
}
