import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mit_bus_app/pages/user%20onborading/onboarding_page.dart';

Color purple = const Color(0xff512F7E);

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int _carouselpage = 0;
  CarouselController _carouselController = CarouselController();

  List<Map<String, dynamic>> landingPageCarousal = [
    {
      "svg": SvgPicture.asset(
        "lib/assets/default.svg",
        height: 200,
        width: 200,
      ),
      "title": Text(
        "Find your College Buss",
        style: GoogleFonts.inter(
          textStyle: const TextStyle(
            color: Colors.black,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        textAlign: TextAlign.center,
      ),
      "subtitle": Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Text(
          "Find your college bus details on your phone by registering in a few simple steps",
          style: GoogleFonts.inter(
            textStyle: const TextStyle(
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
        height: 200,
        width: 200,
      ),
      "title": Text(
        "Find your College Bus",
        style: GoogleFonts.inter(
          textStyle: const TextStyle(
            color: Colors.black,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        textAlign: TextAlign.center,
      ),
      "subtitle": Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Text(
          "Find your college bus details on your phone by registering in a few simple steps",
          style: GoogleFonts.inter(
            textStyle: const TextStyle(
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
        height: 200,
        width: 200,
      ),
      "title": Text(
        "Find your College Bus",
        style: GoogleFonts.inter(
          textStyle: const TextStyle(
            color: Colors.black,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        textAlign: TextAlign.center,
      ),
      "subtitle": Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Text(
          "Find your college bus details on your phone by registering in a few simple steps",
          style: GoogleFonts.inter(
            textStyle: const TextStyle(
              color: Colors.black,
              fontSize: 12,
            ),
          ),
          textAlign: TextAlign.center,
        ),
      ),
    },
  ];

  @override
  Widget build(BuildContext context) {
    // var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return WillPopScope(
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
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 50),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                CarouselSlider.builder(
                  carouselController: _carouselController,
                  options: CarouselOptions(
                    aspectRatio: 1.0,
                    autoPlay: true,
                    enableInfiniteScroll: false,
                    autoPlayAnimationDuration: const Duration(seconds: 1),
                    viewportFraction: 1.0,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _carouselpage = index;
                      });
                    },
                  ),
                  itemCount: landingPageCarousal.length,
                  itemBuilder: (context, index, realIndex) {
                    return Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 50),
                          child: landingPageCarousal[index]["svg"],
                        ),
                        const SizedBox(height: 20),
                        landingPageCarousal[index]["title"],
                        const SizedBox(height: 20),
                        landingPageCarousal[index]["subtitle"],
                      ],
                    );
                  },
                ),
                // const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(landingPageCarousal.length, (index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _carouselpage == index ? purple : Colors.grey,
                      ),
                    );
                  }),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    transitionDuration: const Duration(
                        milliseconds: 500), // Adjust the duration as desired
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return const OnboardingPage(); // Replace 'SecondPage' with the actual name of your second page widget
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
              child: Container(
                width: w,
                height: 50,
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: const Color(0xff512F7E),
                ),
                child: Center(
                  child: Text(
                    "Get started",
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
    );
  }
}
