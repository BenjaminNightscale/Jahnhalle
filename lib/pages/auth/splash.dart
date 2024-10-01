import 'package:flutter/material.dart';
import 'package:jahnhalle/main.dart';
import 'package:jahnhalle/pages/auth/login.dart';
import 'package:jahnhalle/pages/home/main_dashboard.dart';
import 'package:jahnhalle/components/utils/keys.dart';
import 'package:jahnhalle/components/utils/sp.dart';
import 'package:jahnhalle/components/widgets/image_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      final isLogin = SP.i.getString(key: SPKeys.isLoggedIn);
      if (isLogin == null) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
          (route) => false,
        );
      } else {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const MainDashboard(),
          ),
          (route) => false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xffE4EDCA),
        body: Center(
          child: ImageWidget(
            url: "assets/images/jahnhalle_logo_black 1.png",
            height: dimensions.width * 0.5,
            width: dimensions.width * 0.5,
          ),
        ));
  }
}
