sealed class Failure {
  const Failure(this.message);

  final String message;
}

final class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Falha de conexão']);
}

final class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Erro no servidor']);
}

final class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'Erro desconhecido']);
}
