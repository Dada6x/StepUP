import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart'; // <– for PlatformException
import 'package:kyc_test/presentation/layout/mobile/mobile_layout.dart';

class CommercialRegisterScreen extends StatefulWidget {
  const CommercialRegisterScreen({super.key});

  @override
  State<CommercialRegisterScreen> createState() =>
      _CommercialRegisterScreenState();
}

class _CommercialRegisterScreenState extends State<CommercialRegisterScreen> {
  String? _contractFileName;

  Future<void> _pickContractFile() async {
    try {
      // IMPORTANT: use the nullable type so we can check for cancel
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        withData: true, // helpful on web & for quick size/name access
      );

      // user pressed back / cancelled dialog
      if (result == null) {
        debugPrint('User cancelled file pick');
        return;
      }

      final PlatformFile file = result.files.single;
      debugPrint(
        'Picked file: ${file.name} (${file.size} bytes) / path: ${file.path}',
      );

      if (!mounted) return;

      setState(() {
        _contractFileName = file.name;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Selected: ${file.name}')));
    } on PlatformException catch (e, st) {
      // Catches “MissingPluginException” etc.
      debugPrint('PlatformException in file picker: $e\n$st');
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Platform error: ${e.message}')));
    } catch (e, st) {
      debugPrint('File pick error: $e\n$st');
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('File picker error: $e')));
    }
  }

  void _submit() {
    if (_contractFileName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please upload your commercial registration contract.'),
        ),
      );
      return;
    }

    // TODO: send data to backend

    Get.offAll(() => const MobileLayout());
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
                      'Commercial Registration',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 16),

                    const Text(
                      'Please provide your commercial registration details',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),

                    const SizedBox(height: 32),

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
                        ),
                      ),
                      child: Column(
                        children: [
                          const TextField(
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: 'Company Name',
                            ),
                          ),
                          const SizedBox(height: 18),

                          const TextField(
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: 'Commercial Registration Number',
                            ),
                          ),
                          const SizedBox(height: 18),

                          const TextField(
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: 'Company Domain (optional)',
                            ),
                          ),
                          const SizedBox(height: 18),

                          const SizedBox(height: 24),

                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Commercial registration contract',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),

                          InkWell(
                            borderRadius: BorderRadius.circular(8),
                            onTap: _pickContractFile,
                            child: Ink(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.5),
                                ),
                                color: Colors.white.withOpacity(0.03),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.upload_file,
                                    color: Colors.white.withOpacity(0.9),
                                    size: 20,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      _contractFileName ??
                                          'Upload contract ( Only PDF)',
                                      style: TextStyle(
                                        color: _contractFileName == null
                                            ? Colors.white.withOpacity(0.6)
                                            : Colors.white,
                                        fontSize: 13,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 32),

                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _submit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFB08B4F),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Submit Commercial Registration',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: size.height * 0.1),
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
