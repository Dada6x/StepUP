import 'package:flutter/material.dart';

class NoEnoughBalance extends StatelessWidget {
  const NoEnoughBalance({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "YOu are POOR and dont have Enough Balance to be investor ",
        ),
      ),
    );
  }
}
