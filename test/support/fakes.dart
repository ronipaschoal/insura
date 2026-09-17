import 'dart:async';

import 'package:insura/core/result/failure.dart';
import 'package:insura/core/result/result.dart';
import 'package:insura/features/auth/data/datasources/auth_credentials_storage.dart';
import 'package:insura/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:insura/features/auth/data/models/login_response_model.dart';
import 'package:insura/features/auth/domain/entities/saved_credentials.dart';
import 'package:insura/features/auth/domain/entities/user_entity.dart';
import 'package:insura/features/auth/domain/repositories/auth_repository.dart';

/// Hand-rolled [AuthRepository] test double — matches this project's
/// preference for plain fakes over a mocking framework (see [Result]).
class FakeAuthRepository implements AuthRepository {
  Result<Failure, UserEntity>? loginResult;
  bool loggedIn = false;
  int logoutCalls = 0;
  ({String cpf, String password})? lastLoginArgs;
  @override
  UserEntity? currentUser;

  final _authStateController = StreamController<bool>.broadcast();

  @override
  Future<Result<Failure, UserEntity>> login({
    required String cpf,
    required String password,
  }) async {
    lastLoginArgs = (cpf: cpf, password: password);
    final result = loginResult ?? const ResultFailure(UnknownFailure());
    if (result.isSuccess) loggedIn = true;
    return result;
  }

  @override
  Future<void> logout() async {
    logoutCalls++;
    loggedIn = false;
    _authStateController.add(false);
  }

  @override
  Stream<bool> get authStateChanges => _authStateController.stream;

  @override
  bool get isLoggedIn => loggedIn;

  /// Whether something is currently subscribed to [authStateChanges] — used
  /// to assert a subscriber cancels it on dispose.
  bool get authStateChangesHasListener => _authStateController.hasListener;
}

/// Hand-rolled [AuthRemoteDataSource] test double, used to unit test
/// [AuthRepositoryImpl] in isolation from Firebase.
class FakeAuthRemoteDataSource implements AuthRemoteDataSource {
  LoginResponseModel? loginResponse;
  Object? loginError;
  bool loggedIn = false;
  int logoutCalls = 0;
  @override
  LoginResponseModel? currentUser;

  final _authStateController = StreamController<bool>.broadcast();

  @override
  Future<LoginResponseModel> login({
    required String cpf,
    required String password,
  }) async {
    if (loginError != null) throw loginError!;
    return loginResponse!;
  }

  @override
  Future<void> logout() async {
    logoutCalls++;
    loggedIn = false;
    _authStateController.add(false);
  }

  @override
  Stream<bool> get authStateChanges => _authStateController.stream;

  @override
  bool get isLoggedIn => loggedIn;
}

/// Hand-rolled [AuthCredentialsStorage] test double.
class FakeAuthCredentialsStorage implements AuthCredentialsStorage {
  SavedCredentials? stored;
  int saveCalls = 0;
  int clearCalls = 0;

  @override
  Future<void> save({required String cpf, required String password}) async {
    saveCalls++;
    stored = SavedCredentials(cpf: cpf, password: password);
  }

  @override
  Future<void> clear() async {
    clearCalls++;
    stored = null;
  }

  @override
  Future<SavedCredentials?> read() async => stored;
}
