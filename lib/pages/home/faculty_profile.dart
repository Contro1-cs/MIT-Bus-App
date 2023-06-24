import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mit_bus_app/lists/lists.dart';
import 'package:mit_bus_app/pages/landing_page.dart';
import 'package:mit_bus_app/widgets/custom_snackbars.dart';
import 'package:mit_bus_app/widgets/custom_texts.dart';

class FacultyProfile extends StatefulWidget {
  final Map data;

  const FacultyProfile({super.key, required this.data});

  @override
  State<FacultyProfile> createState() => _FacultyProfileState();
}

class _FacultyProfileState extends State<FacultyProfile> {
  final TextEditingController _facultyName = TextEditingController();
  final TextEditingController _college = TextEditingController();
  final TextEditingController _pickupArea = TextEditingController();
  final TextEditingController _pickupPoint = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser!;
    final uid = user.uid;
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    Future<void> updateFacultyUser() {
      return users
          .doc(uid)
          .update({
            'facultyName': _facultyName.text,
            'college': _college.text,
            'pickupArea': _pickupArea.text,
            'pickupPoint': _pickupPoint.text,
          })
          .then(
              (value) => successSnackbar(context, 'Data uploaded successfully'))
          .catchError(
              (error) => errorSnackbar(context, 'Failed to upload data.'));
    }

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 150,
        title: Text(
          "Faculty Profile",
          style: GoogleFonts.inter(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 40,
          ),
        ),
        backgroundColor: const Color(0xff202020),
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: users.doc(uid).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong"));
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Center(
                  child: Text('Someting went wrong'),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    auth.signOut();
                    Navigator.popUntil(context, (route) => false);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LandingPage(),
                      ),
                    );
                  },
                  child: Container(
                    width: w,
                    height: 50,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: const Color(0xffFF5959),
                    ),
                    child: Center(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.logout,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            "Logout",
                            style: GoogleFonts.inter(
                              textStyle: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            _facultyName.text = data['facultyName'];
            _college.text = data['college'];
            _pickupArea.text = data['pickupArea'];
            _pickupPoint.text = data['pickupPoint'];
            return SizedBox(
              child: Scrollbar(
                thickness: 10,
                thumbVisibility: true,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 30),
                      ProfileFormField(
                        controller: _facultyName,
                        title: 'Faculty\'s Name',
                      ),
                      const SizedBox(height: 30),
                      ProfileFormField(
                        controller: _college,
                        title: 'College',
                      ),
                      const SizedBox(height: 30),
                      ProfileFormField(
                        controller: _pickupPoint,
                        title: 'Pickup Point',
                      ),
                      const SizedBox(height: 30),
                      ProfileFormField(
                        controller: _pickupArea,
                        title: 'Pickup Area',
                      ),
                      const SizedBox(height: 30),
                      GestureDetector(
                        onTap: () {
                          if (_facultyName.text != data['facultyName'] ||
                              _college != data['college'] ||
                              _pickupArea.text != data['pickupArea'] ||
                              _pickupPoint.text != data['pickupPoint']) {
                            updateFacultyUser();
                          } else {
                            errorSnackbar(context,
                                'Please change the data you want to update');
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
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.upload,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  "Update",
                                  style: GoogleFonts.inter(
                                    textStyle: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          auth.signOut();
                          Navigator.popUntil(context, (route) => false);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LandingPage(),
                            ),
                          );
                        },
                        child: Container(
                          width: w,
                          height: 50,
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: const Color(0xffFF5959),
                          ),
                          child: Center(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.logout,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  "Logout",
                                  style: GoogleFonts.inter(
                                    textStyle: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 45),
                    ],
                  ),
                ),
              ),
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
