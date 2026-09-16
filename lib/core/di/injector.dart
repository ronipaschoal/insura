import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import '../../features/auth/data/datasources/auth_credentials_storage.dart';
import '../../features/auth/data/datasources/auth_credentials_storage_impl.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/datasources/auth_remote_datasource_impl.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/presentation/cubit/login_cubit.dart';
import '../../features/home/presentation/cubit/home_cubit.dart';

final GetIt getIt = GetIt.instance;

/// Registers dependencies against interfaces (SOLID/DIP), never concrete
/// implementations, so they can be swapped out in tests.
void setupInjector() {
  // Core
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  getIt.registerLazySingleton<FirebaseFirestore>(
    () => FirebaseFirestore.instance,
  );
  getIt.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );

  // Auth feature
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      getIt<FirebaseAuth>(),
      getIt<FirebaseFirestore>(),
    ),
  );
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt<AuthRemoteDataSource>()),
  );
  getIt.registerLazySingleton<AuthCredentialsStorage>(
    () => AuthCredentialsStorageImpl(getIt<FlutterSecureStorage>()),
  );
  getIt.registerFactory<LoginCubit>(
    () => LoginCubit(getIt<AuthRepository>(), getIt<AuthCredentialsStorage>()),
  );
  getIt.registerFactory<HomeCubit>(() => HomeCubit(getIt<AuthRepository>()));
}

Future<void> resetInjector() => getIt.reset();
