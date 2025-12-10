import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:kyc_test/presentation/layout/mobile/mobile_layout.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:kyc_test/presentation/pages/auth/login.dart';

class ResetPinScreen extends StatelessWidget {
  const ResetPinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),

                    const Text(
                      'Enter verification code',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 40),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "We’ve sent a 6-digit code to your email.",
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                        const SizedBox(height: 16),

                        // === PIN CODE FIELDS ===
                        PinCodeTextField(
                          appContext: context,
                          length: 6,
                          keyboardType: TextInputType.number,
                          cursorColor: Colors.white,
                          textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                          autoDismissKeyboard: true,
                          enableActiveFill: false,
                          pinTheme: PinTheme(
                            shape: PinCodeFieldShape.box,
                            borderRadius: BorderRadius.circular(8),
                            fieldHeight: 48,
                            fieldWidth: 40,
                            activeColor: Colors.white,
                            selectedColor: Colors.white,
                            inactiveColor: Colors.white.withOpacity(0.5),
                            activeFillColor: Colors.transparent,
                            selectedFillColor: Colors.transparent,
                            inactiveFillColor: Colors.transparent,
                          ),
                          onChanged: (value) {
                            // you can listen to changes here if needed
                          },
                          onCompleted: (value) {
                            // TODO: verify code + navigate to next step (e.g. new password screen)
                          },
                        ),

                        const SizedBox(height: 24),

                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 1,
                                color: Colors.white.withOpacity(0.4),
                              ),
                            ),
                            const SizedBox(width: 12),
                            TextButton.icon(
                              onPressed: () {
                                Get.offAll(() => MobileLayout());
                              },
                              icon: const SizedBox.shrink(),
                              label: Row(
                                children: const [
                                  Text(
                                    'Verify code',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.white70,
                                    ),
                                  ),
                                  SizedBox(width: 6),
                                  Icon(
                                    Icons.arrow_forward,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    SizedBox(height: size.height * 0.12),

                    const SizedBox(height: 24),

                    const SizedBox(height: 36),

                    Align(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LoginScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          "Remembered your password? Log in",
                          style: TextStyle(
                            color: Color(0xFFB08B4F),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
