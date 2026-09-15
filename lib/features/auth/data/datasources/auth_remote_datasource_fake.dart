import '../models/login_response_model.dart';
import 'auth_remote_datasource.dart';

/// Fake implementation used while there is no real backend
/// (toggled by [useFakeAuth] in `injector.dart`). Returns a mocked user
/// after a short delay instead of calling `dio`, so the login screen,
/// [LoginCubit] and navigation to Home can be exercised end-to-end.
class AuthRemoteDataSourceFake implements AuthRemoteDataSource {
  @override
  Future<LoginResponseModel> login({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));

    return LoginResponseModel(
      id: 'fake-user-id',
      name: 'Usuário de Teste',
      email: email,
    );
  }
}
