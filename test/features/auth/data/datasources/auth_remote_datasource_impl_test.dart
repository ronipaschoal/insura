import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:insura/features/auth/data/datasources/auth_remote_datasource_impl.dart';

void main() {
  late MockFirebaseAuth firebaseAuth;
  late FakeFirebaseFirestore firestore;
  late AuthRemoteDataSourceImpl dataSource;

  setUp(() {
    firebaseAuth = MockFirebaseAuth(
      mockUser: MockUser(uid: 'uid-1', email: 'ana@x.com'),
    );
    firestore = FakeFirebaseFirestore();
    dataSource = AuthRemoteDataSourceImpl(firebaseAuth, firestore);
  });

  Future<void> seedCpfIndex(String cpf, {required String email, String? name}) {
    return firestore.collection('cpfIndex').doc(cpf).set({
      'email': email,
      'name': ?name,
    });
  }

  group('login', () {
    test('reads the name from the cpfIndex/{cpf} Firestore doc', () async {
      await seedCpfIndex('12345678909', email: 'ana@x.com', name: 'Ana');

      final result = await dataSource.login(
        cpf: '12345678909',
        password: 'insura1234',
      );

      expect(result.id, 'uid-1');
      expect(result.name, 'Ana');
      expect(result.email, 'ana@x.com');
    });

    test('defaults to an empty name when cpfIndex has none yet', () async {
      await seedCpfIndex('12345678909', email: 'ana@x.com');

      final result = await dataSource.login(
        cpf: '12345678909',
        password: 'insura1234',
      );

      expect(result.name, '');
    });

    test('throws user-not-found when the CPF has no cpfIndex doc', () async {
      await expectLater(
        dataSource.login(cpf: '00000000000', password: 'x'),
        throwsA(
          isA<FirebaseAuthException>().having(
            (e) => e.code,
            'code',
            'user-not-found',
          ),
        ),
      );
    });
  });

  group('currentUser', () {
    test('is null before any sign-in', () {
      final signedOutAuth = MockFirebaseAuth();
      final signedOutDataSource = AuthRemoteDataSourceImpl(
        signedOutAuth,
        firestore,
      );

      expect(signedOutDataSource.currentUser, isNull);
    });

    test('reflects the name cached from the last successful login in this '
        'session', () async {
      await seedCpfIndex('12345678909', email: 'ana@x.com', name: 'Ana');
      expect(dataSource.currentUser, isNull);

      await dataSource.login(cpf: '12345678909', password: 'insura1234');

      expect(dataSource.currentUser?.id, 'uid-1');
      expect(dataSource.currentUser?.name, 'Ana');
      expect(dataSource.currentUser?.email, 'ana@x.com');
    });

    test('has an empty name when there was no login this session', () async {
      // Firebase Auth session persisted across a page reload: signed in,
      // but the in-memory name cache from `login()` never ran.
      final persistedAuth = MockFirebaseAuth(
        signedIn: true,
        mockUser: MockUser(uid: 'uid-1', email: 'ana@x.com'),
      );
      final persistedDataSource = AuthRemoteDataSourceImpl(
        persistedAuth,
        firestore,
      );

      expect(persistedDataSource.currentUser?.name, '');
    });
  });
}
