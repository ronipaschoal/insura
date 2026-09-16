import 'dart:async';

import '../models/login_response_model.dart';
import 'auth_remote_datasource.dart';

/// Fake implementation used while there is no real backend
/// (toggled by [useFakeAuth] in `injector.dart`). Returns a mocked user
/// after a short delay instead of calling Firebase, so the login screen,
/// [LoginCubit] and navigation to Home can be exercised end-to-end. Tracks a
/// simple in-memory "logged in" flag so the `AppRouter` redirect guard and
/// logout button also work in fake mode.
class AuthRemoteDataSourceFake implements AuthRemoteDataSource {
  final _authStateController = StreamController<bool>.broadcast();
  bool _isLoggedIn = false;

  @override
  Future<LoginResponseModel> login({
    required String cpf,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));

    _isLoggedIn = true;
    _authStateController.add(true);

    return const LoginResponseModel(
      id: 'fake-user-id',
      name: 'Usuário de Teste',
      email: 'usuario.teste@insura.com',
    );
  }

  @override
  Future<void> logout() async {
    _isLoggedIn = false;
    _authStateController.add(false);
  }

  @override
  Stream<bool> get authStateChanges => _authStateController.stream;

  @override
  bool get isLoggedIn => _isLoggedIn;
}
