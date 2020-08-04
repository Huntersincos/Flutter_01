import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BaseWebView extends StatefulWidget {
  BaseWebView({Key key, @required this.webURL, @required this.navTtile})
      : super(key: key);

  final String webURL;
  final String navTtile;

  @override
  _BaseWebView createState() {
    return _BaseWebView();
  }
}

class _BaseWebView extends State<BaseWebView> {
  // FlutterWebviewPlugin flutterWebviewPlugin = FlutterWebviewPlugin()
  // WebView baseWebView = WebView();
  // @override
  // void initState() {
  //   super.initState();

  // }
  WebViewController _controller;
  var _title;
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("$_title"),
      ),
      child: SafeArea(
        child: WebView(
          initialUrl: widget.webURL,
          //运行js
          javascriptMode: JavascriptMode.unrestricted,
          // 监听
          onWebViewCreated: (controller) {
            _controller = controller;
            _title = widget.navTtile;
          },
          onPageFinished: (url) {
            // js监听
            _controller.evaluateJavascript("document.title").then((result) {
              setState(() {
                _title = result;
              });
            });
          },
          navigationDelegate: (NavigationRequest request) {
            if (request.url.startsWith("gxmobile://")) {
              // 拦截处理
              return NavigationDecision.prevent;
            }
            // 不需要链接处理
            return NavigationDecision.navigate;
          },
          onWebResourceError: (error) {
            // 界面加载错误
            print(error.description);
          },
          // 注入js
          javascriptChannels: <JavascriptChannel>[
            JavascriptChannel(
                name: 'name',
                onMessageReceived: (JavascriptMessage message) {
                  print("参数： ${message.message}");
                })
          ].toSet(),
        ),
      ),
    );
  }
}
