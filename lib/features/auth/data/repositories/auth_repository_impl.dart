import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/result/failure.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._remoteDataSource);

  final AuthRemoteDataSource _remoteDataSource;

  @override
  Future<Result<Failure, UserEntity>> login({
    required String cpf,
    required String password,
  }) async {
    try {
      final model = await _remoteDataSource.login(
        cpf: cpf,
        password: password,
      );
      return ResultSuccess(model.toEntity());
    } on FirebaseAuthException catch (error) {
      return ResultFailure(AuthFailure(_messageFor(error.code)));
    } catch (error) {
      return ResultFailure(UnknownFailure(error.toString()));
    }
  }

  @override
  Future<void> logout() => _remoteDataSource.logout();

  @override
  Stream<bool> get authStateChanges => _remoteDataSource.authStateChanges;

  @override
  bool get isLoggedIn => _remoteDataSource.isLoggedIn;

  String _messageFor(String code) {
    switch (code) {
      case 'user-not-found':
        return 'CPF não cadastrado.';
      case 'wrong-password':
      case 'invalid-credential':
        return 'CPF ou senha inválidos.';
      case 'user-disabled':
        return 'Esta conta está desativada.';
      case 'too-many-requests':
        return 'Muitas tentativas. Tente novamente mais tarde.';
      case 'network-request-failed':
        return 'Falha de conexão.';
      default:
        return 'Não foi possível entrar. Tente novamente.';
    }
  }
}
