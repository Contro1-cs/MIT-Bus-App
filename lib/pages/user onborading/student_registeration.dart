import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mit_bus_app/lists/lists.dart';
import 'package:mit_bus_app/pages/home/home.dart';
import 'package:mit_bus_app/pages/landing_page.dart';
import 'package:mit_bus_app/widgets/drop_down.dart';

class OTPScreen extends StatefulWidget {
  final bool isStudent = false;
  const OTPScreen({super.key});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

bool _termsNcondition = false;

class _OTPScreenState extends State<OTPScreen> {
  var _college = college[0];
  var _year = year[0];
  var _pickUpPoint = pickUpPoint[0];
  var _area = areas[0];
  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 150,
              width: w,
              color: purple,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
              child: Text(
                "Student Profile",
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            //College
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 35),
              width: w,
              alignment: Alignment.centerLeft,
              child: CustomDropdownMenu(
                value: _college,
                list: college,
                title: 'Select a College',
                onChanged: (newValue) {
                  setState(() {
                    _college = newValue!;
                  });
                },
              ),
            ),

            //Year
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 35),
              width: w,
              alignment: Alignment.centerLeft,
              child: CustomDropdownMenu(
                value: _year,
                list: year,
                title: 'Year',
                onChanged: (newValue) {
                  setState(() {
                    _year = newValue!;
                  });
                },
              ),
            ),

            //Area
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 35),
              width: w,
              alignment: Alignment.centerLeft,
              child: CustomDropdownMenu(
                value: _area,
                list: areas,
                title: 'Area',
                onChanged: (newValue) {
                  setState(() {
                    _area = newValue!;
                  });
                },
              ),
            ),

            //Pickup Area
            Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 35),
                  width: w,
                  alignment: Alignment.centerLeft,
                  child: CustomDropdownMenu(
                    value: _pickUpPoint,
                    title: 'Pickup point',
                    list: pickUpPoint,
                    onChanged: (newValue) {
                      setState(() {
                        _pickUpPoint = newValue!;
                      });
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Checkbox(
                      activeColor: purple,
                      value: _termsNcondition,
                      onChanged: (value) {
                        setState(() {
                          _termsNcondition = !_termsNcondition;
                        });
                      },
                    ),
                    Text(
                      'I agree to the ',
                      style: GoogleFonts.inter(
                        color: purple,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Terms and Conditions"),
                          ),
                        );
                      },
                      child: Text(
                        'Terms & Conditions',
                        style: GoogleFonts.inter(
                          color: purple,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
            GestureDetector(
              onTap: () {
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
                margin: const EdgeInsets.fromLTRB(25, 0, 25, 25),
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
          ],
        ),
      ),
    );
  }
}
