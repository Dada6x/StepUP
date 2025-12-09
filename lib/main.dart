import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:veriff_flutter/veriff_flutter.dart';

import 'veriff_service.dart';

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
  String result = "";

  late VeriffService _veriff;

  @override
  void initState() {
    super.initState();

    // 🔴 Replace these with your real values
    _veriff = VeriffService(
      baseUrl: "https://stationapi.veriff.com", // this is what you used in logs
      apiKey:
          "026a0790-d8dd-4286-a6a4-bce47559f301", // your key (example from log)
      masterSecret: "YOUR_MASTER_KEY_HERE",
    );
  }

  Future<void> _startKyc() async {
    debugPrint('▶️ [UI] Start KYC pressed');
    setState(() {
      loading = true;
      result = "";
    });

    try {
      const userId = "Yahiea Dada :3 ";
      debugPrint('👤 [UI] Using vendorData / userId: $userId');

      // 1. Create session directly from app
      final sessionUrl = await _veriff.createSession(userId);
      debugPrint('🔗 [UI] Received sessionUrl: $sessionUrl');

      // 2. Start Veriff SDK
      final config = Configuration(sessionUrl);
      final veriff = Veriff();

      debugPrint('🚀 [UI] Launching Veriff SDK...');
      final sdkResult = await veriff.start(config);

      debugPrint('🎯 [UI] Veriff SDK finished');
      debugPrint('🎯 [UI] status: ${sdkResult.status}');
      debugPrint('🎯 [UI] error:  ${sdkResult.error}');

      setState(() {
        if (sdkResult.status == Status.done) {
          result = "✅ Completed! Check Veriff dashboard for details.";
        } else if (sdkResult.status == Status.canceled) {
          result = "❌ User canceled the verification.";
        } else {
          result = "⚠️ Error from SDK: ${sdkResult.error}";
        }
      });
    } on PlatformException catch (e) {
      debugPrint('💥 [UI] PlatformException from Veriff SDK');
      debugPrint('💥 [UI] code:    ${e.code}');
      debugPrint('💥 [UI] message: ${e.message}');
      debugPrint('💥 [UI] details: ${e.details}');

      setState(() {
        result = "PlatformException: ${e.code} - ${e.message}";
      });
    } catch (e, stack) {
      debugPrint('💥 [UI] Unknown error in _startKyc: $e');
      debugPrint('💥 [UI] Stack trace: $stack');
      setState(() {
        result = "Unknown error: $e";
      });
    } finally {
      setState(() {
        loading = false;
      });
      debugPrint('⏹ [UI] KYC flow finished (loading=false)');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("KYC Demo")),
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
                        "Veriff KYC Example (No Backend)",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        "Tap the button to create a Veriff session and start the SDK.\n"
                        "Check your IDE console for detailed logs.",
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
                      : const Text("Start KYC"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
