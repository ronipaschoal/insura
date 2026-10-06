import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:insura/app/routes/app_routes.dart';
import 'package:insura/core/di/injector.dart';
import 'package:insura/features/auth/domain/entities/user_entity.dart';
import 'package:insura/features/auth/domain/repositories/auth_repository.dart';
import 'package:insura/features/home/presentation/cubit/home_cubit.dart';
import 'package:insura/features/home/presentation/pages/home_page.dart';

import '../../../../support/fakes.dart';

void main() {
  late FakeAuthRepository authRepository;

  setUp(() {
    setupInjector();
    authRepository = FakeAuthRepository()
      ..currentUser = const UserEntity(
        id: '1',
        name: 'Ana',
        email: 'ana@x.com',
      );
    // Bypass Firebase entirely for this page-level test, same as
    // login_page_test.dart.
    getIt
      ..unregister<AuthRepository>()
      ..registerLazySingleton<AuthRepository>(() => authRepository)
      ..unregister<HomeCubit>()
      ..registerFactory<HomeCubit>(() => HomeCubit(authRepository));
  });

  tearDown(resetInjector);

  Future<void> pumpHomePage(WidgetTester tester) async {
    final router = GoRouter(
      initialLocation: AppRoutes.home,
      routes: [
        GoRoute(path: AppRoutes.home, builder: (_, _) => const HomePage()),
        GoRoute(
          path: AppRoutes.login,
          builder: (_, _) => const Scaffold(body: Text('LOGIN')),
        ),
        GoRoute(
          path: AppRoutes.webview,
          builder: (_, state) => Scaffold(
            body: Text('WEBVIEW:${state.uri.queryParameters['page']}'),
          ),
        ),
      ],
    );
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();
  }

  Future<void> openMenu(WidgetTester tester) async {
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();
  }

  testWidgets('renders the welcome banner with the current user name', (
    tester,
  ) async {
    await pumpHomePage(tester);

    expect(find.text('Ana'), findsOneWidget);
  });

  testWidgets('tapping Home/Seguros stays on Home', (tester) async {
    await pumpHomePage(tester);
    await openMenu(tester);

    await tester.tap(find.text('Home/Seguros'));
    await tester.pumpAndSettle();

    expect(find.textContaining('WEBVIEW:'), findsNothing);
    expect(find.text('Ana'), findsOneWidget);
  });

  testWidgets('tapping another menu item opens the WebView with its id', (
    tester,
  ) async {
    await pumpHomePage(tester);
    await openMenu(tester);

    await tester.tap(find.text('Minhas Contratações'));
    await tester.pumpAndSettle();

    expect(find.text('WEBVIEW:minhas-contratacoes'), findsOneWidget);
  });

  testWidgets(
    'tapping a "Cotar e Contratar" category opens the WebView with its id',
    (tester) async {
      await pumpHomePage(tester);

      await tester.tap(find.text('Automóvel'));
      await tester.pumpAndSettle();

      expect(find.text('WEBVIEW:auto'), findsOneWidget);
    },
  );

  testWidgets('logging out navigates back to the login route', (tester) async {
    await pumpHomePage(tester);
    await openMenu(tester);

    await tester.tap(find.text('Sair'));
    await tester.pumpAndSettle();

    expect(find.text('LOGIN'), findsOneWidget);
  });
}
