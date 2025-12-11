import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kyc_test/presentation/controllers/bank_controller.dart';

class BankScreen extends StatelessWidget {
  const BankScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final BankController controller = Get.put(BankController());

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF042A2B), Color(0xFF021416)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: size.width * 0.9),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top icon + title
                      Row(
                        children: [
                          Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              color: const Color(0xFF0C3C3F),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.account_balance_wallet_outlined,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'Connect Your Bank',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24, // was 22
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      const Text(
                        'Link your bank account securely via Salt Edge so we can '
                        'verify that you have at least \$5,000 available to qualify as an investor.',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14, // was 12
                          height: 1.4,
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Steps / mini stepper
                      const Text(
                        'How it works',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15, // was 13
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 12),

                      const _StepItem(
                        stepNumber: 1,
                        icon: Icons.link_outlined,
                        title: 'Connect via Salt Edge',
                        subtitle:
                            'You will be redirected to Salt Edge to select your bank and authorize access.',
                        isLast: false,
                      ),
                      const _StepItem(
                        stepNumber: 2,
                        icon: Icons.account_balance_outlined,
                        title: 'Link your bank account',
                        subtitle:
                            'Salt Edge securely links your account without sharing your credentials with us.',
                        isLast: false,
                      ),
                      const _StepItem(
                        stepNumber: 3,
                        icon: Icons.verified_outlined,
                        title: 'Automatic balance check',
                        subtitle:
                            'We verify that your available balance is at least \$5,000 to confirm eligibility.',
                        isLast: true,
                      ),

                      const SizedBox(height: 28),

                      // Button (same functionality)
                      Obx(
                        () => SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: controller.isLoading.value
                                ? null
                                : () async {
                                    // Starts the Salt Edge bank connection & verification flow
                                    await controller.startBankFlow();
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFF0EAE0),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 0,
                            ),
                            child: controller.isLoading.value
                                ? const SizedBox(
                                    height: 18,
                                    width: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: const [
                                      Text(
                                        'Connect Bank with Salt Edge',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 17, // was 15
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  height: 20,
                                  child: Image.asset(
                                    'assets/saltedge.png',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Powered by SaltEdge',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 13, // was 11
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StepItem extends StatelessWidget {
  final int stepNumber;
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isLast;

  const _StepItem({
    required this.stepNumber,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Number + line
        Column(
          children: [
            Container(
              height: 26,
              width: 26,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFF0EAE0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.35),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Text(
                stepNumber.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15, // was 13
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (!isLast) ...[
              const SizedBox(height: 4),
              Container(
                width: 2,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(width: 12),

        // Content
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon, color: Colors.white, size: 18),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15, // was 13
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13, // was 11
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
