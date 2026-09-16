import '../../domain/entities/saved_credentials.dart';

/// Persists the CPF/password pair for the "Lembrar Sempre" login checkbox.
abstract interface class AuthCredentialsStorage {
  Future<void> save({required String cpf, required String password});

  Future<void> clear();

  Future<SavedCredentials?> read();
}
