import 'package:flutter_test/flutter_test.dart';
import 'package:insura/core/di/injector.dart';
import 'package:insura/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:insura/features/webview/presentation/cubit/webview_cubit.dart';

void main() {
  setUp(setupInjector);
  tearDown(resetInjector);

  test('registers AuthCubit — read directly by AppRouter\'s redirect guard', () {
    // Not resolved here: building it pulls in the Firebase-backed
    // AuthRepository chain, which needs Firebase.initializeApp() (see
    // widget_test.dart for that path, exercised through the real App()).
    expect(getIt.isRegistered<AuthCubit>(), isTrue);
  });

  test('registers WebviewCubit as a factory (fresh instance per push)', () {
    expect(getIt.isRegistered<WebviewCubit>(), isTrue);
    expect(identical(getIt<WebviewCubit>(), getIt<WebviewCubit>()), isFalse);
  });
}
