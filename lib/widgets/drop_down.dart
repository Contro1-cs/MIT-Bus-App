import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mit_bus_app/pages/landing_page.dart';

class CustomDropdownMenu extends StatelessWidget {
  late String value;
  late final List list;
  final void Function(String?) onChanged;
  final String title;

  CustomDropdownMenu({
    super.key,
    required this.value,
    required this.list,
    required this.onChanged,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
              color: purple,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 5),
        SizedBox(
          width: w,
          height: 50,
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            hint: const Text('Select a college'),
            onChanged: onChanged,
            items: list.map<DropdownMenuItem<String>>((value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
