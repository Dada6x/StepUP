import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/route_manager.dart';
import 'package:country_picker/country_picker.dart';

import 'package:kyc_test/presentation/pages/auth/veriff/kyc_verriff.dart';
import 'package:kyc_test/presentation/pages/auth/login.dart';

class SignupScreen extends StatefulWidget {
  final String? role;

  const SignupScreen({super.key, this.role});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  bool _obscurePassword = true;

  Country? _selectedCountry;

  @override
  void initState() {
    super.initState();
    // Optional default country (Germany example):
    // _selectedCountry = CountryParser.parseCountryCode('DE');
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  bool _isGmail(String value) {
    final v = value.trim().toLowerCase();
    return RegExp(r'^[a-z0-9._%+\-]+@gmail\.com$').hasMatch(v);
  }

  void _pickCountry() {
    showCountryPicker(
      context: context,
      showPhoneCode: true,
      onSelect: (Country country) {
        setState(() {
          _selectedCountry = country;
        });
      },
    );
  }

  void _submit() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    if (_selectedCountry == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select your country code")),
      );
      return;
    }

    // Full phone example: +49XXXXXXXX
    final fullPhone =
        '+${_selectedCountry!.phoneCode}${phoneController.text.trim()}';
    debugPrint('EMAIL: ${emailController.text.trim()}');
    debugPrint('PHONE: $fullPhone');

    Get.to(() => KycPage(role: widget.role));
  }

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
                      'Create your Account',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 40),

                    Theme(
                      data: Theme.of(context).copyWith(
                        inputDecorationTheme: InputDecorationTheme(
                          hintStyle: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 14,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: Colors.white.withOpacity(0.5),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Colors.white,
                              width: 1.4,
                            ),
                          ),
                          errorStyle: const TextStyle(
                            color: Color(0xFFFFB4B4),
                            fontSize: 11,
                          ),
                        ),
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            /// EMAIL (must be gmail)
                            TextFormField(
                              controller: emailController,
                              style: const TextStyle(color: Colors.white),
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                hintText: 'Email',
                              ),
                              validator: (value) {
                                final v = (value ?? '').trim();
                                if (v.isEmpty) return 'Email is required';
                                if (!_isGmail(v))
                                  return 'Email must be @gmail.com';
                                return null;
                              },
                            ),

                            const SizedBox(height: 18),

                            /// PASSWORD WITH EYE ICON
                            TextFormField(
                              controller: passwordController,
                              style: const TextStyle(color: Colors.white),
                              obscureText: _obscurePassword,
                              decoration: InputDecoration(
                                hintText: 'Password',
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Colors.white70,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                              ),
                              validator: (value) {
                                final v = (value ?? '').trim();
                                if (v.isEmpty) return 'Password is required';
                                if (v.length < 6)
                                  return 'Password must be at least 6 chars';
                                return null;
                              },
                            ),

                            const SizedBox(height: 18),

                            /// COMBINED COUNTRY CODE + PHONE (ONE FIELD LOOK)
                            InputDecorator(
                              decoration: const InputDecoration(
                                hintText: 'Phone number',
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      /// COUNTRY CODE SELECTOR
                                      GestureDetector(
                                        onTap: _pickCountry,
                                        child: Row(
                                          children: [
                                            Text(
                                              _selectedCountry == null
                                                  ? '+---'
                                                  : '${_selectedCountry!.flagEmoji} +${_selectedCountry!.phoneCode}',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            const Icon(
                                              Icons.arrow_drop_down,
                                              color: Colors.white70,
                                            ),
                                          ],
                                        ),
                                      ),

                                      const SizedBox(width: 12),

                                      /// PHONE INPUT (DIGITS ONLY)
                                      Expanded(
                                        child: TextFormField(
                                          controller: phoneController,
                                          keyboardType: TextInputType.phone,
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                          ],
                                          decoration: const InputDecoration(
                                            enabledBorder: OutlineInputBorder(
                                              
                                              borderSide: BorderSide.none,
                                            ),
                                            
                                            hintText: 'Phone number',
                                            border: InputBorder.none,
                                            isDense: false,
                                            contentPadding: EdgeInsets.zero,
                                          ),
                                          validator: (value) {
                                            final v = (value ?? '').trim();
                                            if (_selectedCountry == null) {
                                              return 'Select country code';
                                            }
                                            if (v.isEmpty)
                                              return 'Phone number is required';
                                            if (v.length < 7)
                                              return 'Enter a valid phone number';
                                            return null;
                                          },
                                        ),
                                      ),
                                    ],
                                  ),

                                  /// COUNTRY NAME (nice UX)
                                  if (_selectedCountry != null)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 6),
                                      child: Text(
                                        _selectedCountry!.name,
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.white.withOpacity(0.6),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 18),

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
                                  onPressed: _submit,
                                  icon: const SizedBox.shrink(),
                                  label: Row(
                                    children: const [
                                      Text(
                                        'Create account',
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
                      ),
                    ),

                    SizedBox(height: size.height * 0.12),

                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 1,
                            color: Colors.white.withOpacity(0.25),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Or continue with',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            height: 1,
                            color: Colors.white.withOpacity(0.25),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: 160,
                        height: 40,
                        child: OutlinedButton(
                          onPressed: () {},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: SvgPicture.asset(
                                  "assets/Google.svg",
                                  width: 35,
                                  height: 35,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Text(
                                'Google',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 36),

                    Align(
                      child: GestureDetector(
                        onTap: () {
                          Get.off(() => const LoginScreen());
                        },
                        child: const Text(
                          "Already have an account? Log in",
                          style: TextStyle(
                            color: Color(0xFFF0EAE0),
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
