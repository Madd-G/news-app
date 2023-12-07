import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:news_app/core/res/app_media.dart';
import 'package:news_app/core/utils/app_colors.dart';
import 'main_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    Timer(const Duration(milliseconds: 2000), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainPage()),
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: Center(
          child: SizedBox(
            height: 330,
            width: 300,
            child: Lottie.asset(
              AppMedia.rocketAnimation,
              width: 350,
              height: 350,
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }
}
