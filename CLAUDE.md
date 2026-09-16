# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project state

`insura` has a skeleton in place implementing the architecture below: a login screen (CPF + password via Firebase Authentication, with a Firestore `cpfIndex` lookup that can also carry a `name` field, "remember me", and a `go_router` auth redirect guard), a home dashboard (welcome banner, "Cotar e Contratar" category grid that opens the webview screen, and empty-state cards) behind a collapsible side menu (`AppSideMenu`: user avatar/name header, 10 nav destinations, logout — desktop sidebar / mobile drawer), and a generic webview screen. Only "Home/Seguros" and the quote categories have real destinations today; the other 9 side menu items show a "Em breve!" placeholder. There is no REST backend — only Firebase (Auth + Firestore) is wired up so far.

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
- **Result handling**: repository methods return `Result<Failure, S>` (`lib/core/result/result.dart`) instead of throwing — a hand-rolled `Either`-style sealed class with `ResultSuccess`/`ResultFailure` and a `fold` method. Do not add a functional-programming package (`dartz`/`fpdart`/etc.) for this — it's intentionally implemented in-project.
- **SOLID**: repositories and data sources are defined as `abstract interface class` in `domain/repositories` (or `data/datasources`), always in their own file, with the implementation in a sibling `..._impl.dart` file (e.g. `auth_repository.dart`/`auth_repository_impl.dart`, `auth_remote_datasource.dart`/`auth_remote_datasource_impl.dart`) — never combine interface and implementation in one file. `get_it` injects the interface, never the concrete class.
- **Routing**: `go_router` via `MaterialApp.router`, configured in `lib/app/routes/app_router.dart` (one `GoRoute` per screen); route path constants live in `app_routes.dart`. Web URLs are hash-based (`/#/home`) — the deployed host has no server-side rewrite rule to fall back to `index.html` for deep links, so switching to `usePathUrlStrategy()` (path-based, `/home`) would 404 on a direct/refreshed visit to any route but `/`. Navigate with `context.go`/`context.push`, not `Navigator`. Screens needing dynamic data (e.g. `/webview`) read it from query parameters (`state.uri.queryParameters`) rather than route `arguments`/`extra`, so the URL is deep-link/refresh-safe — build target URLs with `Uri(path: ..., queryParameters: {...}).toString()`.
- **Webview screens**: `webview_flutter`, wrapped by the `webview` feature (`WebviewCubit` tracks load/error state from the platform `NavigationDelegate`). New webview screens should reuse `WebviewPage`/`WebviewPageArgs` (pass a different `url`/`title`) rather than creating a new page per URL — e.g. every "Cotar e Contratar" category on Home pushes `/webview` with only `title` set (`HomePage._onQuoteCategoryTap`), so they all fall back to `app_router.dart`'s default `url`. `webview_flutter_web` only implements `loadRequest`/`loadHtmlString` — `WebviewPage` guards `setJavaScriptMode`/`setNavigationDelegate` behind `kIsWeb` (both throw `UnimplementedError` on web) and immediately marks the page loaded there instead of tracking real progress. Note some sites also refuse to render in the web iframe entirely (`X-Frame-Options`/CSP `frame-ancestors`) — that's the target site's own restriction, not fixable app-side; prefer a URL known to allow framing as the default.
- **Responsive navigation**: `lib/core/responsive/responsive_scaffold.dart` renders `AppSideMenu` (user avatar/name header + nav item list + logout) either as a fixed, collapsible sidebar (width ≥ `Breakpoints.desktop`; the app bar menu button toggles `expanded`/`collapsed`, with a `_menuContentExpanded` lag on the state so the header/labels don't overflow while the sidebar is still animating wider) or inside a plain `Drawer` (mobile) — both built from one shared `List<NavigationDestination>`. Add new destinations in `home_nav_destinations.dart`, not by duplicating nav UI per screen.

### Folder structure

Feature-first: each feature under `lib/features/<feature>/` has its own `data/` (datasources, models, repository impl), `domain/` (entities, repository interfaces), and `presentation/` (cubit, pages, widgets) — not every feature needs all three (e.g. `home` and `webview` currently have no `data`/`domain` layer since they don't call an API yet).

```
lib/
├── main.dart                    # Firebase.initializeApp() + setupInjector()
├── app/
│   ├── app.dart                 # MaterialApp.router + theme
│   └── routes/
│       ├── app_router.dart      # GoRouter config (GoRoute per screen)
│       └── app_routes.dart      # route path constants
├── core/
│   ├── di/injector.dart         # get_it setup (setupInjector/resetInjector)
│   ├── result/                  # result.dart (Either-style), failure.dart
│   ├── theme/                   # app_theme.dart, app_colors.dart
│   ├── widgets/                 # insura_logo.dart (shared brand mark)
│   └── responsive/              # breakpoints.dart, app_side_menu.dart, responsive_scaffold.dart
└── features/
    ├── auth/         # login: data + domain + presentation (full layers); AuthRepository also exposes currentUser
    ├── home/         # dashboard (welcome banner, quote categories, placeholder cards) + shared side menu destinations
    └── webview/      # generic WebviewPage/WebviewPageArgs
```

## Conventions

- Commit messages follow Conventional Commits (`feat:`, `fix:`, `chore:`, etc.).
