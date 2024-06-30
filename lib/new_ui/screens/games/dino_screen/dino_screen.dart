// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(title: const Text('Flutter WebView Example')),
//         body: WebViewExample(),
//       ),
//     );
//   }
// }
//
// class WebViewExample extends StatefulWidget {
//   @override
//   _WebViewExampleState createState() => _WebViewExampleState();
// }
//
// class _WebViewExampleState extends State<WebViewExample> {
//   late WebViewController _controller;
//
//   @override
//   void initState() {
//     super.initState();
//     // Enable JavaScript mode and other configurations
//     WebView.platform = SurfaceAndroidWebView();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WebView(
//       initialUrl: 'about:blank',
//       onWebViewCreated: (WebViewController webViewController) {
//         _controller = webViewController;
//         _loadHtml();
//       },
//     );
//   }
//
//   void _loadHtml() async {
//     String htmlContent = '''
//       <!DOCTYPE html>
//       <html>
//         <head><title>Hi</title></head>
//         <body><h1>Hi</h1></body>
//       </html>
//     ''';
//
//     await _controller.loadHtmlString(htmlContent);
//   }
// }
