sealed class WebviewState {
  const WebviewState();
}

final class WebviewLoading extends WebviewState {
  const WebviewLoading();
}

final class WebviewLoaded extends WebviewState {
  const WebviewLoaded();
}

final class WebviewLoadError extends WebviewState {
  const WebviewLoadError(this.message);

  final String message;
}
