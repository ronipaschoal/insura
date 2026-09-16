import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:insura/features/home/presentation/cubit/home_cubit.dart';
import 'package:insura/features/home/presentation/cubit/home_state.dart';

import '../../../../support/fakes.dart';

void main() {
  late FakeAuthRepository authRepository;

  setUp(() {
    authRepository = FakeAuthRepository();
  });

  blocTest<HomeCubit, HomeState>(
    'selectDestination updates selectedIndex',
    build: () => HomeCubit(authRepository),
    act: (cubit) => cubit.selectDestination(1),
    expect: () => [
      isA<HomeState>().having((s) => s.selectedIndex, 'selectedIndex', 1),
    ],
  );

  blocTest<HomeCubit, HomeState>(
    'logout calls the repository and emits loggedOut',
    build: () => HomeCubit(authRepository),
    act: (cubit) => cubit.logout(),
    expect: () => [
      isA<HomeState>().having((s) => s.loggedOut, 'loggedOut', true),
    ],
    verify: (_) => expect(authRepository.logoutCalls, 1),
  );
}
