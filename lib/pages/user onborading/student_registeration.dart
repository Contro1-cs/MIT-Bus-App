import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mit_bus_app/lists/lists.dart';
import 'package:mit_bus_app/pages/landing_page.dart';
import 'package:mit_bus_app/pages/user%20onborading/parents_info.dart';
import 'package:mit_bus_app/widgets/custom_snackbars.dart';
import 'package:mit_bus_app/widgets/drop_down.dart';
import 'package:mit_bus_app/widgets/form_field.dart';

class StudentRegisteration extends StatefulWidget {
  String userType;
  StudentRegisteration({
    super.key,
    required this.userType,
  });

  @override
  State<StudentRegisteration> createState() => _StudentRegisterationState();
}

bool _termsNcondition = false;
TextEditingController name = TextEditingController();

class _StudentRegisterationState extends State<StudentRegisteration> {
  var _college = college[0];
  var _year = year[0];
  var _pickUpPoint = pickUpPoint[0];
  var _area = areas[0];

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser!;
    final uid = user.uid;
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    Future<void> addUser() {
      return users.doc(uid).set({
        'name': name.text.trim(),
        'userType': widget.userType,
        'college': _college,
        'year': _year,
        'pickUpPoint': _pickUpPoint,
        'area': _area,
      }).then(
        (value) {
          successSnackbar(context, "User Added");
          name.text = '';
          _termsNcondition = false;
          Navigator.push(
            context,
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 500),
              pageBuilder: (context, animation, secondaryAnimation) {
                return ParentsInfo(
                  studentname: name.text,
                  pickupPoint: _pickUpPoint,
                  PickupArea: _area,
                  college: _college,
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
        },
      ).catchError(
          (error) => errorSnackbar(context, "Failed to add user: $error####"));
    }

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    final userID = FirebaseAuth.instance.currentUser?.uid;
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
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
                    addUser();
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
    );
  }
}
