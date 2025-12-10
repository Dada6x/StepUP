import 'package:get/get.dart';
import 'package:kyc_test/core/services/saltedge_service.dart';
import 'package:kyc_test/presentation/pages/auth/bank_connect_webview.dart';

class BankController extends GetxController {
  final isLoading = false.obs;

  // For demo we keep it static
  final String userId = "bilal";

  Future<void> startBankFlow() async {
    if (isLoading.value) return;

    isLoading.value = true;
    try {
      // 1) Create customer
      final ok = await SaltEdgeService.createCustomer(userId);
      if (!ok) {
        Get.snackbar(
          "Error",
          "Failed to create bank customer",
        );
        return;
      }

      // 2) Create connect session
      final connectUrl = await SaltEdgeService.createConnectSession(userId);
      if (connectUrl == null) {
        Get.snackbar(
          "Error",
          "Failed to get bank connect URL",
        );
        return;
      }

      // 3) Go to WebView
      Get.to(
        () => BankConnectWebView(
          userId: userId,
          connectUrl: connectUrl,
        ),
      );
    } finally {
      isLoading.value = false;
    }
  }
}
