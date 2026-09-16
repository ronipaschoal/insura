import '../../domain/entities/user_entity.dart';

sealed class LoginState {
  const LoginState();
}

final class LoginInitial extends LoginState {
  const LoginInitial();
}

final class LoginLoading extends LoginState {
  const LoginLoading();
}

final class LoginSuccess extends LoginState {
  const LoginSuccess(this.user);

  final UserEntity user;
}

final class LoginError extends LoginState {
  const LoginError(this.message);

  final String message;
}

/// Emitted once, on cubit creation, when a CPF/password pair was previously
/// saved via "Lembrar Sempre" — [LoginPage] uses it to pre-fill the form.
final class LoginCredentialsLoaded extends LoginState {
  const LoginCredentialsLoaded({required this.cpf, required this.password});

  final String cpf;
  final String password;
}
