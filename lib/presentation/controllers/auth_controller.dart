import 'package:get/get.dart';
import 'package:kyc_test/presentation/pages/auth/bank_screen.dart';
import 'package:kyc_test/presentation/pages/auth/commercial_register_screen.dart';
import 'package:kyc_test/kyc_page.dart';
import 'package:kyc_test/presentation/pages/auth/signup.dart';

class AuthController extends GetxController {
  RxString currentRole = ''.obs;
  RxBool isKycCompleted = false.obs;

  // Set the user role
  void setRole(String role) {
    currentRole.value = role;
  }

  // Navigate to signup screen with role
  void navigateToSignup() {
    if (currentRole.value.isEmpty) {
      print('No role selected');
      return;
    }

    Get.to(() => SignupScreen(role: currentRole.value));
  }

  // Navigate to KYC screen with role
  void navigateToKyc() {
    if (currentRole.value.isEmpty) {
      print('No role selected');
      return;
    }

    Get.to(() => KycPage(role: currentRole.value));
  }

  // Navigate to appropriate screen after KYC based on role
  void navigateAfterKyc() {
    if (currentRole.value == 'investor') {
      Get.offAll(() => const BankScreen());
    } else if (currentRole.value == 'startup') {
      Get.offAll(() => const CommercialRegisterScreen());
    } else {
      print('Unknown role: ${currentRole.value}');
    }
  }

  // Complete KYC process
  void completeKyc() {
    isKycCompleted.value = true;
    navigateAfterKyc();
  }
}