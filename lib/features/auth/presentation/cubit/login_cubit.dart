import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/auth_repository.dart';
import 'login_state.dart';

/// ViewModel for [LoginPage]. Contains no Flutter UI code, only view state.
class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._authRepository) : super(const LoginInitial());

  final AuthRepository _authRepository;

  Future<void> login({required String email, required String password}) async {
    emit(const LoginLoading());

    final result = await _authRepository.login(
      email: email,
      password: password,
    );

    result.fold(
      (failure) => emit(LoginError(failure.message)),
      (user) => emit(LoginSuccess(user)),
    );
  }
}
