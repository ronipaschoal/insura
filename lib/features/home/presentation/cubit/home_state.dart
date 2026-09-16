final class HomeState {
  const HomeState({
    this.selectedIndex = 0,
    this.loggedOut = false,
    this.userName = '',
  });

  final int selectedIndex;
  final bool loggedOut;
  final String userName;

  HomeState copyWith({int? selectedIndex, bool? loggedOut, String? userName}) {
    return HomeState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      loggedOut: loggedOut ?? this.loggedOut,
      userName: userName ?? this.userName,
    );
  }
}
