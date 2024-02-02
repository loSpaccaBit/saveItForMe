import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:save_it_forme/models/bookMark.dart';

class WebView extends StatefulWidget {
  const WebView({Key? key, required this.bookMark}) : super(key: key);
  final BookMark bookMark;

  @override
  State<WebView> createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse('${widget.bookMark.url}'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        foregroundColor: Colors.transparent,
        toolbarHeight: 20,
        automaticallyImplyLeading: false,
      ),
      // body: GestureDetector(
      //   // onDoubleTap: () {
      //   //   _controller.goBack();
      //   // },
      //   onHorizontalDragUpdate: (DragUpdateDetails details) {
      //     // details.primaryDelta è la quantità di spostamento orizzontale
      //     if (details.primaryDelta! > 0) {
      //       _controller.goBack();
      //     }
      //   },
      body: WebViewWidget(
        controller: _controller,
      ),
      //),
    );
  }
}
