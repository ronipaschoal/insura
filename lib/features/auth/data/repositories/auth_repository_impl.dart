import 'package:dio/dio.dart';

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
    required String email,
    required String password,
  }) async {
    try {
      final model = await _remoteDataSource.login(
        email: email,
        password: password,
      );
      return ResultSuccess(model.toEntity());
    } on DioException catch (error) {
      return ResultFailure(NetworkFailure(error.message ?? 'Falha de conexão'));
    } catch (error) {
      return ResultFailure(UnknownFailure(error.toString()));
    }
  }
}
