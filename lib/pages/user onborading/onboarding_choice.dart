import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mit_bus_app/lists/lists.dart';
import 'package:mit_bus_app/pages/landing_page.dart';
import 'package:mit_bus_app/pages/user%20onborading/register_page.dart';
import 'package:mit_bus_app/pages/user%20onborading/student_registeration.dart';

class OnboardingChoice extends StatefulWidget {
  const OnboardingChoice({super.key});

  @override
  State<OnboardingChoice> createState() => OnboardingChoiceState();
}

TextEditingController _authEmailController = TextEditingController();
TextEditingController _authPasswordController = TextEditingController();
String _userTypeValue = "Student";
bool _hidePassword = false;

class OnboardingChoiceState extends State<OnboardingChoice> {
  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 150,
        backgroundColor: purple,
        title: Text(
          "Register as...",
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(
              color: Colors.white,
              fontSize: 34,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 35),
                alignment: Alignment.centerLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Email'),
                    TextField(
                      controller: _authEmailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: 'Rahul@gmail.com',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 35),
                alignment: Alignment.centerLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Password'),
                    TextField(
                      controller: _authPasswordController,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: _hidePassword,
                      decoration: InputDecoration(
                        suffixIcon: _hidePassword
                            ? IconButton(
                                onPressed: () {
                                  setState(() {
                                    _hidePassword = !_hidePassword;
                                  });
                                },
                                icon: Icon(
                                  Icons.visibility_rounded,
                                  color: Colors.black.withOpacity(.8),
                                ),
                              )
                            : IconButton(
                                onPressed: () {
                                  setState(() {
                                    _hidePassword = !_hidePassword;
                                  });
                                },
                                icon: const Icon(
                                  Icons.visibility_off_rounded,
                                  color: Colors.grey,
                                ),
                              ),
                        hintText: 'Minimum 6 characters',
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
              ),
              const SizedBox(height: 25),
              Container(
                  margin: const EdgeInsets.symmetric(horizontal: 35),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: 1,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Login as a'),
                      DropdownButton<String>(
                        underline: const SizedBox(),
                        value: _userTypeValue,
                        isExpanded: true,
                        hint: const Text('Select a college'),
                        onChanged: (newValue) {
                          setState(() {
                            _userTypeValue = newValue!;
                          });
                        },
                        items: userType.map<DropdownMenuItem<String>>((value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ))
            ],
          ),
          Column(
            children: [
              GestureDetector(
                onTap: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const StudentRegisteration(),
                    ),
                  );
                },
                child: Container(
                  width: w,
                  height: 50,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: purple,
                  ),
                  child: Center(
                    child: Text(
                      "Verify OTP",
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
              TextButton(
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RegisterPage())),
                child: Text(
                  "New here? Register",
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      color: purple,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ],
      ),
    );
  }
}
