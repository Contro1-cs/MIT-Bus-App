import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mit_bus_app/pages/landing_page.dart';
import 'package:mit_bus_app/widgets/custom_list_tile.dart';

class AttendanceListPage extends StatefulWidget {
  final String date;
  const AttendanceListPage({
    Key? key,
    required this.date,
  }) : super(key: key);

  @override
  _AttendanceListPageState createState() => _AttendanceListPageState();
}

class _AttendanceListPageState extends State<AttendanceListPage> {
  late List<Map<String, dynamic>> originalDocuments;
  List<Map<String, dynamic>> filteredDocuments = [];

  @override
  void initState() {
    super.initState();
    fetchPresentStudents();
  }

  Future<void> fetchPresentStudents() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('attendance')
        .doc(widget.date)
        .collection(widget.date)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      originalDocuments = querySnapshot.docs.map((doc) => doc.data()).toList();
      filteredDocuments = List.from(originalDocuments);
    } else {
      originalDocuments = [];
      filteredDocuments = [];
    }

    setState(() {});
  }

  void filterList(String query) {
    setState(() {
      filteredDocuments = originalDocuments
          .where((doc) => doc['name']
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance List'),
        backgroundColor: purple,
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.black)),
            child: TextField(
              onChanged: (value) => filterList(value),
              decoration: InputDecoration(
                border: InputBorder.none,
                labelText: 'Search by Name',
                labelStyle: GoogleFonts.poppins(color: Colors.black),
              ),
              cursorColor: Colors.black,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredDocuments.length,
              itemBuilder: (context, index) {
                String name = filteredDocuments[index]['name'];
                String time = filteredDocuments[index]['time'];
                String bus = filteredDocuments[index]['bus'];
                String pickup = filteredDocuments[index]['pickup'];

                return customListTile3(context, name, time, bus, pickup);
              },
            ),
          ),
        ],
      ),
    );
  }
}
