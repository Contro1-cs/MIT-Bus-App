import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mit_bus_app/lists/lists.dart';
import 'package:mit_bus_app/pages/home/home.dart';
import 'package:mit_bus_app/pages/landing_page.dart';
import 'package:mit_bus_app/widgets/custom_snackbars.dart';
import 'package:mit_bus_app/widgets/drop_down.dart';
import 'package:mit_bus_app/widgets/form_field.dart';

class ParentsInfo extends StatefulWidget {
  const ParentsInfo({
    super.key,
    required this.studentname,
    required this.pickupPoint,
    required this.PickupArea,
    required this.college,
  });
  final String studentname;
  final String pickupPoint;
  final String PickupArea;
  final String college;

  @override
  State<ParentsInfo> createState() => _ParentsInfoState();
}

TextEditingController _parentsName = TextEditingController();
TextEditingController _parentsPhone = TextEditingController();
TextEditingController _pendingFees = TextEditingController();
bool _isFeesPaid = false;
var _busAllocated = busList[0];

class _ParentsInfoState extends State<ParentsInfo> {
  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 150,
        // elevation: 0,
        backgroundColor: purple,
        title: Text(
          "Parents info",
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            CustomFormField(
              title: 'Gaurdian\'s name',
              hint: 'Ajit Kulkarni',
              controller: _parentsName,
              keyboardType: TextInputType.name,
            ),
            const SizedBox(height: 20),
            CustomFormField(
              title: 'Gaurdian\'s Phone number',
              hint: '94225641846',
              controller: _parentsPhone,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),
            CustomDropdownMenu(
              value: _busAllocated,
              list: busList,
              onChanged: (newValue) {
                setState(() {
                  _busAllocated = newValue!;
                });
              },
              title: 'Bus Allocated',
            ),
            const SizedBox(height: 20),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 35),
                  child: Text(
                    'Fee Status: ',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: purple,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 35),
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Checkbox(
                              fillColor: MaterialStateProperty.all(purple),
                              shape: const CircleBorder(),
                              value: _isFeesPaid,
                              onChanged: (value) {
                                setState(() {
                                  _isFeesPaid = true;
                                });
                              },
                            ),
                            Text(
                              'Paid',
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  color: purple,
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            Checkbox(
                              shape: const CircleBorder(),
                              value: !_isFeesPaid,
                              fillColor: MaterialStateProperty.all(purple),
                              onChanged: (value) {
                                setState(() {
                                  _isFeesPaid = false;
                                });
                              },
                            ),
                            Text(
                              'Not Paid',
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  color: purple,
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Visibility(
              visible: !_isFeesPaid,
              child: CustomFormField(
                title: 'Total fees pending',
                hint: 'pending amount',
                controller: _pendingFees,
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                if (_parentsName.text.trim().isNotEmpty &&
                    _parentsPhone.text.trim().isNotEmpty) {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      transitionDuration: const Duration(milliseconds: 500),
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return HomePage(
                          studentName: widget.studentname,
                          parentsName: _parentsName.text,
                          pendingFees: _isFeesPaid ? 0 : _pendingFees.text,
                          pickupArea: widget.PickupArea,
                          pickupPoint: widget.pickupPoint,
                          parentsPhone: _parentsPhone.text,
                          college: widget.college,
                        );
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
                } else {
                  errorSnackbar(context, 'Please fill all necessary fields');
                }
              },
              child: Container(
                width: w,
                height: 50,
                margin: const EdgeInsets.fromLTRB(25, 0, 25, 40),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: purple,
                ),
                child: Center(
                  child: Text(
                    "Complete",
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
        ),
      ),
    );
  }
}