import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../cubit/webview_cubit.dart';
import '../cubit/webview_state.dart';

class WebviewPageArgs {
  const WebviewPageArgs({required this.url, required this.title});

  final String url;
  final String title;
}

class WebviewPage extends StatefulWidget {
  const WebviewPage({super.key, required this.args});

  final WebviewPageArgs args;

  @override
  State<WebviewPage> createState() => _WebviewPageState();
}

class _WebviewPageState extends State<WebviewPage> {
  late final WebviewCubit _cubit;
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _cubit = WebviewCubit();
    _controller = WebViewController();
    // webview_flutter_web only implements loadRequest/loadHtmlString - JS
    // mode and the navigation delegate throw UnimplementedError there.
    if (kIsWeb) {
      _cubit.onPageFinished();
    } else {
      _controller
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageStarted: (_) => _cubit.onPageStarted(),
            onPageFinished: (_) => _cubit.onPageFinished(),
            onWebResourceError: (error) =>
                _cubit.onLoadError(error.description),
          ),
        );
    }
    _controller.loadRequest(Uri.parse(widget.args.url));
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        appBar: AppBar(title: Text(widget.args.title)),
        body: BlocBuilder<WebviewCubit, WebviewState>(
          builder: (context, state) {
            return Stack(
              children: [
                WebViewWidget(controller: _controller),
                if (state is WebviewLoading) const LinearProgressIndicator(),
                if (state is WebviewLoadError)
                  Center(child: Text(state.message)),
              ],
            );
          },
        ),
      ),
    );
  }
}
