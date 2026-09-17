import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:insura/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:insura/features/auth/presentation/cubit/auth_state.dart';

import '../../../../support/fakes.dart';

void main() {
  late FakeAuthRepository authRepository;

  setUp(() {
    authRepository = FakeAuthRepository();
  });

  test('seeds initial state from AuthRepository.isLoggedIn (logged out)', () {
    final cubit = AuthCubit(authRepository);

    expect(cubit.state.isLoggedIn, isFalse);

    cubit.close();
  });

  test('seeds initial state from AuthRepository.isLoggedIn (logged in)', () {
    authRepository.loggedIn = true;
    final cubit = AuthCubit(authRepository);

    expect(cubit.state.isLoggedIn, isTrue);

    cubit.close();
  });

  blocTest<AuthCubit, AuthState>(
    'emits a new AuthState whenever the repository auth state changes',
    build: () => AuthCubit(authRepository),
    act: (_) => authRepository.logout(),
    expect: () => [
      isA<AuthState>().having((s) => s.isLoggedIn, 'isLoggedIn', isFalse),
    ],
  );

  test(
    'isLoggedIn reads the repository live, ahead of the state stream',
    () {
      final cubit = AuthCubit(authRepository);
      expect(cubit.isLoggedIn, isFalse);

      // Mirrors AuthRepositoryImpl.login(): `loggedIn` flips synchronously,
      // while the authStateChanges stream event (which only drives `state`)
      // is delivered a turn later. AppRouter's redirect guard reads
      // `isLoggedIn`, not `state`, precisely so it never sees a stale value
      // in that gap right after an explicit login/logout navigation.
      authRepository.loggedIn = true;

      expect(cubit.isLoggedIn, isTrue);
      expect(cubit.state.isLoggedIn, isFalse);

      cubit.close();
    },
  );

  test('cancels the authStateChanges subscription on close', () async {
    final cubit = AuthCubit(authRepository);
    expect(authRepository.authStateChangesHasListener, isTrue);

    await cubit.close();

    expect(authRepository.authStateChangesHasListener, isFalse);
  });
}
