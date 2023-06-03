// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mit_bus_app/pages/user%20onborading/onboarding_page.dart';

Color purple = Color(0xff512F7E);

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    var _carouselpage = 0;
    CarouselController _carousalController = CarouselController();

    List landingPageSvg = [
      {
        "svg": SvgPicture.asset(
          "lib/assets/default.svg",
          height: h / 2,
          width: w,
        ),
        "title": Text(
          "Find your College Bus",
          style: GoogleFonts.inter(
            textStyle: TextStyle(
              color: Colors.black,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          textAlign: TextAlign.center,
        ),
        "subtitle": Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            "Find your college bus details on your phone with registering in few simple steps",
            style: GoogleFonts.inter(
              textStyle: TextStyle(
                color: Colors.black,
                fontSize: 12,
              ),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      },
      {
        "svg": SvgPicture.asset(
          "lib/assets/default.svg",
          height: h / 2,
          width: w,
        ),
        "title": Text(
          "Find your College Bus",
          style: GoogleFonts.inter(
            textStyle: TextStyle(
              color: Colors.black,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          textAlign: TextAlign.center,
        ),
        "subtitle": Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            "Find your college bus details on your phone with registering in few simple steps",
            style: GoogleFonts.inter(
              textStyle: TextStyle(
                color: Colors.black,
                fontSize: 12,
              ),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      },
      {
        "svg": SvgPicture.asset(
          "lib/assets/default.svg",
          height: h / 2,
          width: w,
        ),
        "title": Text(
          "Find your College Bus",
          style: GoogleFonts.inter(
            textStyle: TextStyle(
              color: Colors.black,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          textAlign: TextAlign.center,
        ),
        "subtitle": Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            "Find your college bus details on your phone with registering in few simple steps",
            style: GoogleFonts.inter(
              textStyle: TextStyle(
                color: Colors.black,
                fontSize: 12,
              ),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      },
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            //Add banner Carousel
            CarouselSlider.builder(
              carouselController: _carousalController,
              options: CarouselOptions(
                  // height: h / 2,
                  aspectRatio: 9 / 16,
                  autoPlay: true,
                  enableInfiniteScroll: false,
                  autoPlayAnimationDuration: const Duration(seconds: 1),
                  viewportFraction: 1,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _carouselpage = index;
                    });
                  }),
              itemCount: landingPageSvg.length,
              itemBuilder: (context, index, realIndex) {
                return Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 50),
                      child: landingPageSvg[index]["svg"],
                    ),
                    landingPageSvg[index]["title"],
                    const SizedBox(height: 20),
                    landingPageSvg[index]["subtitle"],
                  ],
                );
              },
            ),

            Expanded(
              child: Container(
                color: Colors.white,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    transitionDuration: Duration(
                        milliseconds: 500), // Adjust the duration as desired
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return OnboardingPage(); // Replace 'SecondPage' with the actual name of your second page widget
                    },
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      var begin = Offset(1.0, 0.0);
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
              child: Container(
                width: w,
                height: 50,
                margin: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Color(0xff512F7E),
                ),
                child: Center(
                  child: Text(
                    "Get started",
                    style: GoogleFonts.inter(
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
