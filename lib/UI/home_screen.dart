import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:smartstep/models/ble_scan_connect.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
        child: CustomMaterialIndicator(
          onRefresh: () => Future(()async {
            BleScanConnect bleScanConnect = BleScanConnect();
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
              Stack(
                children: [
                  Positioned(
                    left: 100,
                    top: -40,
                    child: Opacity(
                      opacity: 0.5,
                      child: Image.asset(
                        'assets/shoebgnewtest.png',
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 50, left: 20),
                        child: Text(
                          'Hi, Alfred ',
                          style: GoogleFonts.spaceMono(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30, left: 20),
                        child: Text(
                          'Posture Score',
                          style: GoogleFonts.spaceMono(
                            color: Colors.grey,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 40),
                        child: GradientText(
                          '60',
                          style: GoogleFonts.spaceMono(
                            fontSize: 200.0,
                          ),
                          colors: const [
                            Colors.grey,
                            Color.fromARGB(221, 37, 37, 37),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 140, left: 20),
                        child: Text(
                          'Weight Distribution',
                          style: GoogleFonts.spaceMono(
                            color: Colors.grey,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          BleScanConnect().printOutput(devices[0],devices[1]);
                          print(devices[0].remoteId);
                             print(devices[1].remoteId);
                        },
                        child: Container(
                          height: 70,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 40),
                          decoration: BoxDecoration(
                            color: Colors.white60,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: IntrinsicHeight(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 20),
                                      child: Text(
                                        'Left',
                                        style: GoogleFonts.spaceMono(
                                            fontSize: 18,
                                            color: Colors.grey[700]),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 40,
                                    ),
                                    Text(
                                      '${BleScanConnect().leftperc}%',
                                      style:
                                          GoogleFonts.spaceMono(fontSize: 18),
                                    ),
                                  ],
                                ),
                                const VerticalDivider(
                                  color: Color(0xFF1e1c1d),
                                  thickness: 2,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      '${BleScanConnect().rightperc}%',
                                      style:
                                          GoogleFonts.spaceMono(fontSize: 18),
                                    ),
                                    const SizedBox(
                                      width: 40,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 20),
                                      child: Text(
                                        'Right',
                                        style: GoogleFonts.spaceMono(
                                            fontSize: 18,
                                            color: Colors.grey[700]),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
