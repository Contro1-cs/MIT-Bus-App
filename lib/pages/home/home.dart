import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:mit_bus_app/lists/lists.dart';
import 'package:mit_bus_app/pages/home/bus.dart';
import 'package:mit_bus_app/pages/home/faculty_home.dart';
import 'package:mit_bus_app/pages/home/profile.dart';
import 'package:mit_bus_app/pages/home/student_home.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    final pages = [
      const HomeBody(),
      const BusPage(),
      const ProfilePage(),
    ];
    return Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: GNav(
          onTabChange: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          gap: 8,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          backgroundColor: const Color(0xff202020),
          color: Colors.white,
          activeColor: Colors.white,
          tabMargin: const EdgeInsets.all(5),
          tabBackgroundColor: Colors.white.withOpacity(0.3),
          tabs: const [
            GButton(
              icon: Icons.home,
              text: 'Home',
            ),
            GButton(
              icon: Icons.airport_shuttle,
              text: 'Bus',
            ),
            GButton(
              icon: Icons.person,
              text: 'Profile',
            ),
          ],
        ),
        body: pages[_currentIndex]);
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Home",
          style: GoogleFonts.inter(
            color: Colors.white,
            fontWeight: FontWeight.bold,
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
            } else if (data['userType'] == 'Faculty') {
              return FacultyHome(data: data);
            }
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
