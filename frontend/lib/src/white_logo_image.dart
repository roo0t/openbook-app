import 'package:flutter/material.dart';

class WhiteLogoImage extends StatelessWidget {
  const WhiteLogoImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Image(
      image: AssetImage('assets/images/logo_white.png'),
    );
  }
}
