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
