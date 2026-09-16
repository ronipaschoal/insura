import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/domain/repositories/auth_repository.dart';
import 'home_state.dart';

/// ViewModel for [HomePage]: tracks which nav destination (drawer/side menu)
/// is selected and handles logging out.
class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._authRepository)
    : super(HomeState(userName: _authRepository.currentUser?.name ?? ''));

  final AuthRepository _authRepository;

  void selectDestination(int index) {
    emit(state.copyWith(selectedIndex: index));
  }

  Future<void> logout() async {
    await _authRepository.logout();
    emit(state.copyWith(loggedOut: true));
  }
}
