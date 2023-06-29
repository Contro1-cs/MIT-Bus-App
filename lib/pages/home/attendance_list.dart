import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mit_bus_app/widgets/custom_list_tile.dart';

class AttendanceListPage extends StatefulWidget {
  final DocumentReference docRef;
  final String date;
  const AttendanceListPage({
    super.key,
    required this.docRef,
    required this.date,
  });

  @override
  State<AttendanceListPage> createState() => _AttendanceListPageState();
}

class _AttendanceListPageState extends State<AttendanceListPage> {
  Future<List<Map<String, dynamic>>> fetchPresentStudents() async {
    List<Map<String, dynamic>> documents = [];

    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('attendance')
        .doc(widget.date)
        .collection(widget.date)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      documents = querySnapshot.docs.map((doc) => doc.data()).toList();
    }

    return documents;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance List'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchPresentStudents(),
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
                String name = documents[index]['name'];
                String time = documents[index]['time'];

                return ListTile(
                  title: Text(name),
                  subtitle: Text(time),
                );
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
    );
  }
}
