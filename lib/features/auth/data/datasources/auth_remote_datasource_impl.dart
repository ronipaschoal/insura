import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/login_response_model.dart';
import 'auth_remote_datasource.dart';

/// Firebase Auth only authenticates via email/password natively, so login is
/// keyed by CPF through a `cpfIndex/{cpf} -> { email, name }` lookup in
/// Firestore (written during registration) before calling
/// [FirebaseAuth.signInWithEmailAndPassword] with the resolved email. `name`
/// isn't part of the Firebase Auth profile, so it's cached here to answer
/// [currentUser] for the rest of the session (a page reload loses it, same
/// as before this field existed).
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(this._firebaseAuth, this._firestore);

  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  static const _cpfIndexCollection = 'cpfIndex';

  String? _cachedName;

  @override
  Future<LoginResponseModel> login({
    required String cpf,
    required String password,
  }) async {
    final indexDoc = await _firestore
        .collection(_cpfIndexCollection)
        .doc(cpf)
        .get();

    final data = indexDoc.data();
    final email = data?['email'] as String?;
    if (email == null) {
      throw FirebaseAuthException(
        code: 'user-not-found',
        message: 'CPF não cadastrado.',
      );
    }
    final name = data?['name'] as String? ?? '';

    final credential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = credential.user;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'user-not-found',
        message: 'Não foi possível autenticar.',
      );
    }

    _cachedName = name;

    return LoginResponseModel(
      id: user.uid,
      name: name,
      email: user.email ?? email,
    );
  }

  @override
  Future<void> logout() => _firebaseAuth.signOut();

  @override
  Stream<bool> get authStateChanges =>
      _firebaseAuth.authStateChanges().map((user) => user != null);

  @override
  bool get isLoggedIn => _firebaseAuth.currentUser != null;

  @override
  LoginResponseModel? get currentUser {
    final user = _firebaseAuth.currentUser;
    if (user == null) return null;
    return LoginResponseModel(
      id: user.uid,
      name: _cachedName ?? '',
      email: user.email ?? '',
    );
  }
}
