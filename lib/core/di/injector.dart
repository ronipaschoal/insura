import 'package:get_it/get_it.dart';

import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/datasources/auth_remote_datasource_fake.dart';
import '../../features/auth/data/datasources/auth_remote_datasource_impl.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/presentation/cubit/login_cubit.dart';
import '../network/dio_client.dart';
import '../network/http_client.dart';

final GetIt getIt = GetIt.instance;

/// While there is no real backend, flip this to `false` to hit the real
/// `AuthRemoteDataSourceImpl` (via `dio`) instead of the mocked one.
const bool useFakeAuth = true;

/// Registers dependencies against interfaces (SOLID/DIP), never concrete
/// implementations, so they can be swapped out in tests.
void setupInjector() {
  // Core
  getIt.registerLazySingleton<HttpClient>(DioClient.new);

  // Auth feature
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => useFakeAuth
        ? AuthRemoteDataSourceFake()
        : AuthRemoteDataSourceImpl(getIt<HttpClient>()),
  );
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt<AuthRemoteDataSource>()),
  );
  getIt.registerFactory<LoginCubit>(() => LoginCubit(getIt<AuthRepository>()));
}

Future<void> resetInjector() => getIt.reset();
