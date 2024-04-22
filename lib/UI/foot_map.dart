import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class FootScreen extends StatefulWidget {
  const FootScreen({super.key});

  @override
  State<FootScreen> createState() => _FootScreenState();
}

class _FootScreenState extends State<FootScreen> {
  final ScrollController _firstController = ScrollController();
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

  @override
  Widget build(BuildContext context) {
    bool _animate = true;
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
                      padding: const EdgeInsets.only(left: 125, top: 45),
                      child: AvatarGlow(
                        startDelay: const Duration(milliseconds: 0),
                        glowColor: Colors.white,
                        glowShape: BoxShape.circle,
                        animate: _animate,
                        glowCount: 1,
                        curve: Curves.easeOutQuad,
                        child: const Material(
                          elevation: 8.0,
                          shape: CircleBorder(),
                          color: Colors.transparent,
                          child: CircleAvatar(
                            radius: 12.0,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 73, top: 45),
                      child: AvatarGlow(
                        startDelay: const Duration(milliseconds: 0),
                        glowColor: Colors.white,
                        glowShape: BoxShape.circle,
                        animate: _animate,
                        glowCount: 1,
                        curve: Curves.easeOutQuad,
                        child: const Material(
                          elevation: 8.0,
                          shape: CircleBorder(),
                          color: Colors.transparent,
                          child: CircleAvatar(
                            radius: 12.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 135, top: 60),
                      child: AvatarGlow(
                        startDelay: const Duration(milliseconds: 0),
                        glowColor: Colors.white,
                        glowShape: BoxShape.circle,
                        animate: _animate,
                        glowCount: 1,
                        curve: Curves.easeOutQuad,
                        child: const Material(
                          elevation: 8.0,
                          shape: CircleBorder(),
                          color: Colors.transparent,
                          child: CircleAvatar(
                            radius: 12.0,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 55, top: 60),
                      child: AvatarGlow(
                        startDelay: const Duration(milliseconds: 0),
                        glowColor: Colors.white,
                        glowShape: BoxShape.circle,
                        animate: _animate,
                        glowCount: 1,
                        curve: Curves.easeOutQuad,
                        child: const Material(
                          elevation: 8.0,
                          shape: CircleBorder(),
                          color: Colors.transparent,
                          child: CircleAvatar(
                            radius: 12.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 165),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 110),
                        child: AvatarGlow(
                          startDelay: const Duration(milliseconds: 0),
                          glowColor: Colors.white,
                          glowShape: BoxShape.circle,
                          animate: _animate,
                          glowCount: 1,
                          curve: Curves.easeOutQuad,
                          child: const Material(
                            elevation: 8.0,
                            shape: CircleBorder(),
                            color: Colors.transparent,
                            child: CircleAvatar(
                              radius: 18.0,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 80),
                        child: AvatarGlow(
                          startDelay: const Duration(milliseconds: 0),
                          glowColor: Colors.white,
                          glowShape: BoxShape.circle,
                          animate: _animate,
                          glowCount: 1,
                          curve: Curves.easeOutQuad,
                          child: const Material(
                            elevation: 8.0,
                            shape: CircleBorder(),
                            color: Colors.transparent,
                            child: CircleAvatar(
                              radius: 18.0,
                            ),
                          ),
                        ),
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
                  child: Container(
                    height:
                        200, // Allow the container to take up all available vertical space
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Scrollbar(
                      controller: _firstController,
                      child: ListView.builder(
                        controller: _firstController,
                        padding: EdgeInsets.zero, // Remove any default padding
                        itemCount: footFeedback.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 12),
                            child: Column(
                              children: [
                                Text(
                                  '${index + 1}. ${footFeedback[index]}',
                                  style: GoogleFonts.spaceMono(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
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
