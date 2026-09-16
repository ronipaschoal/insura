sealed class Failure {
  const Failure(this.message);

  final String message;
}

final class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'Erro desconhecido']);
}

final class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Falha de autenticação']);
}
