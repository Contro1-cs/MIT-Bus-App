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
    return Center(
      child: QrImage(
        data: 'wow',
        version: QrVersions.auto,
        size: 320,
        gapless: false,
        embeddedImage: const AssetImage('assets/images/my_embedded_image.png'),
        embeddedImageStyle: QrEmbeddedImageStyle(
          size: const Size(50, 50),
        ),
      ),
    );
  }
}