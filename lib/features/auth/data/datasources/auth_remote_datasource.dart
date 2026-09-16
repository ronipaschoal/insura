import '../models/login_response_model.dart';

abstract interface class AuthRemoteDataSource {
  Future<LoginResponseModel> login({
    required String cpf,
    required String password,
  });

  Future<void> logout();

  /// Emits whenever the signed-in state changes (login/logout), so
  /// `AppRouter` can re-run its redirect guard reactively.
  Stream<bool> get authStateChanges;

  bool get isLoggedIn;

  /// The signed-in user, read from the current session (not a login
  /// response) — used to greet the user on Home without a fresh sign-in.
  LoginResponseModel? get currentUser;
}
