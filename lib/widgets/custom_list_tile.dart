import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mit_bus_app/pages/landing_page.dart';

customListTile(context, String title, String description, DocumentSnapshot user,
    int fees) {
  return Card(
    elevation: 8.0,
    margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
    child: Container(
      alignment: Alignment.center,
      decoration: const BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        title: Text(
          title,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        subtitle:
            Text(description, style: const TextStyle(color: Colors.white)),
        trailing: const Icon(Icons.keyboard_arrow_right,
            color: Colors.white, size: 30.0),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserDetailsPage(
              user: user,
              userName: title,
              pendingFees: fees,
            ),
          ),
        ),
      ),
    ),
  );
}

class UserDetailsPage extends StatelessWidget {
  final String userName;
  final DocumentSnapshot user;
  final int pendingFees;

  const UserDetailsPage({
    required this.userName,
    required this.user,
    required this.pendingFees,
  });

  @override
  Widget build(BuildContext context) {
    final userData = user.data() as Map<String, dynamic>;
    final paidFeesPercent = ((40000 - pendingFees) / 40000);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: const Color(0xFF202020),
        title: Text(
          userName,
          style: GoogleFonts.inter(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            children: [
              Container(
                margin: const EdgeInsets.all(15),
                child: SingleChildScrollView(
                  child: DataTable(
                    columns: const <DataColumn>[
                      DataColumn(
                        label: Text(
                          'Info',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Value',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                    rows: userData.entries.map((entry) {
                      return DataRow(
                        cells: <DataCell>[
                          DataCell(Text(entry.key)),
                          DataCell(Text(entry.value.toString())),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '${(paidFeesPercent * 100).round()}% Paid - $pendingFees is pending',
                      style: GoogleFonts.inter(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 20),
                      width: 300,
                      height: 10,
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        child: LinearProgressIndicator(
                          value: paidFeesPercent,
                          valueColor: paidFeesPercent >= 50
                              ? const AlwaysStoppedAnimation<Color>(Colors.red)
                              : const AlwaysStoppedAnimation<Color>(
                                  Colors.green),
                          backgroundColor: Colors.grey.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Column(
            children: [
              Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: purple),
                  child: Text(
                    'Go back',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          )
        ],
      ),
    );
  }
}