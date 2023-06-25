import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mit_bus_app/pages/home/upload_fees.dart';
import 'package:mit_bus_app/pages/landing_page.dart';
import 'package:qr_flutter/qr_flutter.dart';

class AttendanceAndFees extends StatefulWidget {
  const AttendanceAndFees({super.key});

  @override
  State<AttendanceAndFees> createState() => _AttendanceAndFeesState();
}

class _AttendanceAndFeesState extends State<AttendanceAndFees> {
  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;

    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser!;
    final uid = user.uid;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(height: 50),
          Column(
            children: [
              Center(
                child: QrImageView(
                  data: uid,
                  version: QrVersions.auto,
                  size: 250,
                  gapless: false,
                  embeddedImage:
                      const AssetImage('assets/images/my_embedded_image.png'),
                  embeddedImageStyle: const QrEmbeddedImageStyle(
                    size: Size(30, 30),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: uid));
                  var snackBar = const SnackBar(
                    content: Text('Text copied to clipboard'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.black,
                    border: Border.all(
                      color: Colors.black,
                    ),
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
                        uid.substring(0, 10),
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
          ),
          Column(
            children: [
              Container(
                width: w,
                margin: const EdgeInsets.symmetric(horizontal: 25),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const UploadFeesDoc(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: purple),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.upload_file_outlined,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          "Upload new fees reciept",
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
              const SizedBox(height: 15),
              Container(
                width: w,
                margin: const EdgeInsets.symmetric(horizontal: 25),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff3F9056),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.currency_rupee_outlined,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          "Payment History",
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
              const SizedBox(height: 30),
            ],
          ),
        ],
      ),
    );
  }
}
