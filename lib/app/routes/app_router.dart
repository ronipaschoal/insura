import 'package:go_router/go_router.dart';

import '../../core/di/injector.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/webview/presentation/pages/webview_page.dart';
import 'app_routes.dart';
import 'go_router_refresh_stream.dart';

abstract final class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.login,
    refreshListenable: GoRouterRefreshStream(getIt<AuthCubit>().stream),
    redirect: (context, state) {
      final isLoggedIn = getIt<AuthCubit>().isLoggedIn;
      final isLoggingIn = state.matchedLocation == AppRoutes.login;

      if (!isLoggedIn && !isLoggingIn) return AppRoutes.login;
      if (isLoggedIn && isLoggingIn) return AppRoutes.home;
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: AppRoutes.webview,
        builder: (context, state) {
          final params = state.uri.queryParameters;
          return WebviewPage(
            args: WebviewPageArgs(
              url: params['url'] ?? 'https://ronipaschoal.com.br/#/insura',
              title: params['title'] ?? 'WebView',
            ),
          );
        },
      ),
    ],
  );
}
