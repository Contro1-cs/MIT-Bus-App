import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:mit_bus_app/lists/lists.dart';
import 'package:mit_bus_app/pages/home/attendance.dart';
import 'package:mit_bus_app/pages/home/fees.dart';
import 'package:mit_bus_app/pages/home/faculty_home.dart';
import 'package:mit_bus_app/pages/home/profile.dart';
import 'package:mit_bus_app/pages/home/student_home.dart';
import 'package:mit_bus_app/pages/landing_page.dart';
import 'package:mit_bus_app/widgets/custom_snackbars.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  List<String> fileList = [];

  bool isLoading = false;
  bool zeroFees = true;

  Future<void> fetchFileList() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser!;
    final uid = user.uid;
    setState(() {
      isLoading = true;
    });

    try {
      final storageRef = FirebaseStorage.instance.ref().child(uid);
      final listResult = await storageRef.listAll();

      final files = listResult.items.map((fileRef) => fileRef.name).toList();

      if (listResult.items.isEmpty) {
        setState(() {
          zeroFees = true;
        });
      } else {
        setState(() {
          zeroFees = false;
        });
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      errorSnackbar(context, 'Error fetching file list: $e');

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    fetchFileList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    FirebaseAuth auth = FirebaseAuth.instance;
    final pages = [
      const HomeBody(),
      Attendance(),
      const Fees(),
      const ProfilePage(),
    ];
    return WillPopScope(
      child: zeroFees
          ? Scaffold(
              body: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(height: 50),
                      Text(
                        'Please make at least one payment to gain access of the app.',
                        style: GoogleFonts.inter(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 50),
                      Column(
                        children: [
                          Container(
                            height: 50,
                            width: w,
                            // padding: EdgeInsets.symmetric(horizontal: 25),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: purple),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Fees(),
                                  ),
                                );
                              },
                              child: const Text('Upload a receipt'),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            height: 50,
                            width: w,
                            margin: const EdgeInsets.only(bottom: 30),
                            // padding: EdgeInsets.symmetric(horizontal: 25),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xffFF5959)),
                              onPressed: () {
                                auth.signOut();

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LandingPage(),
                                  ),
                                );
                              },
                              child: const Text('Logout'),
                            ),
                          ),
                        ],
                      )
                    ],
                  )),
            )
          : Scaffold(
              backgroundColor: Colors.white,
              bottomNavigationBar: Container(
                color: const Color(0xff202020),
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: GNav(
                  onTabChange: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  padding: const EdgeInsets.all(15),
                  tabMargin: const EdgeInsets.all(10),
                  backgroundColor: const Color(0xff202020),
                  color: Colors.white,
                  activeColor: Colors.white,
                  tabBackgroundColor: Colors.white.withOpacity(0.3),
                  gap: 8,
                  tabs: const [
                    GButton(
                      icon: Icons.home,
                      text: 'Home',
                    ),
                    GButton(
                      icon: Icons.qr_code,
                      text: 'Scan',
                    ),
                    GButton(
                      icon: Icons.currency_rupee,
                      text: 'Fees',
                    ),
                    GButton(
                      icon: Icons.person,
                      text: 'Profile',
                    ),
                  ],
                ),
              ),
              body: pages[_currentIndex]),
      onWillPop: () async {
        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text(
                'Want to exit the app?',
                textAlign: TextAlign.center,
              ),
              actionsAlignment: MainAxisAlignment.spaceEvenly,
              actions: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context, false);
                  },
                  child: Container(
                    height: 50,
                    width: 100,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: purple)),
                    alignment: Alignment.center,
                    child: Text(
                      "No",
                      style: GoogleFonts.inter(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context, true);
                  },
                  child: Container(
                    height: 50,
                    width: 100,
                    decoration: BoxDecoration(
                      color: purple,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "Yes",
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
        return shouldPop!;
      },
    );
  }
}

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User _user = _auth.currentUser!;
    final uid = _user.uid;
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 80,
          title: Text(
            "Home",
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
              return const Center(
                child: Text('Someting went wrong'),
              );
            }

            if (snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic> data =
                  snapshot.data!.data() as Map<String, dynamic>;
              if (data['userType'] == userType[0]) {
                return StudentHome(data: data);
              } else if (data['userType'] == userType[1]) {
                return FacultyHome(data: data);
              }
            }

            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
      onWillPop: () async {
        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) {
            // return AlertDialog();
            return AlertDialog(
              title: const Text(
                'Want to exit the app?',
                textAlign: TextAlign.center,
              ),
              actionsAlignment: MainAxisAlignment.spaceEvenly,
              actions: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context, false);
                  },
                  child: Container(
                    height: 50,
                    width: 100,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: purple)),
                    alignment: Alignment.center,
                    child: Text(
                      "No",
                      style: GoogleFonts.inter(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context, true);
                  },
                  child: Container(
                    height: 50,
                    width: 100,
                    decoration: BoxDecoration(
                      color: purple,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "Yes",
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
        return shouldPop!;
      },
    );
  }
}
