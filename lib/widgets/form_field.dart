import 'package:flutter/material.dart';

class CustomFormField extends StatefulWidget {
  final String title;
  final String hint;
  final TextEditingController controller;
  const CustomFormField(
      {super.key,
      required this.title,
      required this.hint,
      required this.controller});

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
          Text(widget.title),
          TextField(
            controller: widget.controller,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
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
