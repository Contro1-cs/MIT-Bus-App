import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mit_bus_app/lists/lists.dart';
import 'package:mit_bus_app/pages/landing_page.dart';
import 'package:mit_bus_app/pages/user%20onborading/parents_info.dart';
import 'package:mit_bus_app/widgets/custom_snackbars.dart';
import 'package:mit_bus_app/widgets/drop_down.dart';
import 'package:mit_bus_app/widgets/custom_texts.dart';

class StudentRegistration extends StatefulWidget {
  String userType;
  StudentRegistration({
    super.key,
    required this.userType,
  });

  @override
  State<StudentRegistration> createState() => _StudentRegistrationState();
}

bool _termsNcondition = false;
TextEditingController name = TextEditingController();

class _StudentRegistrationState extends State<StudentRegistration> {
  var _college = college[0];
  var _year = year[0];
  var _pickUpPoint = pickUpPoint[0];
  var _area = areas[0];

  @override
  Widget build(BuildContext context) {


    // var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 150,
          // elevation: 0,
          backgroundColor: purple,
          title: Text(
            "Student's Profile",
            style: GoogleFonts.poppins(
              textStyle: const TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 1),
                Column(
                  children: [
                    const SizedBox(height: 10),
                    Container(
                      width: w,
                      alignment: Alignment.centerLeft,
                      child: CustomFormField(
                        controller: name,
                        title: "Name",
                        keyboardType: TextInputType.name,
                        hint: "Rahul Kulkarni",
                      ),
                    ),
                    const SizedBox(height: 20),
                    //College
                    Container(
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
                    const SizedBox(height: 20),

                    //Year
                    Container(
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
                    const SizedBox(height: 20),

                    //Area
                    Container(
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
                    const SizedBox(height: 20),

                    //Pickup Area
                    Column(
                      children: [
                        Container(
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
                        const SizedBox(height: 20),
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
                  ],
                ),
                GestureDetector(
                  onTap: () async {
                    if (name.text.trim().isNotEmpty && _termsNcondition) {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          transitionDuration: const Duration(milliseconds: 500),
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                            return ParentsInfo(
                              studentName: name.text.trim(),
                              userType: widget.userType,
                              college: _college,
                              year: _year,
                              pickupPoint: _pickUpPoint,
                              pickupArea: _area,
                            );
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
                    } else if (name.text.trim().isEmpty) {
                      errorSnackbar(context, 'Please enter your name');
                    } else if (!_termsNcondition) {
                      errorSnackbar(
                          context, 'Please accept the terms condition.');
                    }
                  },
                  child: Container(
                    width: w,
                    height: 50,
                    margin: const EdgeInsets.fromLTRB(25, 0, 25, 40),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: purple,
                    ),
                    child: Center(
                      child: Text(
                        "Proceed",
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
        ),
      ),
      onWillPop: () async {
        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) {
            // return AlertDialog();
            return AlertDialog(
              title: const Text(
                'Please don\'t exit the app before completing the application',
                textAlign: TextAlign.center,
              ),
              actionsAlignment: MainAxisAlignment.spaceEvenly,
              actions: [
                SizedBox(
                  height: 50,
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: purple, // Background color
                    ),
                    child: Text(
                      "Okay",
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              ],
            );
          },
        );
        return shouldPop!;
      },
    );
  }
}
