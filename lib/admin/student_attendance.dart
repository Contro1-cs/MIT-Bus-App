import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mit_bus_app/pages/home/attendance_list.dart';
import 'package:mit_bus_app/pages/landing_page.dart';
import 'package:mit_bus_app/widgets/custom_list_tile.dart';

class AttendanceScreen extends StatefulWidget {
  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  String date = DateTime.now().toString();

  String _formatDigits(int digits) {
    return digits < 10 ? '0$digits' : '$digits';
  }

  Future<List<Map<String, dynamic>>> fetchAttendanceDocuments() async {
    List<Map<String, dynamic>> documents = [];

    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection('attendance').get();

    if (querySnapshot.docs.isNotEmpty) {
      documents = querySnapshot.docs.map((doc) => doc.data()).toList();
    }

    return documents;
  }

  Future<String> getDocumentId(DocumentReference docRef) async {
    DocumentSnapshot docSnapshot = await docRef.get();

    return docSnapshot.id;
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: purple,
          title: const Text('Attendance List'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Container(
                height: 50,
                width: w,
                margin: const EdgeInsets.fromLTRB(10, 10, 10, 5),
                child: TextButton.icon(
                  style: TextButton.styleFrom(backgroundColor: Colors.black),
                  onPressed: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2023),
                      lastDate: DateTime.now(),
                    ).then((value) {
                      if (value == null) {
                        return;
                      }
                      setState(
                        () {
                          date =
                              '${_formatDigits(value.day)}-${_formatDigits(value.month)}-${_formatDigits(value.year)}';
                        },
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AttendanceListPage(date: date),
                        ),
                      );
                      return null;
                    });
                  },
                  icon: const Icon(
                    Icons.calendar_month,
                    color: Colors.white,
                  ),
                  label: Text(
                    'Calendar view',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 10),
              child: Text(
                'Recent Dates:',
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
            ),
            Expanded(
              flex: 8,
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: fetchAttendanceDocuments(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasData) {
                    List<Map<String, dynamic>> documents = snapshot.data!;
                    return ListView.builder(
                      itemCount: documents.length,
                      itemBuilder: (context, index) {
                        String date =
                            documents[documents.length - index - 1]['date'];

                        return customListTile2(context, date, date);
                      },
                    );
                  }

                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('Error occurred while fetching data'),
                    );
                  }

                  return const Center(
                    child: Text('No data available'),
                  );
                },
              ),
            )
          ],
        ));
  }
}
