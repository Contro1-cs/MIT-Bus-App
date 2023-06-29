// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mit_bus_app/pages/home/home.dart';
import 'package:mit_bus_app/pages/landing_page.dart';
import 'package:mit_bus_app/pages/user%20onborading/admin_vericfication.dart';
import 'package:mit_bus_app/pages/user%20onborading/onboarding_choice.dart';
import 'package:mit_bus_app/widgets/custom_snackbars.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

bool _hidePassword = false;

TextEditingController _authEmail = TextEditingController();
TextEditingController _authPassword = TextEditingController();

class _LoginPageState extends State<LoginPage> {
  @override
  void dispose() {
    _authEmail.text = '';
    _authPassword.text = '';
    _hidePassword = true;
    super.dispose();
  }

  @override
  void initState() {
    _authEmail.text = '';
    _authPassword.text = '';
    _hidePassword = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;

    passwordSignIn() async {
      try {
        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: _authEmail.text, password: _authPassword.text);
        successSnackbar(context, 'Login successful');
        Navigator.popUntil(context, (route) => false);
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 500),
            pageBuilder: (context, animation, secondaryAnimation) {
              return const HomePage();
            },
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              var begin = const Offset(1.0, 0.0);
              var end = Offset.zero;
              var curve = Curves.ease;

              var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
          ),
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          errorSnackbar(context, 'No user found for that email');
        } else if (e.code == 'wrong-password') {
          errorSnackbar(context, 'Wrong password provided for that user');
        }
      }
    }

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
                  const SizedBox(height: 50),
                  Image.asset("lib/assets/mit_logo2.png"),
                  Column(
                    children: [
                      Text(
                        "Login",
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: purple,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        "Enter your Phone number",
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: purple,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 35),
                        alignment: Alignment.centerLeft,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Email'),
                            TextField(
                              controller: _authEmail,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                hintText: 'Rahul@gmail.com',
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 25),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 35),
                        alignment: Alignment.centerLeft,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Password'),
                            TextField(
                              controller: _authPassword,
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: _hidePassword,
                              decoration: InputDecoration(
                                suffixIcon: _hidePassword
                                    ? IconButton(
                                        onPressed: () {
                                          setState(() {
                                            _hidePassword = !_hidePassword;
                                          });
                                        },
                                        icon: const Icon(
                                          Icons.visibility_rounded,
                                          color: Colors.black,
                                        ),
                                      )
                                    : IconButton(
                                        onPressed: () {
                                          setState(() {
                                            _hidePassword = !_hidePassword;
                                          });
                                        },
                                        icon: const Icon(
                                          Icons.visibility_off_rounded,
                                          color: Colors.black,
                                        ),
                                      ),
                                hintText: 'Minimum 6 characters',
                                hintStyle: const TextStyle(
                                  color: Colors.grey,
                                ),
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          if (_authEmail.text.trim().isEmpty ||
                              _authPassword.text.trim().isEmpty) {
                            errorSnackbar(
                                context, 'Please enter a email and password');
                          } else if (_authEmail.text.trim() == 'admin' &&
                              _authPassword.text.trim() == 'admin7890') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AdminVerification(),
                              ),
                            );
                          } else {
                            passwordSignIn();
                          }
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
                      TextButton(
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RegisterPage())),
                        child: Text(
                          "New here? Register",
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              color: purple,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
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
