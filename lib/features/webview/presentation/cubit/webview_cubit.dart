import 'package:flutter_bloc/flutter_bloc.dart';

import 'webview_state.dart';

/// ViewModel for [WebviewPage]: tracks page-load progress reported by the
/// platform webview's navigation delegate.
class WebviewCubit extends Cubit<WebviewState> {
  WebviewCubit() : super(const WebviewLoading());

  void onPageStarted() => emit(const WebviewLoading());

  void onPageFinished() => emit(const WebviewLoaded());

  void onLoadError(String message) => emit(WebviewLoadError(message));
}
