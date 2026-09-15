import '../../../../core/result/failure.dart';
import '../../../../core/result/result.dart';
import '../entities/user_entity.dart';

/// Contract implemented by [AuthRepositoryImpl]. Depending on this interface
/// (not the implementation) lets [LoginCubit] be built/tested against a fake.
abstract interface class AuthRepository {
  Future<Result<Failure, UserEntity>> login({
    required String email,
    required String password,
  });
}
