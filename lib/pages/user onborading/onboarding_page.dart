import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mit_bus_app/pages/landing_page.dart';
import 'package:mit_bus_app/pages/user%20onborading/login_page.dart';
import 'package:mit_bus_app/pages/user%20onborading/onboarding_choice.dart';
import 'package:mit_bus_app/pages/user%20onborading/register_page.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

bool shrinkContainer = false;

class _OnboardingPageState extends State<OnboardingPage> {
  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SizedBox(
        height: h,
        width: w,
        child: Stack(
          children: [
            Positioned(
                top: -200,
                left: -150,
                child: Transform.rotate(
                  angle: 60 * (3.14 / 180), // Convert degrees to radians
                  child: Container(
                    width: h / 2 + 100,
                    height: w * 2,
                    color: purple,
                    // Your container content here
                  ),
                )),
            Positioned(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                Container(
                  width: w,
                  alignment: Alignment.center,
                  child: Image.asset("lib/assets/mit_logo1.png"),
                ),
                const SizedBox(height: 20),
                Container(
                  width: w,
                  alignment: Alignment.center,
                  child: Image.asset("lib/assets/mit_logo2.png"),
                ),
                // const SizedBox(height: 50),
                Text(
                  "Welcome to MIT ADT University/'s\n Transportation App",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    textStyle: TextStyle(
                      color: purple,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            transitionDuration:
                                const Duration(milliseconds: 500),
                            pageBuilder:
                                (context, animation, secondaryAnimation) {
                              return const LoginPage();
                            },
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              var begin = const Offset(1.0, 0.0);
                              var end = Offset.zero;
                              var curve = Curves.ease;

                              var tween = Tween(begin: begin, end: end)
                                  .chain(CurveTween(curve: curve));

                              return SlideTransition(
                                position: animation.drive(tween),
                                child: child,
                              );
                            },
                          ),
                        );
                      },
                      child: Container(
                        width: w,
                        height: 50,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: purple,
                        ),
                        child: Center(
                          child: Text(
                            "Login",
                            style: GoogleFonts.inter(
                              textStyle: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            transitionDuration:
                                const Duration(milliseconds: 500),
                            pageBuilder:
                                (context, animation, secondaryAnimation) {
                              return const OnboardingChoice();
                            },
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              var begin = const Offset(1.0, 0.0);
                              var end = Offset.zero;
                              var curve = Curves.ease;

                              var tween = Tween(begin: begin, end: end)
                                  .chain(CurveTween(curve: curve));

                              return SlideTransition(
                                position: animation.drive(tween),
                                child: child,
                              );
                            },
                          ),
                        );
                      },
                      child: Container(
                        width: w,
                        height: 50,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.white,
                          border: Border.all(
                            color: const Color(0xffB59135),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "Register",
                            style: GoogleFonts.inter(
                              textStyle: const TextStyle(
                                color: Color(0xffB59135),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ))
          ],
        ),
      ),
    );
  }
}
