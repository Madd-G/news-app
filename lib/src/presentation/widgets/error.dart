import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:news_app/core/res/app_media.dart';

class Error extends StatelessWidget {
  final String message;

  const Error({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset(
          AppMedia.errorAnimation,
          width: 250,
          height: 200,
          fit: BoxFit.fill,
          repeat: false,
          reverse: false,
          animate: false,
        ),
        const SizedBox(height: 8),
        Text(message),
      ],
    );
  }
}
