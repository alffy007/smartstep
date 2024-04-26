import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:rxdart/rxdart.dart';
import 'package:smartstep/models/ble_scan_connect.dart';

import '../models/ble_stream.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, superKey});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseApp secondaryApp = Firebase.app('SmartStep');
  late DatabaseReference databaseReference;
  int leftperc = 0;
  int rightperc = 0;
  static const String databaseUrl =
      'https://smartstep-6a479-default-rtdb.firebaseio.com/';

  @override
  void initState() {
    databaseReference = FirebaseDatabase.instanceFor(
            app: secondaryApp, databaseURL: databaseUrl)
        .ref('smartstep');
    super.initState();
  }

  Future<double> getWeight() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getDouble('weight') ?? 0;
  }

  Stream<double> getLeftWeightStream() {
    return CombineLatestStream.list<double>([
      BleStream.leftHeelController.stream.map(double.parse),
      BleStream.leftToeController.stream.map(double.parse)
    ]).map((values) => (values[0] + values[1]) / 1000);
  }

  Stream<double> getRightWeightStream() {
    return CombineLatestStream.list<double>([
      BleStream.rightHeelController.stream.map(double.parse),
      BleStream.rightToeController.stream.map(double.parse)
    ]).map((values) => (values[0] + values[1]) / 1000);
  }

  // @override
  // void dispose() {
  //   BleStream.leftHeelController.close();
  //   BleStream.leftToeController.close();
  //   BleStream.rightHeelController.close();
  //   BleStream.rightToeController.close();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<double>(
        future: getWeight(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          double weight = snapshot.data!;
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
              child: Stack(
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
                        onLongPress: () {
                          BleScanConnect().disconnect(BleScanConnect().device1,
                              BleScanConnect().device2);
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
                                    StreamBuilder(
                                      stream: getLeftWeightStream(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const CircularProgressIndicator();
                                        }

                                        double leftWeight = snapshot.data!;
                                        leftperc = ((leftWeight / weight) * 100)
                                            .toInt();
                                        print(leftWeight);
                                        return Text('$leftperc%');
                                      },
                                    ),
                                  ],
                                ),
                                const VerticalDivider(
                                  color: Color(0xFF1e1c1d),
                                  thickness: 2,
                                ),
                                Row(
                                  children: [
                                    StreamBuilder(
                                      stream: getRightWeightStream(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const CircularProgressIndicator();
                                        }

                                        double rightWeight = snapshot.data!;
                                        rightperc =
                                            ((rightWeight / weight) * 100)
                                                .toInt();
                                        print(rightWeight);
                                        return Text('$rightperc%');
                                      },
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
            ),
          );
        });
  }
}
