# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project state

`insura` has a skeleton in place implementing the architecture below: a login screen, a home screen with responsive navigation (side menu on desktop/web, drawer on mobile), and a webview screen. Screens are functional as a shell (no real backend wired up — `ApiEndpoints.baseUrl` is a placeholder) but not yet fleshed out with real features.

This project is **mobile-first, with a web version**. Design and implement UI/UX for mobile screen sizes first, then adapt layouts for web/larger screens.

## Commands

- Install dependencies: `flutter pub get`
- Run the app: `flutter run`
- Static analysis (lint): `flutter analyze`
- Run all tests: `flutter test`
- Run a single test file: `flutter test test/widget_test.dart`
- Run a single test by name: `flutter test --plugin-name <name>` or `flutter test -n "<test description>"`
- Format code: `dart format .`

## Architecture

- `test/widget_test.dart` — widget tests, run via `flutter test`.
- Platform folders (`android/`, `ios/`, `web/`) contain the standard Flutter-generated platform embedding code; avoid hand-editing generated files there unless doing platform-specific configuration.
- Lint rules are defined in `analysis_options.yaml` via `package:flutter_lints/flutter.yaml`.

### Patterns

- **MVVM**: each screen/feature separates View (widgets in `presentation/pages` and `presentation/widgets`) from ViewModel (`presentation/cubit`), with the ViewModel exposing state to the View and containing no Flutter UI code.
- **State management**: `flutter_bloc`, using **Cubit** (not full Bloc event classes) as the ViewModel layer.
- **Dependency injection**: `get_it` as the service locator for repositories, data sources, and cubits, registered in `lib/core/di/injector.dart` against interfaces, not implementations.
- **HTTP client**: `HttpClient` (`lib/core/network/http_client.dart`) is the interface data sources depend on (`get`/`post`/`put`/`delete`, returning a transport-agnostic `HttpResponse<T>`); `DioClient` is its only implementation, wrapping `dio`. Data sources must never depend on `Dio`/`DioClient` directly — `get_it` injects `HttpClient`.
- **Result handling**: repository methods return `Result<Failure, S>` (`lib/core/result/result.dart`) instead of throwing — a hand-rolled `Either`-style sealed class with `ResultSuccess`/`ResultFailure` and a `fold` method. Do not add a functional-programming package (`dartz`/`fpdart`/etc.) for this — it's intentionally implemented in-project.
- **SOLID**: repositories and data sources are defined as `abstract interface class` in `domain/repositories` (or `data/datasources`), always in their own file, with the implementation in a sibling `..._impl.dart` file (e.g. `auth_repository.dart`/`auth_repository_impl.dart`, `auth_remote_datasource.dart`/`auth_remote_datasource_impl.dart`) — never combine interface and implementation in one file. `get_it` injects the interface, never the concrete class.
- **Routing**: `go_router` via `MaterialApp.router`, configured in `lib/app/routes/app_router.dart` (one `GoRoute` per screen); route path constants live in `app_routes.dart`. `main.dart` calls `usePathUrlStrategy()` (from `flutter_web_plugins`) so web URLs are path-based (`/home`) instead of hash-based (`/#/home`). Navigate with `context.go`/`context.push`, not `Navigator`. Screens needing dynamic data (e.g. `/webview`) read it from query parameters (`state.uri.queryParameters`) rather than route `arguments`/`extra`, so the URL is deep-link/refresh-safe — build target URLs with `Uri(path: ..., queryParameters: {...}).toString()`.
- **Webview screens**: `webview_flutter`, wrapped by the `webview` feature (`WebviewCubit` tracks load/error state from the platform `NavigationDelegate`). New webview screens should reuse `WebviewPage`/`WebviewPageArgs` (pass a different `url`/`title`) rather than creating a new page per URL. `webview_flutter_web` only implements `loadRequest`/`loadHtmlString` — `WebviewPage` guards `setJavaScriptMode`/`setNavigationDelegate` behind `kIsWeb` (both throw `UnimplementedError` on web) and immediately marks the page loaded there instead of tracking real progress. Note some sites also refuse to render in the web iframe entirely (`X-Frame-Options`/CSP `frame-ancestors`) — that's the target site's own restriction, not fixable app-side; `https://example.com` is a safe default for testing since it allows framing.
- **Responsive navigation**: `lib/core/responsive/responsive_scaffold.dart` picks a fixed `NavigationRail` side menu (width ≥ `Breakpoints.desktop`) or a `NavigationDrawer` (mobile) from one shared `List<NavigationDestination>` — add new destinations in `home_nav_destinations.dart`, not by duplicating nav UI per screen.

### Folder structure

Feature-first: each feature under `lib/features/<feature>/` has its own `data/` (datasources, models, repository impl), `domain/` (entities, repository interfaces), and `presentation/` (cubit, pages, widgets) — not every feature needs all three (e.g. `home` and `webview` currently have no `data`/`domain` layer since they don't call an API yet).

```
lib/
├── main.dart                    # usePathUrlStrategy() + setupInjector()
├── app/
│   ├── app.dart                 # MaterialApp.router + theme
│   └── routes/
│       ├── app_router.dart      # GoRouter config (GoRoute per screen)
│       └── app_routes.dart      # route path constants
├── core/
│   ├── di/injector.dart         # get_it setup (setupInjector/resetInjector)
│   ├── network/                 # http_client.dart (interface), dio_client.dart, api_endpoints.dart
│   ├── result/                  # result.dart (Either-style), failure.dart
│   ├── theme/                   # app_theme.dart, app_colors.dart
│   └── responsive/              # breakpoints.dart, responsive_scaffold.dart
└── features/
    ├── auth/         # login: data + domain + presentation (full layers)
    ├── home/         # home + responsive nav destinations
    └── webview/      # generic WebviewPage/WebviewPageArgs
```

## Conventions

- Commit messages follow Conventional Commits (`feat:`, `fix:`, `chore:`, etc.).
