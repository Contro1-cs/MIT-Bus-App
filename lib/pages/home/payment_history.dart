import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mit_bus_app/widgets/custom_snackbars.dart';

class PaymentHistory extends StatefulWidget {
  @override
  _PaymentHistoryState createState() => _PaymentHistoryState();
}

class _PaymentHistoryState extends State<PaymentHistory> {
  List<String> fileList = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchFileList();
  }

  Future<void> fetchFileList() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser!;
    final uid = user.uid;
    setState(() {
      isLoading = true;
    });

    try {
      final storageRef = FirebaseStorage.instance.ref().child(uid);
      final listResult = await storageRef.listAll();

      final files = listResult.items.map((fileRef) => fileRef.name).toList();

      setState(() {
        fileList = files;
        isLoading = false;
      });
    } catch (e) {
      errorSnackbar(context, 'Error fetching file list: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void openImage(String fileName) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser!;
    final uid = user.uid;
    final storageRef =
        FirebaseStorage.instance.ref().child(uid).child(fileName);
    storageRef.getDownloadURL().then((url) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              content: Center(
            child: Image.network(
              url,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              },
            ),
          ));
        },
      );
    }).catchError((error) {
      errorSnackbar(context, 'Could not open image');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: Text(
          "History",
          style: GoogleFonts.inter(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 40,
          ),
        ),
        backgroundColor: const Color(0xff202020),
        elevation: 0,
        automaticallyImplyLeading: true,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : fileList.isEmpty
              ? const Center(
                  child: Text('No files available'),
                )
              : Container(
                  margin: const EdgeInsets.symmetric(horizontal: 25),
                  child: ListView.builder(
                    itemCount: fileList.length,
                    itemBuilder: (context, index) {
                      final fileName = fileList[index];
                      return ListTile(
                        title: Text(
                          '${(index + 1).toString()}. $fileName',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                        onTap: () => openImage(fileName),
                      );
                    },
                  ),
                ),
    );
  }
}
