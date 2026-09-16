import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/login_response_model.dart';
import 'auth_remote_datasource.dart';

/// Firebase Auth only authenticates via email/password natively, so login is
/// keyed by CPF through a `cpfIndex/{cpf} -> { email }` lookup in Firestore
/// (written during registration) before calling
/// [FirebaseAuth.signInWithEmailAndPassword] with the resolved email.
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(this._firebaseAuth, this._firestore);

  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  static const _cpfIndexCollection = 'cpfIndex';

  @override
  Future<LoginResponseModel> login({
    required String cpf,
    required String password,
  }) async {
    final indexDoc = await _firestore
        .collection(_cpfIndexCollection)
        .doc(cpf)
        .get();

    final email = indexDoc.data()?['email'] as String?;
    if (email == null) {
      throw FirebaseAuthException(
        code: 'user-not-found',
        message: 'CPF não cadastrado.',
      );
    }

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

    return LoginResponseModel(
      id: user.uid,
      name: user.displayName ?? '',
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
}
