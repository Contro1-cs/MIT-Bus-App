import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mit_bus_app/lists/lists.dart';
import 'package:mit_bus_app/pages/home/home.dart';
import 'package:mit_bus_app/pages/landing_page.dart';
import 'package:mit_bus_app/widgets/custom_snackbars.dart';
import 'package:mit_bus_app/widgets/drop_down.dart';
import 'package:mit_bus_app/widgets/custom_texts.dart';

class ParentsInfo extends StatefulWidget {
  String studentName;
  String college;
  String year;
  String pickupArea;
  String pickupPoint;
  String userType;
  ParentsInfo({
    super.key,
    required this.studentName,
    required this.college,
    required this.year,
    required this.pickupArea,
    required this.pickupPoint,
    required this.userType,
  });

  @override
  State<ParentsInfo> createState() => _ParentsInfoState();
}

TextEditingController _parentsName = TextEditingController(text: '');
TextEditingController _parentsPhone = TextEditingController(text: '');
TextEditingController _pendingFees = TextEditingController(text: '0');
bool _isFeesPaid = false;

class _ParentsInfoState extends State<ParentsInfo> {
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser!;
    final uid = user.uid;
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    Future<void> addParentsData() {
      return users.doc(uid).set({
        'userName': widget.studentName
            .split(" ")
            .map((word) => word[0].toUpperCase() + word.substring(1))
            .join(" "),
        'userType': widget.userType
            .split(" ")
            .map((word) => word[0].toUpperCase() + word.substring(1))
            .join(" "),
        'college': widget.college
            .split(" ")
            .map((word) => word[0].toUpperCase() + word.substring(1))
            .join(" "),
        'year': widget.year
            .split(" ")
            .map((word) => word[0].toUpperCase() + word.substring(1))
            .join(" "),
        'pickupArea': widget.pickupArea
            .split(" ")
            .map((word) => word[0].toUpperCase() + word.substring(1))
            .join(" "),
        'pickupPoint': widget.pickupPoint
            .split(" ")
            .map((word) => word[0].toUpperCase() + word.substring(1))
            .join(" "),
        'parentName': _parentsName.text
            .trim()
            .split(" ")
            .map((word) => word[0].toUpperCase() + word.substring(1))
            .join(" "),
        'parentPhone': _parentsPhone.text.trim(),
        'pendingFees': int.parse(_pendingFees.text),
      }).then(
        (value) {
          successSnackbar(context, "User Added");
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

    var w = MediaQuery.of(context).size.width;
    // var h = MediaQuery.of(context).size.height;
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 150,
          // elevation: 0,
          backgroundColor: purple,
          title: Text(
            "Parents info",
            style: GoogleFonts.poppins(
              textStyle: const TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              CustomFormField(
                title: 'Gaurdian\'s name',
                hint: 'Ajit Kulkarni',
                controller: _parentsName,
                keyboardType: TextInputType.name,
              ),
              const SizedBox(height: 20),
              CustomFormField(
                title: "Guardian's Phone number",
                hint: '94225641846',
                controller: _parentsPhone,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 20),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 35),
                    child: Text(
                      'Fee Status: ',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          color: purple,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35),
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Checkbox(
                                fillColor: MaterialStateProperty.all(purple),
                                shape: const CircleBorder(),
                                value: _isFeesPaid,
                                onChanged: (value) {
                                  setState(() {
                                    _isFeesPaid = true;
                                  });
                                },
                              ),
                              Text(
                                'Paid',
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    color: purple,
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Checkbox(
                                shape: const CircleBorder(),
                                value: !_isFeesPaid,
                                fillColor: MaterialStateProperty.all(purple),
                                onChanged: (value) {
                                  setState(() {
                                    _isFeesPaid = false;
                                  });
                                },
                              ),
                              Text(
                                'Pending',
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    color: purple,
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Visibility(
                visible: !_isFeesPaid,
                child: CustomFormField(
                  title: 'Total fees pending',
                  hint: 'pending amount',
                  controller: _pendingFees,
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  if (_parentsName.text.trim().isNotEmpty &&
                      _parentsPhone.text.trim().isNotEmpty) {
                    addParentsData();
                  } else {
                    errorSnackbar(context, 'Please fill all necessary fields');
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
                      "Complete",
                      style: GoogleFonts.inter(
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
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
