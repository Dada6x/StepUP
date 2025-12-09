// main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:kyc_test/veriff_service.dart';
import 'package:veriff_flutter/veriff_flutter.dart';

void main() {
  runApp(const MaterialApp(home: KycPage()));
}

class KycPage extends StatefulWidget {
  const KycPage({super.key});

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
    // change to your server IP when testing on a real phone
    _backend = BackendService('http://192.168.1.2:3000');
    // 10.0.2.2 for Android emulator to reach localhost on your machine
  }

  Future<void> _startKyc() async {
    debugPrint('▶️ [UI] Start KYC pressed');
    setState(() {
      loading = true;
      result = '';
    });

    try {
      const userId = 'Yahiea Dada :3';

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
