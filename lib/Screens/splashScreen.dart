import 'package:baatain/Screens/homeScreen.dart';
import 'package:baatain/Screens/intropage.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double opacity = 0.0;
  void changeOpacity() {
    setState(() => opacity = opacity == 0 ? 1.0 : 0.0);
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      changeOpacity();
    });
    Future.delayed(Duration(seconds: 5), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => IntroScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black,
      body: Column(
        // crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: AnimatedOpacity(
              opacity: opacity,
              duration: Duration(seconds: 2),
              child: SizedBox(
                  height: 130,
                  width: 140,
                  child: Image.asset('assets/logo.png')),
            ),
          ),
          // ElevatedButton(
          //     onPressed: () {
          //       changeOpacity();
          //     },
          //     child: Text('btn'))
        ],
      ),
    );
  }
}
