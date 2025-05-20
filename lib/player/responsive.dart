import 'package:flutter/material.dart';

class Responsive extends StatelessWidget {
  const Responsive({super.key});

  static bool isTablet=false;

  @override
  Widget build(BuildContext context) {
    isTablet=(context.size?.width??0)>600;
    return const Placeholder();
  }
}
