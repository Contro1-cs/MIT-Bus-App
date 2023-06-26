import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mit_bus_app/pages/landing_page.dart';
import 'package:mit_bus_app/widgets/custom_snackbars.dart';
import 'package:mit_bus_app/widgets/custom_texts.dart';

class StudentProfile extends StatefulWidget {
  final Map data;
  const StudentProfile({super.key, required this.data});

  @override
  State<StudentProfile> createState() => _StudentProfileState();
}

class _StudentProfileState extends State<StudentProfile> {
  final TextEditingController _studentNameController = TextEditingController();
  final TextEditingController _parentNameController = TextEditingController();
  final TextEditingController _parentPhoneController = TextEditingController();
  // final TextEditingController _pendingFeesController = TextEditingController();
  final TextEditingController _pickupAreaController = TextEditingController();
  final TextEditingController _pickupPointController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  bool _refreshing = false;

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser!;
    final uid = user.uid;
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    Future<void> refreshProfile() async {
      try {
        setState(() {
          // Reset the text controllers
          _studentNameController.text = '';
          _yearController.text = '';
          _parentNameController.text = '';
          _parentPhoneController.text = '';
          _pickupPointController.text = '';
          _pickupAreaController.text = '';
        });

        // Fetch the updated user data from Firestore
        DocumentSnapshot snapshot = await users.doc(uid).get();
        if (snapshot.exists) {
          Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
          setState(() {
            // Update the text controllers with the fetched data
            _studentNameController.text = data['studentName'];
            _yearController.text = data['year'];
            _parentNameController.text = data['parentName'];
            _parentPhoneController.text = data['parentPhone'];
            _pickupPointController.text = data['pickupPoint'];
            _pickupAreaController.text = data['pickupArea'];
          });
        }
      } catch (error) {
        // Handle any errors that occur during the refresh process
        errorSnackbar(context, 'Failed to refresh profile.');
      }
    }

    Future<void> updateUser() {
      return users
          .doc(uid)
          .update({
            'studentName': _studentNameController.text,
            'year': _yearController.text,
            'pickupArea': _pickupAreaController.text,
            'pickupPoint': _pickupPointController.text,
            'parentName': _parentNameController.text,
            'parentPhone': _parentPhoneController.text,
            'pendingFees': 0,
          })
          .then(
              (value) => successSnackbar(context, 'Data uploaded successfully'))
          .catchError(
              (error) => errorSnackbar(context, 'Failed to upload data.'));
    }

    // var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: Text(
          "Student Profile",
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
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => LoginPage(),
            //   ),
            // );
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
            _studentNameController.text = data['studentName'];
            _yearController.text = data['year'];
            _parentNameController.text = data['parentName'];
            _parentPhoneController.text = data['parentPhone'];
            _pickupPointController.text = data['pickupPoint'];
            _pickupAreaController.text = data['pickupArea'];
            return SizedBox(
              child: Scrollbar(
                thickness: 10,
                thumbVisibility: true,
                child: _refreshing
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(height: 30),
                            ProfileFormField(
                              controller: _studentNameController,
                              title: 'Student\'s Name',
                            ),
                            const SizedBox(height: 30),
                            ProfileFormField(
                              controller: _yearController,
                              title: 'Year',
                            ),
                            const SizedBox(height: 30),
                            ProfileFormField(
                              controller: _parentNameController,
                              title: 'Parent\'s Name',
                            ),
                            const SizedBox(height: 30),
                            ProfileFormField(
                              controller: _parentPhoneController,
                              title: 'Parent\'s Phone Number',
                            ),
                            const SizedBox(height: 30),
                            ProfileFormField(
                              controller: _pickupPointController,
                              title: 'Pickup Point',
                            ),
                            const SizedBox(height: 30),
                            ProfileFormField(
                              controller: _pickupAreaController,
                              title: 'Pickup Area',
                            ),
                            const SizedBox(height: 30),
                            GestureDetector(
                              onTap: () {
                                if (_studentNameController.text !=
                                        data['studentName'] ||
                                    _yearController.text != data['year'] ||
                                    _parentNameController.text !=
                                        data['parentName'] ||
                                    _parentPhoneController.text !=
                                        data['parentPhone'] ||
                                    _pickupPointController.text !=
                                        data['pickupPoint'] ||
                                    _pickupAreaController.text !=
                                        data['pickupArea']) {
                                  updateUser();
                                  setState(() {
                                    _refreshing = true;
                                  });
                                  refreshProfile();
                                  setState(() {
                                    _refreshing = false;
                                  });
                                } else {
                                  errorSnackbar(context,
                                      'Please change the data you want to update');
                                }
                              },
                              child: Container(
                                width: w,
                                height: 50,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: purple,
                                ),
                                child: Center(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: const Color(0xffFF5959),
                                ),
                                child: Center(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
