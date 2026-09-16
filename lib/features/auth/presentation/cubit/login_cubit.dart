import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/datasources/auth_credentials_storage.dart';
import '../../domain/repositories/auth_repository.dart';
import 'login_state.dart';

/// ViewModel for [LoginPage]. Contains no Flutter UI code, only view state.
class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._authRepository, this._credentialsStorage)
    : super(const LoginInitial()) {
    _loadSavedCredentials();
  }

  final AuthRepository _authRepository;
  final AuthCredentialsStorage _credentialsStorage;

  Future<void> _loadSavedCredentials() async {
    final saved = await _credentialsStorage.read();
    if (saved != null) {
      emit(LoginCredentialsLoaded(cpf: saved.cpf, password: saved.password));
    }
  }

  Future<void> login({
    required String cpf,
    required String password,
    required bool rememberMe,
  }) async {
    emit(const LoginLoading());

    final result = await _authRepository.login(
      cpf: cpf,
      password: password,
    );

    result.fold(
      (failure) => emit(LoginError(failure.message)),
      (user) {
        unawaited(
          rememberMe
              ? _credentialsStorage.save(cpf: cpf, password: password)
              : _credentialsStorage.clear(),
        );
        emit(LoginSuccess(user));
      },
    );
  }
}
