import 'package:avatar_glow/avatar_glow.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/ble_stream.dart';

class FootScreen extends StatefulWidget {
  const FootScreen({super.key});

  @override
  State<FootScreen> createState() => _FootScreenState();
}

class _FootScreenState extends State<FootScreen> {
  final ScrollController _firstController = ScrollController();
  FirebaseApp secondaryApp = Firebase.app('SmartStep');
  late DatabaseReference databaseReference;
  List<String> footFeedback = [
    "Your weight distribution is uneven, try to put more pressure on the balls of your feet.",
    "You're putting excessive pressure on your heels, try to distribute your weight evenly across your foot.",
    "Your posture seems to favor one side of your foot, try to center your weight for better balance.",
    "You might be leaning too much forward, adjust your posture to distribute pressure evenly on your foot.",
    "Your weight distribution is good, keep maintaining the balance to prevent strain on your foot.",
    "Your foot pressure distribution indicates a slight pronation, consider using orthotic insoles for support.",
    "Your toes are carrying too much pressure, try to relax them and distribute the weight across your foot.",
    "Your arches seem to collapse under pressure, consider exercises to strengthen them for better support.",
    "Your weight is mostly on the outer edges of your foot, try to engage your inner foot muscles for balance.",
    "Your foot pressure is well-distributed, but be mindful of maintaining this balance especially during movement.",
  ];

  static const String databaseUrl =
      'https://smartstep-6a479-default-rtdb.firebaseio.com/';
  Future<double> getWeight() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getDouble('weight') ?? 0;
  }

  Stream<double> getLefHeeltWeightStream() {
    return BleStream.leftHeelController.stream.map(double.parse);
  }

  Stream<double> getLefToetWeightStream() {
    return BleStream.leftToeController.stream.map(double.parse);
  }

  Stream<double> getRightHeeltWeightStream() {
    return BleStream.rightHeelController.stream.map(double.parse);
  }

  Stream<double> getRightToetWeightStream() {
    return BleStream.rightToeController.stream.map(double.parse);
  }

  String feedback = 'Your feedback is generating!';

  @override
  void initState() {
    databaseReference = FirebaseDatabase.instanceFor(
            app: secondaryApp, databaseURL: databaseUrl)
        .ref('feedback');
    databaseReference.child('data').onValue.listen((event) {
      final data = event.snapshot.value;
      print(data);
      if (data != null) {
        setState(() {
          feedback = data.toString();
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool animate = true;
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
            Padding(
              padding: const EdgeInsets.only(top: 120, left: 45),
              child: Image.asset(
                'assets/image.png',
                height: 350,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 50, left: 20),
                  child: Text(
                    'Foot Map',
                    style: GoogleFonts.spaceMono(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 120, top: 130),
                      child: StreamBuilder<double>(
                          stream: getLefToetWeightStream(),
                          builder: (context, snapshot) {
                            // print("left toe ${snapshot.data}");
                            return AvatarGlow(
                              startDelay: const Duration(milliseconds: 0),
                              glowColor: Colors.white,
                              glowShape: BoxShape.circle,
                              animate: animate,
                              glowCount: snapshot.hasData
                                  ? (snapshot.data! > 1000 &&
                                          snapshot.data! < 5000)
                                      ? 2
                                      : (snapshot.data! > 5000 &&
                                              snapshot.data! < 15000)
                                          ? 3
                                          : (snapshot.data! > 15000)
                                              ? 5
                                              : 0
                                  : 0,
                              curve: Curves.easeOutQuad,
                              child: const Material(
                                elevation: 8.0,
                                shape: CircleBorder(),
                                color: Colors.transparent,
                                child: CircleAvatar(
                                  radius: 15.0,
                                ),
                              ),
                            );
                          }),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 70, top: 130),
                      child: StreamBuilder<double>(
                          stream: getRightToetWeightStream(),
                          builder: (context, snapshot) {
                            print("right toe ${snapshot.data}");
                            return AvatarGlow(
                              startDelay: const Duration(milliseconds: 0),
                              glowColor: Colors.white,
                              glowShape: BoxShape.circle,
                              animate: animate,
                              glowCount: snapshot.hasData
                                  ? (snapshot.data! > 1000 &&
                                          snapshot.data! < 5000)
                                      ? 2
                                      : (snapshot.data! > 5000 &&
                                              snapshot.data! < 15000)
                                          ? 3
                                          : (snapshot.data! > 15000)
                                              ? 5
                                              : 0
                                  : 0,
                              curve: Curves.easeOutQuad,
                              child: const Material(
                                elevation: 8.0,
                                shape: CircleBorder(),
                                color: Colors.transparent,
                                child: CircleAvatar(
                                  radius: 15.0,
                                ),
                              ),
                            );
                          }),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 165),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 110),
                        child: StreamBuilder<double>(
                            stream: getLefHeeltWeightStream(),
                            builder: (context, snapshot) {
                              return AvatarGlow(
                                startDelay: const Duration(milliseconds: 0),
                                glowColor: Colors.white,
                                glowShape: BoxShape.circle,
                                animate: animate,
                                glowCount: snapshot.hasData
                                    ? (snapshot.data! > 1000 &&
                                            snapshot.data! < 5000)
                                        ? 2
                                        : (snapshot.data! > 5000 &&
                                                snapshot.data! < 15000)
                                            ? 3
                                            : (snapshot.data! > 15000)
                                                ? 5
                                                : 0
                                    : 0,
                                curve: Curves.easeOutQuad,
                                child: const Material(
                                  elevation: 8.0,
                                  shape: CircleBorder(),
                                  color: Colors.transparent,
                                  child: CircleAvatar(
                                    radius: 18.0,
                                  ),
                                ),
                              );
                            }),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 80),
                        child: StreamBuilder<double>(
                            stream: getRightHeeltWeightStream(),
                            builder: (context, snapshot) {
                              return AvatarGlow(
                                startDelay: const Duration(milliseconds: 0),
                                glowColor: Colors.white,
                                glowShape: BoxShape.circle,
                                animate: animate,
                                glowCount: snapshot.hasData
                                    ? (snapshot.data! > 1000 &&
                                            snapshot.data! < 5000)
                                        ? 2
                                        : (snapshot.data! > 5000 &&
                                                snapshot.data! < 15000)
                                            ? 3
                                            : (snapshot.data! > 15000)
                                                ? 5
                                                : 0
                                    : 0,
                                curve: Curves.easeOutQuad,
                                child: const Material(
                                  elevation: 8.0,
                                  shape: CircleBorder(),
                                  color: Colors.transparent,
                                  child: CircleAvatar(
                                    radius: 18.0,
                                  ),
                                ),
                              );
                            }),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30, left: 20),
                  child: Text(
                    'Feedback',
                    style: GoogleFonts.spaceMono(
                      color: Colors.grey,
                      fontSize: 15,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15, left: 30, right: 30),
                  child: Text(
                    feedback,
                    style: GoogleFonts.spaceMono(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
