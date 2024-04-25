import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:smartstep/main.dart';

import '../models/ble_scan_connect.dart';

class BiometricScreen extends StatefulWidget {
  const BiometricScreen({super.key});

  @override
  State<BiometricScreen> createState() => _BiometricState();
}

class _BiometricState extends State<BiometricScreen> {
  bool checkweight = false;
  int weight = 0;
  BleScanConnect bleScanConnect = BleScanConnect();
  late List<BluetoothDevice> devices;
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
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: CustomMaterialIndicator(
            onRefresh: () => Future(() async {
              devices = await bleScanConnect.scan() as List<BluetoothDevice>;
            }), // Your refresh logic
            indicatorBuilder: (context, controller) {
              return Icon(
                Icons.ac_unit,
                color: Theme.of(context).colorScheme.primary,
                size: 30,
              );
            },
            child: ListView(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    Text('Welcome',
                        style: GoogleFonts.spaceMono(
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                    Text('to',
                        style: GoogleFonts.spaceMono(
                            fontSize: 35,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                    Text('SmartStep!',
                        style: GoogleFonts.spaceMono(
                            fontSize: 45,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(
                      height: 40,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Please put out Shoe to check weight !',
                        style: GoogleFonts.inter(
                            fontSize: 15,
                            color: const Color.fromARGB(255, 166, 166, 166),
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                    GestureDetector(
                      onLongPress: () {
                        bleScanConnect.disconnect(devices[0], devices[1]);
                      },
                      onTap: () {
                        setState(() {
                          checkweight = !checkweight;
                        });

                        Future.delayed(const Duration(seconds: 5), () async {
                          int result = await bleScanConnect
                              .measureweight(); // Await the measureweight() call
                          setState(() {
                            weight = result;
                            checkweight = !checkweight;
                          });
                        });
                      },
                      child: Lottie.network(
                          checkweight
                              ? 'https://lottie.host/78fad47f-f4c7-40e7-acbf-a374a2eacbf4/jYbjJxkHtf.json'
                              : 'https://lottie.host/701f5345-b0aa-4a17-9e94-e2079ddab55a/fP79S00rsL.json',
                          height: 300,
                          width: double.infinity),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Text(
                        (weight / 1000).toString() == "25.0"
                            ? "0"
                            : (weight / 1000).toString(),
                        style: GoogleFonts.spaceMono(
                            fontSize: 40.0, color: Colors.grey),
                      ),
                    ),
                    Align(
                        alignment: Alignment.bottomRight,
                        child: FloatingActionButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MyHomePage()),
                            );
                          },
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(100)),
                          ),
                          backgroundColor: Colors.grey,
                          child: const Icon(Icons.arrow_forward),
                        ))
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
