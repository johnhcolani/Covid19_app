
import 'package:covid19_app/screens/showCountries.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _handleSplash();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.teal,
      body: Center(
        child: Text(
          "Statistics of \nCovid-19",
          style: TextStyle(
              fontSize: 28, color: Colors.white, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  void _handleSplash() async {
    await Future.delayed(const Duration(seconds: 2));
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return ShowCountries();
    }));
  }
}
