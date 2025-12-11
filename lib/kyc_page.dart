import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kyc_test/main.dart';
import 'package:kyc_test/presentation/pages/auth/bank_screen.dart';
import 'package:kyc_test/presentation/pages/auth/commercial_register_screen.dart';
import 'package:kyc_test/veriff_service.dart';
import 'package:veriff_flutter/veriff_flutter.dart';

class KycPage extends StatefulWidget {
  final String? role;

  const KycPage({super.key, this.role});

  @override
  State<KycPage> createState() => _KycPageState();
}

class _KycPageState extends State<KycPage> {
  bool loading = false;
  String result = '';

  late BackendService _backend;

  @override
  void initState() {
    super.initState();
    _backend = BackendService("http://${LaptopIp}:3000");
  }

  Future<void> _startKyc() async {
    setState(() {
      loading = true;
      result = '';
    });

    try {
      //! also should be taken from the FORM of SIGNUP
      const userId = 'Billal DaaDaa ';

      // 1. Ask your backend to create Veriff session
      final sessionUrl = await _backend.createVeriffSession(userId);

      // 2. Start Veriff SDK
      final config = Configuration(sessionUrl);
      final veriff = Veriff();

      final sdkResult = await veriff.start(config);

      setState(() {
        if (sdkResult.status == Status.done) {
          result = '✅ Completed! Check Veriff dashboard for details.';
          // Navigate to appropriate screen based on role after successful KYC
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (widget.role == 'investor') {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const BankScreen()),
              );
            } else if (widget.role == 'startup') {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const CommercialRegisterScreen(),
                ),
              );
            }
          });
        } else if (sdkResult.status == Status.canceled) {
          result = '❌ User canceled the verification.';
        } else {
          result = '⚠️ SDK error: ${sdkResult.error}';
        }
      });
    } on PlatformException catch (e) {
      setState(() {
        result = 'PlatformException: ${e.code} - ${e.message}';
      });
    } catch (e, stack) {
      setState(() {
        result = 'Unknown error: $e';
      });
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      // removed AppBar to match BankScreen style
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
                      // Top icon + title (same style as BankScreen)
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
                              Icons.verified_user_outlined,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'Verify Your Identity',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      const Text(
                        'We use Veriff to verify your identity securely. '
                        'This helps us keep the platform safe and compliant.',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Steps / mini stepper (same style concept as bank steps)
                      const Text(
                        'How it works',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 12),

                      const _StepItem(
                        stepNumber: 1,
                        icon: Icons.credit_card_outlined,
                        title: 'Scan your ID document',
                        subtitle:
                            'Use a valid government-issued ID such as a passport, ID card, or driver’s license.',
                        isLast: false,
                      ),
                      const _StepItem(
                        stepNumber: 2,
                        icon: Icons.photo_camera_outlined,
                        title: 'Take a selfie',
                        subtitle:
                            'Follow the on-screen instructions so Veriff can match your selfie with your document.',
                        isLast: false,
                      ),
                      const _StepItem(
                        stepNumber: 3,
                        icon: Icons.shield_outlined,
                        title: 'Automatic verification',
                        subtitle:
                            'Veriff checks your document and selfie. Once done, we’ll continue your onboarding.',
                        isLast: true,
                      ),

                      const SizedBox(height: 24),

                      // Result / status message (keeps same functionality)
                      if (result.isNotEmpty) ...[
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.06),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.12),
                            ),
                          ),
                          child: Text(
                            result,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              height: 1.3,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],

                      // Button (same functionality, styled like bank button)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: loading ? null : _startKyc,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFB08B4F),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 0,
                          ),
                          child: loading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  'Start KYC verification',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Powered by Veriff (similar style to Powered by SaltEdge)
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
                                // Optional: add Veriff logo asset (make sure you have it in assets)
                                // Place a logo at assets/veriff.png and declare in pubspec.yaml
                                SizedBox(
                                  height: 20,
                                  child: Image.asset(
                                    'assets/veriff.png',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Powered by Veriff',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 13,
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
        // Number + line (same visual language as bank flow)
        Column(
          children: [
            Container(
              height: 26,
              width: 26,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFB08B4F),
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
                  fontSize: 15,
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
                          fontSize: 15,
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
                    fontSize: 13,
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
