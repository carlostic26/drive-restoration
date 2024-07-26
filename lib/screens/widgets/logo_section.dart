import 'package:flutter/material.dart';

class LogoSection extends StatelessWidget {
  const LogoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 150, width: 150, child: Image.asset('assets/dash.png')
        //Placeholder()
        );
  }
}
