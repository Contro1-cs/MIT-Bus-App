import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mit_bus_app/lists/lists.dart';
import 'package:mit_bus_app/pages/home/bus.dart';
import 'package:mit_bus_app/pages/home/profile.dart';
import 'package:mit_bus_app/pages/landing_page.dart';
import 'dart:math' as math;

class HomePage extends StatefulWidget {
  final studentName;
  final parentsName;
  final pendingFees;
  final pickupPoint;
  final pickupArea;
  final parentsPhone;
  final college;

  const HomePage({
    super.key,
    required this.studentName,
    required this.parentsName,
    required this.pendingFees,
    required this.pickupPoint,
    required this.pickupArea,
    required this.parentsPhone,
    required this.college,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeBody(
        studentName: widget.studentName,
        parentsName: widget.parentsName,
        pendingFees: widget.pendingFees,
        pickupPoint: widget.pickupPoint,
        pickupArea: widget.pickupArea,
        parentsPhone: widget.parentsPhone,
        college: widget.college,
      ),
      const BusPage(),
      const ProfilePage(),
    ];
    return Scaffold(
        backgroundColor: purple,
        appBar: AppBar(
          title: Text(
            "Home",
            style: GoogleFonts.inter(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.white.withOpacity(0.3),
          elevation: 0,
          automaticallyImplyLeading: false,
        ),
        bottomNavigationBar: SizedBox(
          height: 75,
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            backgroundColor: Colors.white.withOpacity(0.3),
            elevation: 0,
            selectedItemColor: Colors.white,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.house),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.directions_bus),
                label: 'Bus',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        ),
        body: pages[_currentIndex]);
  }
}

class HomeBody extends StatefulWidget {
  const HomeBody(
      {super.key,
      required this.studentName,
      required this.parentsName,
      required this.pendingFees,
      required this.pickupPoint,
      required this.pickupArea,
      required this.parentsPhone,
      required this.college});
  final studentName;
  final parentsName;
  final pendingFees;
  final pickupPoint;
  final pickupArea;
  final parentsPhone;
  final college;

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  String memberID = 'ABC123';
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset("lib/assets/bus.svg"),
        Column(
          children: [
            Center(
              child: Text(
                'Student Profile',
                style: GoogleFonts.inter(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 30),
              ),
            ),
            Text(
              'MIT ADT University',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontWeight: FontWeight.normal,
                fontSize: 12,
              ),
            ),
          ],
        ),
        const Divider(
          height: 10,
          thickness: 2,
          color: Colors.white,
          indent: 100,
          endIndent: 100,
        ),
        Column(
          children: [
            Text(
              widget.studentName
                  .split(" ")
                  .map((word) => word[0].toUpperCase() + word.substring(1))
                  .join(" "),
              style: GoogleFonts.inter(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
            Text(
              widget.college,
              style: GoogleFonts.inter(
                color: Colors.white,
                fontWeight: FontWeight.normal,
                fontSize: 14,
              ),
            ),
          ],
        ),
        Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 30),
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white.withOpacity(.16),
              ),
              child: Column(
                children: [
                  Text(
                    "${widget.pickupPoint},"
                        .split(" ")
                        .map(
                            (word) => word[0].toUpperCase() + word.substring(1))
                        .join(" "),
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    widget.pickupArea,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(5),
              child: Transform.rotate(
                angle: 90 * math.pi / 180,
                child: const Icon(
                  Icons.swap_horiz,
                  size: 30,
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 30),
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white.withOpacity(.16),
              ),
              child: Column(
                children: [
                  Text(
                    "MIT ADT University,"
                        .split(" ")
                        .map(
                            (word) => word[0].toUpperCase() + word.substring(1))
                        .join(" "),
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    "Loni Kalbhor",
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        TextButton(
          onPressed: () {
            Clipboard.setData(ClipboardData(text: memberID));
            var snackBar = const SnackBar(
              content: Text('Text copied to clipboard'),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 40),
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white.withOpacity(.16),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.copy_all,
                  color: Colors.white,
                  size: 20,
                ),
                Text(
                  " Member ID: ",
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                    fontSize: 16,
                  ),
                ),
                Text(
                  memberID,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
