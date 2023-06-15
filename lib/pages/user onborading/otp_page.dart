import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mit_bus_app/pages/home/home.dart';
import 'package:mit_bus_app/pages/landing_page.dart';
import 'package:mit_bus_app/pages/user%20onborading/faculty_registeration.dart';
import 'package:mit_bus_app/pages/user%20onborading/student_registeration.dart';
import 'package:pinput/pinput.dart';

class OTPScreen extends StatefulWidget {
  final phoneNumber;
  final isStudent;
  final bool isLogin;
  OTPScreen(
      {super.key,
      required this.phoneNumber,
      this.isStudent,
      required this.isLogin});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  late Timer _timer;
  int _seconds = 30;
  bool _buttonEnabled = false;
  TextEditingController _otpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _seconds--;
        if (_seconds == 0) {
          _timer.cancel();
          _buttonEnabled = true;
        }
      });
    });
  }

  void resetTimer() {
    setState(() {
      _seconds = 30;
      _buttonEnabled = false;
      startTimer();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _phoneNoController = TextEditingController();
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: h,
          width: w,
          child: Stack(
            children: [
              Positioned(
                top: -300,
                left: -150,
                child: Transform.rotate(
                  angle: 70 * (3.14 / 180), // Convert degrees to radians
                  child: Container(
                    width: h / 2 + 100,
                    height: w * 2,
                    color: purple,
                    // Your container content here
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Image.asset("lib/assets/mit_logo2.png"),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "\nVerification",
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: purple,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Pinput(
                        controller: _otpController,
                        defaultPinTheme: PinTheme(
                            height: 60,
                            width: 45,
                            decoration: BoxDecoration(
                              color: const Color(0xffc3c3c3).withOpacity(0.5),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            textStyle: const TextStyle(fontSize: 20)),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: RichText(
                          text: TextSpan(
                            text: widget.phoneNumber,
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  color: purple,
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal),
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: ' not your phone number? ',
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    color: purple,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              TextSpan(
                                text: 'Change',
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      color: purple,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 1),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          (_otpController.text.isNotEmpty &&
                                  _otpController.text.length == 4)
                              ? (widget.isLogin == false)
                                  ? widget.isStudent
                                      ? Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            transitionDuration: const Duration(
                                                milliseconds: 500),
                                            pageBuilder: (context, animation,
                                                secondaryAnimation) {
                                              return StudentRegisteration();
                                            },
                                            transitionsBuilder: (context,
                                                animation,
                                                secondaryAnimation,
                                                child) {
                                              var begin =
                                                  const Offset(1.0, 0.0);
                                              var end = Offset.zero;
                                              var curve = Curves.ease;

                                              var tween = Tween(
                                                      begin: begin, end: end)
                                                  .chain(
                                                      CurveTween(curve: curve));

                                              return SlideTransition(
                                                position:
                                                    animation.drive(tween),
                                                child: child,
                                              );
                                            },
                                          ),
                                        )
                                      : Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            transitionDuration: const Duration(
                                                milliseconds: 500),
                                            pageBuilder: (context, animation,
                                                secondaryAnimation) {
                                              return const FacultyRegisteration();
                                            },
                                            transitionsBuilder: (context,
                                                animation,
                                                secondaryAnimation,
                                                child) {
                                              var begin =
                                                  const Offset(1.0, 0.0);
                                              var end = Offset.zero;
                                              var curve = Curves.ease;

                                              var tween = Tween(
                                                      begin: begin, end: end)
                                                  .chain(
                                                      CurveTween(curve: curve));

                                              return SlideTransition(
                                                position:
                                                    animation.drive(tween),
                                                child: child,
                                              );
                                            },
                                          ),
                                        )
                                  : Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        transitionDuration:
                                            const Duration(milliseconds: 500),
                                        pageBuilder: (context, animation,
                                            secondaryAnimation) {
                                          return const StudentRegisteration();
                                        },
                                        transitionsBuilder: (context, animation,
                                            secondaryAnimation, child) {
                                          var begin = const Offset(1.0, 0.0);
                                          var end = Offset.zero;
                                          var curve = Curves.ease;

                                          var tween = Tween(
                                                  begin: begin, end: end)
                                              .chain(CurveTween(curve: curve));

                                          return SlideTransition(
                                            position: animation.drive(tween),
                                            child: child,
                                          );
                                        },
                                      ),
                                    )
                              : ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Please enter correct OTP...',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    backgroundColor: Color(0xffFF7F7F),
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
                              "Verify",
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
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          _buttonEnabled
                              ? {
                                  resetTimer(),
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Resending...'),
                                    ),
                                  ),
                                }
                              : null;
                        },
                        child: Container(
                          width: w,
                          height: 50,
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: _buttonEnabled
                                ? Colors.white
                                : Colors.grey.withOpacity(0.3),
                            border: Border.all(color: purple),
                          ),
                          child: Center(
                            child: Text(
                              _buttonEnabled
                                  ? "Resend"
                                  : "Resend in ${_seconds}s",
                              style: GoogleFonts.inter(
                                textStyle: TextStyle(
                                  color: _buttonEnabled
                                      ? purple
                                      : Colors.black.withOpacity(0.5),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 45),
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
