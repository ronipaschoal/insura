import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/auth_repository.dart';
import 'auth_state.dart';

/// App-wide session ViewModel, consumed by [AppRouter]'s redirect guard so
/// routing depends on a Cubit like every other screen, instead of reading
/// [AuthRepository] directly. Registered as a lazy singleton (unlike the
/// other, per-page factory cubits) because `AppRouter.router` is a single
/// static field built once for the whole app, not scoped to a page's widget
/// tree.
class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._authRepository)
    : super(AuthState(isLoggedIn: _authRepository.isLoggedIn)) {
    _subscription = _authRepository.authStateChanges.listen(
      (isLoggedIn) => emit(AuthState(isLoggedIn: isLoggedIn)),
    );
  }

  final AuthRepository _authRepository;
  late final StreamSubscription<bool> _subscription;

  /// Reads the session state straight from [AuthRepository] rather than
  /// [state] — the redirect guard runs synchronously right after an explicit
  /// login/logout navigation, before the `authStateChanges` stream (which
  /// only drives [state]/[stream] for [AppRouter]'s `refreshListenable`) is
  /// guaranteed to have delivered its next event.
  bool get isLoggedIn => _authRepository.isLoggedIn;

  @override
  Future<void> close() {
    unawaited(_subscription.cancel());
    return super.close();
  }
}
