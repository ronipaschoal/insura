import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:insura/app/routes/app_routes.dart';
import 'package:insura/core/di/injector.dart';
import 'package:insura/core/result/failure.dart';
import 'package:insura/core/result/result.dart';
import 'package:insura/features/auth/domain/entities/saved_credentials.dart';
import 'package:insura/features/auth/domain/entities/user_entity.dart';
import 'package:insura/features/auth/domain/repositories/auth_repository.dart';
import 'package:insura/features/auth/presentation/cubit/login_cubit.dart';
import 'package:insura/features/auth/presentation/pages/login_page.dart';

import '../../../../support/fakes.dart';

void main() {
  late FakeAuthRepository authRepository;
  late FakeAuthCredentialsStorage credentialsStorage;

  setUp(() {
    setupInjector();
    authRepository = FakeAuthRepository();
    credentialsStorage = FakeAuthCredentialsStorage();
    // Bypass Firebase entirely for this page-level test: swap the real
    // AuthRepository/LoginCubit for hand-rolled fakes before anything
    // resolves the Firebase-backed AuthRemoteDataSource.
    getIt
      ..unregister<AuthRepository>()
      ..registerLazySingleton<AuthRepository>(() => authRepository)
      ..unregister<LoginCubit>()
      ..registerFactory<LoginCubit>(
        () => LoginCubit(authRepository, credentialsStorage),
      );
  });

  tearDown(resetInjector);

  Future<void> pumpLoginPage(WidgetTester tester) async {
    final router = GoRouter(
      initialLocation: AppRoutes.login,
      routes: [
        GoRoute(path: AppRoutes.login, builder: (_, _) => const LoginPage()),
        GoRoute(
          path: AppRoutes.home,
          builder: (_, _) => const Scaffold(body: Text('HOME')),
        ),
      ],
    );
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
  }

  testWidgets('renders the CPF and Senha fields', (tester) async {
    await pumpLoginPage(tester);

    expect(find.widgetWithText(TextField, 'CPF'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Senha'), findsOneWidget);
  });

  testWidgets('shows a snackbar with the failure message on login error', (
    tester,
  ) async {
    authRepository.loginResult = const ResultFailure(
      AuthFailure('CPF ou senha inválidos.'),
    );
    await pumpLoginPage(tester);

    await tester.enterText(
      find.widgetWithText(TextField, 'CPF'),
      '12345678909',
    );
    await tester.enterText(find.widgetWithText(TextField, 'Senha'), 'wrong');
    await tester.tap(find.byIcon(Icons.arrow_forward));
    await tester.pumpAndSettle();

    expect(find.text('CPF ou senha inválidos.'), findsOneWidget);
  });

  testWidgets('navigates to home after a successful login', (tester) async {
    const user = UserEntity(id: '1', name: 'Ana', email: 'ana@x.com');
    authRepository.loginResult = const ResultSuccess(user);
    await pumpLoginPage(tester);

    await tester.enterText(
      find.widgetWithText(TextField, 'CPF'),
      '12345678909',
    );
    await tester.enterText(
      find.widgetWithText(TextField, 'Senha'),
      'insura1234',
    );
    await tester.tap(find.byIcon(Icons.arrow_forward));
    await tester.pumpAndSettle();

    expect(find.text('HOME'), findsOneWidget);
    expect(authRepository.lastLoginArgs?.cpf, '12345678909');
    expect(authRepository.lastLoginArgs?.password, 'insura1234');
  });

  testWidgets('pre-fills CPF and password when credentials were saved', (
    tester,
  ) async {
    credentialsStorage.stored = const SavedCredentials(
      cpf: '12345678909',
      password: 'insura1234',
    );
    await pumpLoginPage(tester);
    await tester.pumpAndSettle();

    final fields = tester.widgetList<TextField>(find.byType(TextField)).toList();
    expect(fields[0].controller?.text, '123.456.789-09');
    expect(fields[1].controller?.text, 'insura1234');
  });
}
