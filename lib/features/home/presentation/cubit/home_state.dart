final class HomeState {
  const HomeState({this.selectedIndex = 0, this.loggedOut = false});

  final int selectedIndex;
  final bool loggedOut;

  HomeState copyWith({int? selectedIndex, bool? loggedOut}) {
    return HomeState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      loggedOut: loggedOut ?? this.loggedOut,
    );
  }
}
