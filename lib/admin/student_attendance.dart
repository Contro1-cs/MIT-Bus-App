import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentAttendance extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CollectionReference attendanceRef =
        FirebaseFirestore.instance.collection('attendance');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Attendance'),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: attendanceRef.get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No data available.'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot document = snapshot.data!.docs[index];
              String name = document['name'];
              String time = document['time'];
              String pickup = document['pickup'];
              String id = document['id'];
              String bus = document['bus'];

              return ListTile(
                title: Text('Name: $name'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Time: $time'),
                    Text('Pickup: $pickup'),
                    Text('ID: $id'),
                    Text('Bus: $bus'),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
