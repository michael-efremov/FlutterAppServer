import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class AppWebView extends StatelessWidget {
  final String title;
  final String selectedUrl;

  bool _isBack = false;
  InAppWebViewController _controller;

  AppWebView({
    @required this.title,
    @required this.selectedUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: WillPopScope(onWillPop: onBackPressed, child: InAppWebView(
                initialUrl: selectedUrl,
                onConsoleMessage: onMessage,
                onLoadStart: onLoadStart,
                onLoadStop: onLoadStop,
                shouldOverrideUrlLoading: shouldOverrideUrlLoading,
                initialOptions: InAppWebViewGroupOptions(
                    crossPlatform: InAppWebViewOptions(
                        useShouldOverrideUrlLoading: true,
                        javaScriptEnabled: true,
                        cacheEnabled: true,
                        javaScriptCanOpenWindowsAutomatically: true
                    )),
                onWebViewCreated: setController
            ))
        ));
  }

  Future<bool> onBackPressed() async {
    _isBack = true;

    if (await _controller.canGoBack()) {
      _controller.goBack();
      return false;
    } else {
      return true;
    }
  }

  void onMessage(InAppWebViewController controller, ConsoleMessage consoleMessage) {
    print(consoleMessage.message);
  }

  void onLoadStart(InAppWebViewController controller, String url) async {
    bool canBack = await controller.canGoBack();

    if (url == selectedUrl && _isBack && !canBack) {
      exit(0);
    }
    _isBack = false;
  }

  void onLoadStop(InAppWebViewController controller, String url) {
    print(url);
  }

  Future<ShouldOverrideUrlLoadingAction> shouldOverrideUrlLoading(InAppWebViewController controller, ShouldOverrideUrlLoadingRequest shouldOverrideUrlLoadingRequest) async {
    if (shouldOverrideUrlLoadingRequest.url.contains("doceditor")) {
      openEditor(shouldOverrideUrlLoadingRequest);
      return ShouldOverrideUrlLoadingAction.CANCEL;
    } else {
      return ShouldOverrideUrlLoadingAction.ALLOW;
    }
  }

  void setController(InAppWebViewController controller) {
    _controller = controller;
  }

  void openEditor(ShouldOverrideUrlLoadingRequest shouldOverrideUrlLoadingRequest) {
    InAppBrowser().openUrl(url: shouldOverrideUrlLoadingRequest.url,
        headers: shouldOverrideUrlLoadingRequest.headers,
        options: InAppBrowserClassOptions(crossPlatform: InAppBrowserOptions(
            toolbarTop: false,
            hideUrlBar: true
        )));
  }
}
