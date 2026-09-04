import 'package:flutter/material.dart';
import 'package:studanky_flutter_app/core/styles/styles.dart';

class SheetGrabber extends StatelessWidget {
  const SheetGrabber({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Center(
        child: Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: context.appColors.neutral300,
            borderRadius: BorderRadius.circular(100),
          ),
        ),
      ),
    );
  }
}
