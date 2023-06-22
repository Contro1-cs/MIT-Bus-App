import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mit_bus_app/pages/landing_page.dart';
import 'dart:math' as math;

class StudentHome extends StatefulWidget {
  final Map data;
  const StudentHome({super.key, required this.data});

  @override
  State<StudentHome> createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {
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
                '${widget.data['userType']} Profile',
                style: GoogleFonts.inter(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 30),
              ),
            ),
            Text(
              'MIT ADT University',
              style: GoogleFonts.inter(
                color: Colors.black,
                fontWeight: FontWeight.normal,
                fontSize: 12,
              ),
            ),
          ],
        ),
        const Divider(
          height: 10,
          thickness: 2,
          color: Colors.black,
          indent: 100,
          endIndent: 100,
        ),
        Column(
          children: [
            Text(
              widget.data['studentName']
                  .split(" ")
                  .map((word) => word[0].toUpperCase() + word.substring(1))
                  .join(" "),
              style: GoogleFonts.inter(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
            Text(
              widget.data['college'],
              style: GoogleFonts.inter(
                color: Colors.black,
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
                color: purple,
              ),
              child: Column(
                children: [
                  Text(
                    widget.data['pickupPoint']
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
                    widget.data['pickupArea'],
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
              padding: const EdgeInsets.all(5),
              child: Transform.rotate(
                angle: 90 * math.pi / 180,
                child: const Icon(
                  Icons.swap_horiz,
                  size: 30,
                  color: Colors.black,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 30),
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: purple,
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
      ],
    );
  }
}
