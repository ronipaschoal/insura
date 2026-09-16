import 'dart:async';

import 'package:flutter/foundation.dart';

/// Bridges a [Stream] (here, `AuthRepository.authStateChanges`) into a
/// [Listenable] so `GoRouter.redirect` re-evaluates whenever auth state
/// changes in the background, not just on explicit navigation.
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
