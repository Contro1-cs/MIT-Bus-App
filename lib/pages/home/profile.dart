import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mit_bus_app/pages/landing_page.dart';
import 'package:mit_bus_app/pages/user%20onborading/login_page.dart';
import 'package:mit_bus_app/pages/user%20onborading/onboarding_choice.dart';
import 'package:mit_bus_app/widgets/custom_snackbars.dart';
import 'package:mit_bus_app/widgets/custom_texts.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

bool updateData = false;

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController _studentNameController = TextEditingController();
  TextEditingController _parentNameController = TextEditingController();
  TextEditingController _parentPhoneController = TextEditingController();
  TextEditingController _pendingFeesController = TextEditingController();
  TextEditingController _pickupAreaController = TextEditingController();
  TextEditingController _pickupPointController = TextEditingController();
  TextEditingController _yearController = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser!;
    final uid = user.uid;
    CollectionReference users = FirebaseFirestore.instance.collection('users');

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

    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 150,
        title: Text(
          "Profile",
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
      floatingActionButton: Visibility(
        visible: updateData,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: FloatingActionButton(
            onPressed: () {},
            backgroundColor: const Color(0xff59B9FF),
            child: const Icon(
              Icons.upload_file,
            ),
          ),
        ),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: users.doc(uid).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong"));
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LoginPage(),
              ),
            );
            errorSnackbar(
                context, 'Something went wrong. Please log in and try again');
            return const Center(child: Text("Document does not exist"));
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
                child: SingleChildScrollView(
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
