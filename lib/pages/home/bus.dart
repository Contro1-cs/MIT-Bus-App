import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
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
    return Center(
      child: QrImage(
        data: uid,
        version: QrVersions.auto,
        size: 250,
        gapless: false,
        embeddedImage: const AssetImage('assets/images/my_embedded_image.png'),
        embeddedImageStyle: QrEmbeddedImageStyle(
          size: const Size(30, 30),
        ),
      ),
    );
  }
}
