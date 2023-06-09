import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mit_bus_app/pages/landing_page.dart';

class CustomFormField extends StatefulWidget {
  final String title;
  final String hint;
  final TextEditingController controller;
  final TextInputType keyboardType;
  const CustomFormField({
    super.key,
    required this.title,
    required this.hint,
    required this.keyboardType,
    required this.controller,
  });

  @override
  State<CustomFormField> createState() => _CustomFormFieldState();
}

class _CustomFormFieldState extends State<CustomFormField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 35),
      alignment: Alignment.centerLeft,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.title,
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  color: purple,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              )),
          TextField(
            controller: widget.controller,
            keyboardType: widget.keyboardType,
            maxLength: widget.keyboardType == TextInputType.phone ? 10 : null,
            decoration: InputDecoration(
              counterText: '',
              hintText: widget.hint,
              hintStyle: const TextStyle(
                color: Colors.grey,
              ),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
