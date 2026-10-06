import 'package:go_router/go_router.dart';
import 'package:webview_page/webview_page.dart';

import '../../core/di/injector.dart';
import '../../core/widgets/insura_app_bar.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/home/presentation/widgets/home_webview_targets.dart';
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
        // The url is fixed here, never read from the route: on web the route
        // is the browser address, so a crafted ?url= would open any site
        // inside the app. ?page= only picks the app bar's icon and title
        // from a fixed list (quote categories and side menu items); an
        // unknown one falls back to the logo.
        builder: (context, state) {
          final page = homeWebViewTargetById(state.uri.queryParameters['page']);
          return WebViewPage(
            url: 'https://webview.ronipaschoal.com.br/insura',
            appBar: InsuraAppBar(icon: page?.icon, title: page?.label),
            allowedHosts: const ['webview.ronipaschoal.com.br'],
            // The page is a Flutter web app, whose layout breaks under the
            // system font size's text zoom (e.g. 85%) — the page goes blank.
            androidTextZoom: 100,
          );
        },
      ),
    ],
  );
}
