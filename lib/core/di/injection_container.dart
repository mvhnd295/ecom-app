import 'package:fitflow/core/network/network_info.dart';
import 'package:fitflow/core/services/api/api_service.dart';
import 'package:fitflow/core/services/storage/cache_helper.dart';
import 'package:fitflow/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:fitflow/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:fitflow/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:fitflow/features/auth/domain/repositories/auth_repository.dart';
import 'package:fitflow/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:fitflow/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:fitflow/features/auth/domain/usecases/login_usecase.dart';
import 'package:fitflow/features/auth/domain/usecases/logout_usecase.dart';
import 'package:fitflow/features/auth/domain/usecases/register_usecase.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ── Core ──────────────────────────────────────────────────────────────────
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());
  sl.registerLazySingleton<ApiService>(() => ApiService());
  sl.registerLazySingleton<CacheHelper>(() => CacheHelper());

  // ── Auth — Data Sources ───────────────────────────────────────────────────
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(apiService: sl()),
  );
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(cacheHelper: sl()),
  );

  // ── Auth — Repository ─────────────────────────────────────────────────────
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // ── Auth — Use Cases ──────────────────────────────────────────────────────
  sl.registerLazySingleton(() => LoginUsecase(sl()));
  sl.registerLazySingleton(() => RegisterUsecase(sl()));
  sl.registerLazySingleton(() => LogoutUsecase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUsecase(sl()));
  sl.registerLazySingleton(() => ForgotPasswordUsecase(sl()));
}