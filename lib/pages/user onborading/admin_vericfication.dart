import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mit_bus_app/admin/admin_view.dart';
import 'package:mit_bus_app/pages/home/home.dart';
import 'package:mit_bus_app/pages/landing_page.dart';
import 'package:mit_bus_app/widgets/custom_snackbars.dart';
import 'package:mit_bus_app/widgets/custom_texts.dart';

class AdminVerification extends StatefulWidget {
  const AdminVerification({super.key});

  @override
  State<AdminVerification> createState() => _AdminVerificationState();
}

TextEditingController _code = TextEditingController();

class _AdminVerificationState extends State<AdminVerification> {
  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;

    return Scaffold(
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomFormField(
          title: 'Secret Verification Code',
          hint: 'admin code',
          keyboardType: TextInputType.number,
          controller: _code,
        ),
        const SizedBox(height: 50),
        Container(
          height: 50,
          width: w,
          margin: const EdgeInsets.symmetric(horizontal: 25),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: purple),
            onPressed: () {
              if (_code.text.trim() == '2233') {
                Navigator.popUntil(context, (route) => false);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AdminView(),
                  ),
                );
              } else {
                errorSnackbar(context, 'Wrong code');
              }
            },
            child: Center(
              child: Text(
                "Enter",
                style: GoogleFonts.inter(
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    ));
  }
}
