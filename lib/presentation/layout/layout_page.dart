import 'package:flutter/material.dart';
import 'package:kyc_test/presentation/layout/mobile/mobile_layout.dart';

class LayoutPage extends StatelessWidget {
  const LayoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return const MobileLayout();

          // return const DesktopLayout();
        },
      ),
    );
  }
}
