import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kyc_test/presentation/pages/auth/no_enough_balance.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:kyc_test/core/services/saltedge_service.dart';
import 'package:kyc_test/presentation/layout/mobile/mobile_layout.dart';

class BankConnectWebView extends StatefulWidget {
  final String userId;
  final String connectUrl;

  const BankConnectWebView({
    super.key,
    required this.userId,
    required this.connectUrl,
  });

  @override
  State<BankConnectWebView> createState() => _BankConnectWebViewState();
}

class _BankConnectWebViewState extends State<BankConnectWebView> {
  late final WebViewController _controller;
  bool _isChecking = false;

  // MUST match your Node.js attempt.return_to value
  static const String kReturnToUrl = "https://example.com/after-connect";

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            debugPrint("Navigating to: ${request.url}");

            if (request.url.startsWith(kReturnToUrl)) {
              _onBankFlowFinished();
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.connectUrl));
  }

  Future<void> _onBankFlowFinished() async {
    if (_isChecking) return;

    setState(() {
      _isChecking = true;
    });

    // Get.snackbar(
    //   "Connected",
    //   "Bank connection completed! Checking balance...",
    //   backgroundColor: Colors.greenAccent,
    // );

    final hasMoney = await SaltEdgeService.checkMinBalance(
      widget.userId,
      2000,
    );

    if (hasMoney) {
      Get.snackbar(
        "Approved",
        "User has enough balance",
        backgroundColor: Colors.greenAccent,
      );
      Get.offAll(() => const MobileLayout());
    } else {
      Get.snackbar(
        "Rejected",
        "User does not have enough balance",
        backgroundColor: Colors.redAccent,
      );
      Get.offAll(() => NoEnoughBalance());
      Get.back(); // Back to BankScreen
    }

    if (mounted) {
      setState(() {
        _isChecking = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Connect your bank"),
        backgroundColor: const Color(0xFF042A2B),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isChecking)
            Container(
              color: Colors.black45,
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
