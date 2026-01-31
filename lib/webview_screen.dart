
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'no_internet_screen.dart';

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late WebViewController controller;
  bool loading = true;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => setState(() => loading = true),
          onPageFinished: (_) => setState(() => loading = false),
        ),
      )
      ..loadRequest(Uri.parse("https://slsmarts.com/"));
  }

  Future<void> checkInternet() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none && mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const NoInternetScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1D3146),
        elevation: 0,
        centerTitle: true,

        // 🔹 LOGO AT START
        leading: Padding(
          padding: const EdgeInsets.all(2.0),
          child: ClipOval(
            child: Image.asset(
              'assets/logo_transparent.png',
              width: 40,
              height: 40,
              fit: BoxFit.cover,
            ),
          ),
        ),


        // 🔹 CENTER TITLE
        title: const Text(
          'slsmarts.com',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 22,
          ),
        ),

        // 🔹 RIGHT ACTIONS
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () => controller.reload(),
          ),
        ],
      ),

      body: RefreshIndicator(
        onRefresh: () async {
          await checkInternet();
          controller.reload();
        },
        child: Stack(
          children: [
            WebViewWidget(controller: controller),
            if (loading)
              const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),

    );
  }
}
