import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:io';

// ios 插件Flutter接入插件报错"Trying to embed a platform view but the PrerollContext does not support embedding"
// Info.plist中添加BOOL类型io.flutter.embedded_views_preview,值为YES
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

  WebViewController _controller;
  var _title;
  @override
  void initState() {
    super.initState();
    setState(() {
      //_controller.onProgressChanged
    });
  }

  @override
  Widget build(BuildContext context) {
    // _title = widget.navTtile; 这种复制方式会导致setdata没法执行
    //CupertinoPageScaffold 具有ios风格的布局 安卓可能运行不起来
    return Platform.isIOS
        ? CupertinoPageScaffold(
            // CupertinoNavigationBar 修改按钮和点击图片和点击事件
            //backgroundColor: CupertinoColors.systemRed,
            navigationBar: CupertinoNavigationBar(
                middle:
                    _title == null ? Text(widget.navTtile) : Text("$_title"),
                automaticallyImplyLeading: true,
                // 重新返回按钮
                // IconButton No Material widget found material组件必须外包一个 material根布局有Card, Dialog, Drawer Scaffold
                //
                // trailing: PreferredSize(
                //   child: progressBar(0.8, context),
                //   preferredSize: Size.fromHeight(0.1),
                // ),
                leading: Container(
                  child: Material(
                    color: Colors.transparent,
                    child: IconButton(
                        icon: Icon(Icons.backspace),
                        onPressed: () {
                          Future<bool> webviewCanGoBack =
                              _controller.canGoBack();
                          webviewCanGoBack.then((isWebBack) {
                            if (isWebBack) {
                              _controller.goBack();
                            } else {
                              Navigator.pop(context);
                            }
                          });
                        }),
                  ),
                )),
            child: SafeArea(child: creatWebView()),
          )
        : Scaffold(
            //preferredSize: Size.fromHeight(44),
            appBar: AppBar(
              title: Text("$_title"),
              leading: Container(
                child: Material(
                  color: Colors.transparent,
                  child: IconButton(
                      icon: Icon(Icons.backspace),
                      onPressed: () {
                        Future<bool> webviewCanGoBack = _controller.canGoBack();
                        webviewCanGoBack.then((isWebBack) {
                          if (isWebBack) {
                            _controller.goBack();
                          } else {
                            Navigator.pop(context);
                          }
                        });
                      }),
                ),
              ),
              bottom: PreferredSize(
                  child: progressBar(0.8, context),
                  preferredSize: Size.fromHeight(0.1)),
            ),
            body: creatWebView());
  }

// webview=== init
  WebView creatWebView() {
    return WebView(
      //showProgress: () {},
      initialUrl: widget.webURL,
      //运行js
      javascriptMode: JavascriptMode.unrestricted,
      // 监听
      onWebViewCreated: (controller) {
        _controller = controller;
        // _title = widget.navTtile;
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
    );
  }

// 加载进度条 没有实现WK监听方法
  progressBar(double progress, BuildContext context) {
    return Container(
      child: LinearProgressIndicator(
        backgroundColor: Colors.blueAccent.withOpacity(0),
        value: progress == 1.0 ? 0 : progress,
        valueColor: new AlwaysStoppedAnimation<Color>(Colors.lightBlue),
      ),
    );
  }
}
