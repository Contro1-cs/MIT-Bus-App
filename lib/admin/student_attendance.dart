import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mit_bus_app/pages/landing_page.dart';
import 'package:mit_bus_app/widgets/custom_list_tile.dart';

class AttendanceScreen extends StatefulWidget {
  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: purple,
        title: const Text('Attendance List'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
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
                String date = documents[index]['date'];
                DocumentReference docRef = FirebaseFirestore.instance
                    .collection('attendance')
                    .doc(date);

                return customListTile2(context, date, docRef, date);
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
