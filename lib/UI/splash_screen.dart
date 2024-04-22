import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartstep/UI/biometric_screen.dart';
import 'package:smartstep/main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  leavePage(context)async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool? isLogged = prefs.getBool('isLogged');
    if (isLogged == null || isLogged == false) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const BiometricScreen()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MyHomePage()),
      );
    }
   
  }

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 1500), () {
      leavePage(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF312f30), Color(0xFF1e1c1d)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                'SmartStep',
                style: GoogleFonts.spaceMono(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
