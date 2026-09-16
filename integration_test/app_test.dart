import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:insura/app/app.dart';
import 'package:insura/app/routes/app_router.dart';
import 'package:insura/app/routes/app_routes.dart';
import 'package:insura/core/di/injector.dart';
import 'package:insura/core/result/result.dart';
import 'package:insura/features/auth/domain/entities/user_entity.dart';
import 'package:insura/features/auth/domain/repositories/auth_repository.dart';
import 'package:insura/features/auth/presentation/cubit/login_cubit.dart';
import 'package:insura/features/home/presentation/cubit/home_cubit.dart';
import 'package:integration_test/integration_test.dart';

import '../test/support/fakes.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'redirects unauthenticated visits to /login, lets a user log in, reach '
    'Home, and log out — and blocks /home again afterwards',
    (tester) async {
      setupInjector();
      final authRepository = FakeAuthRepository();
      final credentialsStorage = FakeAuthCredentialsStorage();
      // Bypass Firebase entirely: the app under test never needs to reach
      // FirebaseAuth/Firestore once AuthRepository is replaced.
      getIt
        ..unregister<AuthRepository>()
        ..registerLazySingleton<AuthRepository>(() => authRepository)
        ..unregister<LoginCubit>()
        ..registerFactory<LoginCubit>(
          () => LoginCubit(authRepository, credentialsStorage),
        )
        ..unregister<HomeCubit>()
        ..registerFactory<HomeCubit>(() => HomeCubit(authRepository));
      addTearDown(resetInjector);

      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();

      expect(find.widgetWithText(TextField, 'CPF'), findsOneWidget);

      // A direct visit to a protected route while logged out is redirected
      // back to /login by AppRouter's guard.
      AppRouter.router.go(AppRoutes.home);
      await tester.pumpAndSettle();

      expect(find.widgetWithText(TextField, 'CPF'), findsOneWidget);
      expect(find.text('Bem-vindo(a)!'), findsNothing);

      // Log in.
      const user = UserEntity(id: '1', name: 'Ana', email: 'ana@x.com');
      authRepository.loginResult = const ResultSuccess(user);
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

      expect(find.text('Bem-vindo(a)!'), findsOneWidget);

      // Log out via the nav menu (mobile drawer at the default test
      // viewport size — below Breakpoints.desktop).
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Sair'));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(TextField, 'CPF'), findsOneWidget);
      expect(authRepository.logoutCalls, 1);

      // The protected route is blocked again after logout.
      AppRouter.router.go(AppRoutes.home);
      await tester.pumpAndSettle();

      expect(find.text('Bem-vindo(a)!'), findsNothing);
    },
  );
}
