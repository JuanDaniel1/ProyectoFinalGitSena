import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shop_app/screens/splash/splash_screen.dart';
import 'package:url_launcher/url_launcher.dart';


import '../face_auth/constants/constants.dart';
import '../face_auth/locator.dart';
import '../face_auth/services/camera.service.dart';
import '../face_auth/services/face_detector_service.dart';
import '../face_auth/services/ml_service.dart';


class MySplash extends StatefulWidget {
  static String routeName = "/firstSplash";
  const MySplash({super.key});

  @override
  State<MySplash> createState() => _MySplashState();
}

class _MySplashState extends State<MySplash> {



  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(

        splash: Lottie.asset('assets/SplashNice.json'),
        nextScreen: SplashScreen(),
      splashIconSize: 300,
      duration: 3000,
    );
  }
}
