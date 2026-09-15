import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/webview/presentation/pages/webview_page.dart';
import 'app_routes.dart';

abstract final class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.login,
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
              url: params['url'] ?? 'https://example.com',
              title: params['title'] ?? 'WebView',
            ),
          );
        },
      ),
    ],
  );
}
