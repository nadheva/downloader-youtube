import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../downloader.dart';

class BrowserPage extends StatefulWidget {
  @override
  _BrowserPageState createState() => _BrowserPageState();
}

class _BrowserPageState extends State<BrowserPage> {
  final link = "https://www.youtube.com";
  WebViewController? _controller;

  bool _showDownloadButton = false;

  void checkUrl() async {
    if (await _controller!.currentUrl() == "https://m.youtube.com/") {
      setState(() {
        _showDownloadButton = false;
      });
    } else {
      setState(() {
        _showDownloadButton = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    checkUrl();
    return WillPopScope(
      onWillPop: () async {
        if (await _controller!.canGoBack()) {
          _controller!.goBack();
        }
        return false;
      },
      child: Scaffold(
        body: WebView(
          initialUrl: link,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (controller) {
            setState(() {
              _controller = controller;
            });
          },
        ),
        floatingActionButton: _showDownloadButton == false
            ? Container()
            : FloatingActionButton(
          backgroundColor: Colors.red,
          onPressed: () async {
            final url = await _controller!.currentUrl();
            final title = await _controller!.getTitle();
            print(title);

            ///Download the video
            Download().downloadVideo(url!, "$title" + ".");
          },
          child: Icon(Icons.download),
        ),
      ),
    );
  }
}
