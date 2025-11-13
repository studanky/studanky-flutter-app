import 'package:flutter/material.dart';
import 'package:studanky_flutter_app/core/styles/styles.dart';

class AppProgressIndicator extends StatelessWidget {
  const AppProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator.adaptive(
        valueColor: AlwaysStoppedAnimation<Color>(Styles.appColors.primaryMain),
      ),
    );
  }
}
