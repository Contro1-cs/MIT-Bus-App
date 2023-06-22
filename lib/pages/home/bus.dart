import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mit_bus_app/pages/landing_page.dart';
import 'package:qr_flutter/qr_flutter.dart';

class BusPage extends StatefulWidget {
  const BusPage({super.key});

  @override
  State<BusPage> createState() => _BusPageState();
}

class _BusPageState extends State<BusPage> {
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser!;
    final uid = user.uid;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: QrImage(
            data: uid,
            version: QrVersions.auto,
            size: 250,
            gapless: false,
            embeddedImage:
                const AssetImage('assets/images/my_embedded_image.png'),
            embeddedImageStyle: QrEmbeddedImageStyle(
              size: const Size(30, 30),
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
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
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
    );
  }
}
