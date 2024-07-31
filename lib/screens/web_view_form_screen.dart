import 'package:flutter/material.dart';

class WebViewScreen extends StatefulWidget {
  String url;
  WebViewScreen({super.key, required this.url});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text('Enviar solicitud'),

      ),
      body: Placeholder()

      //WebView(),
    );
  }



}
