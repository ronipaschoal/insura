import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:insura/core/result/failure.dart';
import 'package:insura/features/auth/data/models/login_response_model.dart';
import 'package:insura/features/auth/data/repositories/auth_repository_impl.dart';

import '../../../../support/fakes.dart';

void main() {
  late FakeAuthRemoteDataSource dataSource;
  late AuthRepositoryImpl repository;

  setUp(() {
    dataSource = FakeAuthRemoteDataSource();
    repository = AuthRepositoryImpl(dataSource);
  });

  group('login', () {
    test('maps a successful datasource response to a UserEntity', () async {
      dataSource.loginResponse = const LoginResponseModel(
        id: '1',
        name: 'Ana',
        email: 'ana@x.com',
      );

      final result = await repository.login(cpf: '12345678909', password: 'x');

      expect(result.isSuccess, isTrue);
      result.fold((_) => fail('expected success'), (user) {
        expect(user.id, '1');
        expect(user.name, 'Ana');
        expect(user.email, 'ana@x.com');
      });
    });

    test('maps user-not-found to a friendly AuthFailure message', () async {
      dataSource.loginError = FirebaseAuthException(code: 'user-not-found');

      final result = await repository.login(cpf: '123', password: 'x');

      result.fold((failure) {
        expect(failure, isA<AuthFailure>());
        expect(failure.message, 'CPF não cadastrado.');
      }, (_) => fail('expected failure'));
    });

    for (final code in ['wrong-password', 'invalid-credential']) {
      test('maps $code to an invalid CPF/password message', () async {
        dataSource.loginError = FirebaseAuthException(code: code);

        final result = await repository.login(cpf: '123', password: 'x');

        result.fold(
          (failure) => expect(failure.message, 'CPF ou senha inválidos.'),
          (_) => fail('expected failure'),
        );
      });
    }

    test('maps an unrecognized FirebaseAuthException code to a fallback '
        'message', () async {
      dataSource.loginError = FirebaseAuthException(code: 'something-else');

      final result = await repository.login(cpf: '123', password: 'x');

      result.fold(
        (failure) => expect(
          failure.message,
          'Não foi possível entrar. Tente novamente.',
        ),
        (_) => fail('expected failure'),
      );
    });

    test('wraps non-Firebase errors as UnknownFailure', () async {
      dataSource.loginError = Exception('boom');

      final result = await repository.login(cpf: '123', password: 'x');

      result.fold(
        (failure) => expect(failure, isA<UnknownFailure>()),
        (_) => fail('expected failure'),
      );
    });
  });

  test('logout delegates to the datasource', () async {
    await repository.logout();

    expect(dataSource.logoutCalls, 1);
  });

  test('isLoggedIn reflects the datasource', () {
    expect(repository.isLoggedIn, isFalse);

    dataSource.loggedIn = true;

    expect(repository.isLoggedIn, isTrue);
  });

  test('authStateChanges forwards the datasource stream', () async {
    final expectation = expectLater(repository.authStateChanges, emits(false));

    await dataSource.logout();

    await expectation;
  });
}
