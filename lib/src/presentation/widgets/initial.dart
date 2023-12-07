import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:news_app/core/res/app_media.dart';

class Initial extends StatelessWidget {
  const Initial({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset(
          AppMedia.articlesAnimation,
          width: 200,
          height: 150,
          fit: BoxFit.fill,
          repeat: false,
          animate: true,
        ),
        const SizedBox(height: 8),
        const Text(
          'Search the News',
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
