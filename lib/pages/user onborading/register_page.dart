import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mit_bus_app/pages/landing_page.dart';
import 'package:mit_bus_app/pages/user%20onborading/login_page.dart';
import 'package:mit_bus_app/pages/user%20onborading/otp_page.dart';
import 'package:mit_bus_app/widgets/form_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

bool _isStudent = true;

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController _phoneNoController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
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
                top: -360,
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
                  Column(
                    children: [
                      const SizedBox(height: 50),
                      Image.asset("lib/assets/mit_logo2.png"),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Column(
                    children: [
                      Text(
                        "Register",
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: purple,
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      CustomFormField(
                          title: 'Phone number',
                          hint: '7888149564',
                          controller: _phoneNoController),
                      const SizedBox(height: 15),
                      CustomFormField(
                          title: 'Name',
                          hint: 'Rahul Kulkarni',
                          controller: _phoneNoController),
                      const SizedBox(height: 15),
                      CustomFormField(
                          title: 'Email address',
                          hint: 'rahul@gmail.com',
                          controller: _phoneNoController),
                      const SizedBox(height: 15),
                    ],
                  ),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          (_phoneNoController.text.isNotEmpty &&
                                  _phoneNoController.text.length == 10 &&
                                  _nameController.text.trim().isNotEmpty &&
                                  _emailController.text.trim().isNotEmpty)
                              ? Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    transitionDuration:
                                        const Duration(milliseconds: 500),
                                    pageBuilder: (context, animation,
                                        secondaryAnimation) {
                                      return OTPScreen(
                                        phoneNumber: _phoneNoController.text,
                                        isStudent: _isStudent,
                                        isLogin: false,
                                      );
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
                                )
                              : ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Please enter all the details correctly",
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
                              "Verify OTP",
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
                            builder: (context) => const LoginPage(),
                          ),
                        ),
                        child: Text(
                          "Already a member? Login",
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              color: purple,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
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
