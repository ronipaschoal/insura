import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../domain/entities/saved_credentials.dart';
import 'auth_credentials_storage.dart';

/// Backed by the OS keychain/keystore on mobile/desktop. On web,
/// `flutter_secure_storage` falls back to browser storage, which offers
/// weaker guarantees than Keychain/Keystore — treat "Lembrar Sempre" there
/// as a convenience, not a security boundary.
class AuthCredentialsStorageImpl implements AuthCredentialsStorage {
  AuthCredentialsStorageImpl(this._storage);

  final FlutterSecureStorage _storage;

  static const _cpfKey = 'auth_remember_cpf';
  static const _passwordKey = 'auth_remember_password';

  @override
  Future<void> save({required String cpf, required String password}) async {
    await _storage.write(key: _cpfKey, value: cpf);
    await _storage.write(key: _passwordKey, value: password);
  }

  @override
  Future<void> clear() async {
    await _storage.delete(key: _cpfKey);
    await _storage.delete(key: _passwordKey);
  }

  @override
  Future<SavedCredentials?> read() async {
    final cpf = await _storage.read(key: _cpfKey);
    final password = await _storage.read(key: _passwordKey);
    if (cpf == null || password == null) return null;
    return SavedCredentials(cpf: cpf, password: password);
  }
}
