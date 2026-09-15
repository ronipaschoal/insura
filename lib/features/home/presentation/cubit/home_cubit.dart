import 'package:flutter_bloc/flutter_bloc.dart';

import 'home_state.dart';

/// ViewModel for [HomePage]: tracks which nav destination (drawer/side menu)
/// is selected.
class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState());

  void selectDestination(int index) {
    emit(state.copyWith(selectedIndex: index));
  }
}
