import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:insura/core/result/failure.dart';
import 'package:insura/core/result/result.dart';
import 'package:insura/features/auth/domain/entities/saved_credentials.dart';
import 'package:insura/features/auth/domain/entities/user_entity.dart';
import 'package:insura/features/auth/presentation/cubit/login_cubit.dart';
import 'package:insura/features/auth/presentation/cubit/login_state.dart';

import '../../../../support/fakes.dart';

void main() {
  late FakeAuthRepository authRepository;
  late FakeAuthCredentialsStorage credentialsStorage;

  const user = UserEntity(id: '1', name: 'Ana', email: 'ana@x.com');

  setUp(() {
    authRepository = FakeAuthRepository();
    credentialsStorage = FakeAuthCredentialsStorage();
  });

  blocTest<LoginCubit, LoginState>(
    'emits LoginCredentialsLoaded on creation when credentials were saved',
    setUp: () {
      credentialsStorage.stored = const SavedCredentials(
        cpf: '12345678909',
        password: 'insura1234',
      );
    },
    build: () => LoginCubit(authRepository, credentialsStorage),
    expect: () => [
      isA<LoginCredentialsLoaded>()
          .having((s) => s.cpf, 'cpf', '12345678909')
          .having((s) => s.password, 'password', 'insura1234'),
    ],
  );

  blocTest<LoginCubit, LoginState>(
    'stays initial on creation when nothing was saved',
    build: () => LoginCubit(authRepository, credentialsStorage),
    expect: () => <LoginState>[],
  );

  blocTest<LoginCubit, LoginState>(
    'emits Loading then Success and saves credentials when rememberMe is '
    'true',
    setUp: () => authRepository.loginResult = const ResultSuccess(user),
    build: () => LoginCubit(authRepository, credentialsStorage),
    act: (cubit) =>
        cubit.login(cpf: '12345678909', password: 'insura1234', rememberMe: true),
    expect: () => [isA<LoginLoading>(), isA<LoginSuccess>()],
    verify: (_) {
      expect(credentialsStorage.saveCalls, 1);
      expect(credentialsStorage.clearCalls, 0);
      expect(credentialsStorage.stored?.cpf, '12345678909');
      expect(credentialsStorage.stored?.password, 'insura1234');
    },
  );

  blocTest<LoginCubit, LoginState>(
    'clears saved credentials when rememberMe is false',
    setUp: () => authRepository.loginResult = const ResultSuccess(user),
    build: () => LoginCubit(authRepository, credentialsStorage),
    act: (cubit) => cubit.login(
      cpf: '12345678909',
      password: 'insura1234',
      rememberMe: false,
    ),
    expect: () => [isA<LoginLoading>(), isA<LoginSuccess>()],
    verify: (_) {
      expect(credentialsStorage.clearCalls, 1);
      expect(credentialsStorage.saveCalls, 0);
      expect(credentialsStorage.stored, isNull);
    },
  );

  blocTest<LoginCubit, LoginState>(
    'emits Loading then Error on failure and never touches storage',
    setUp: () => authRepository.loginResult =
        const ResultFailure(AuthFailure('CPF ou senha inválidos.')),
    build: () => LoginCubit(authRepository, credentialsStorage),
    act: (cubit) =>
        cubit.login(cpf: '12345678909', password: 'wrong', rememberMe: true),
    expect: () => [
      isA<LoginLoading>(),
      isA<LoginError>().having(
        (s) => s.message,
        'message',
        'CPF ou senha inválidos.',
      ),
    ],
    verify: (_) {
      expect(credentialsStorage.saveCalls, 0);
      expect(credentialsStorage.clearCalls, 0);
    },
  );
}
