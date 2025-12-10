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
    debugPrint('▶️ [UI] Start KYC pressed');
    setState(() {
      loading = true;
      result = '';
    });

    try {
      const userId = 'Billal DaaDaa ';

      // 1. Ask your backend to create Veriff session
      final sessionUrl = await _backend.createVeriffSession(userId);
      debugPrint('🔗 [UI] Backend gave sessionUrl: $sessionUrl');

      // 2. Start Veriff SDK
      final config = Configuration(sessionUrl);
      final veriff = Veriff();

      final sdkResult = await veriff.start(config);

      debugPrint('🎯 [UI] Veriff SDK status: ${sdkResult.status}');
      debugPrint('🎯 [UI] Veriff SDK error:  ${sdkResult.error}');

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
      debugPrint('💥 [UI] PlatformException: ${e.code} - ${e.message}');
      setState(() {
        result = 'PlatformException: ${e.code} - ${e.message}';
      });
    } catch (e, stack) {
      debugPrint('💥 [UI] Unknown error: $e');
      debugPrint('💥 [UI] stack: $stack');
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
    return Scaffold(
      appBar: AppBar(title: const Text('KYC Demo')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Veriff KYC with Express backend',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'This app calls our Express backend, which talks to Veriff.\n'
                        'No API keys are stored in the Flutter app.',
                      ),
                      const SizedBox(height: 20),
                      if (result.isNotEmpty)
                        Text(result, style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: loading ? null : _startKyc,
                  child: loading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Start KYC'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
