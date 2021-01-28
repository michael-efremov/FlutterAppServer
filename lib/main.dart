import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onlyoffice_workspace/AppWebView.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            visualDensity: VisualDensity.adaptivePlatformDensity,
            accentColor: Color.fromARGB(255, 237, 115, 9)),
        home: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle(
                statusBarColor: Color.fromARGB(255, 15, 64, 113)),
            child: Scaffold(
                body: AppWebView(
                    selectedUrl: "https://dotnet.onlyoffice.com:8093/",
                    title: "Test"))));
  }
}
