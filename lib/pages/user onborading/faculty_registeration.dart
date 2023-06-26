import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mit_bus_app/lists/lists.dart';
import 'package:mit_bus_app/pages/home/home.dart';
import 'package:mit_bus_app/pages/landing_page.dart';
import 'package:mit_bus_app/widgets/custom_snackbars.dart';
import 'package:mit_bus_app/widgets/custom_texts.dart';
import 'package:mit_bus_app/widgets/drop_down.dart';

class FacultyRegistration extends StatefulWidget {
  final bool isStudent = false;
  const FacultyRegistration({super.key});

  @override
  State<FacultyRegistration> createState() => _FacultyRegistrationState();
}

bool _termsNcondition = false;
TextEditingController _facultyname = TextEditingController();
TextEditingController _pendingFees = TextEditingController();

class _FacultyRegistrationState extends State<FacultyRegistration> {
  var _college = college[0];
  var _year = year[0];
  var _pickUpPoint = pickUpPoint[0];
  var _area = areas[0];
  @override
  Widget build(BuildContext context) {
    // var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser!;
    final uid = user.uid;
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    Future<void> addFacultyData() {
      return users.doc(uid).set({
        'userName': _facultyname.text
            .trim()
            .split(" ")
            .map((word) => word[0].toUpperCase() + word.substring(1))
            .join(" "),
        'college': _college
            .split(" ")
            .map((word) => word[0].toUpperCase() + word.substring(1))
            .join(" "),
        'pickupArea': _area
            .split(" ")
            .map((word) => word[0].toUpperCase() + word.substring(1))
            .join(" "),
        'pickupPoint': _pickUpPoint
            .split(" ")
            .map((word) => word[0].toUpperCase() + word.substring(1))
            .join(" "),
        'userType': userType[1],
        'pendingFees': int.parse(_pendingFees.text),
      }).then(
        (value) {
          successSnackbar(context, "User Added");
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
      ).catchError(
          (error) => errorSnackbar(context, "Failed to add user: $error####"));
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        toolbarHeight: 150,
        // elevation: 0,
        backgroundColor: purple,
        title: Text(
          "Faculty's Profile",
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
                  const SizedBox(height: 30),
                  CustomFormField(
                    title: 'Name',
                    hint: 'Ajay Kulkarni',
                    keyboardType: TextInputType.name,
                    controller: _facultyname,
                  ),
                  const SizedBox(height: 20),
                  CustomFormField(
                    title: 'Pending Fees',
                    hint: '0',
                    keyboardType: TextInputType.number,
                    controller: _pendingFees,
                  ),
                  const SizedBox(height: 20),
                  //College
                  CustomDropdownMenu(
                    value: _college,
                    list: college,
                    title: 'Select a College',
                    onChanged: (newValue) {
                      setState(() {
                        _college = newValue!;
                      });
                    },
                  ),

                  const SizedBox(height: 20),
                  //Area
                  CustomDropdownMenu(
                    value: _area,
                    list: areas,
                    title: 'Area',
                    onChanged: (newValue) {
                      setState(() {
                        _area = newValue!;
                      });
                    },
                  ),
                  const SizedBox(height: 20),

                  //Pickup Area
                  Column(
                    children: [
                      CustomDropdownMenu(
                        value: _pickUpPoint,
                        title: 'Pickup point',
                        list: pickUpPoint,
                        onChanged: (newValue) {
                          setState(() {
                            _pickUpPoint = newValue!;
                          });
                        },
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
                ],
              ),
              GestureDetector(
                onTap: () {
                  _termsNcondition
                      ? addFacultyData()
                      : ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Please agree to Terms and Conditions',
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Color(0xffFF7F7F),
                          ),
                        );
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
                      "Register",
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
    );
  }
}
