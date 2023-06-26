import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mit_bus_app/lists/lists.dart';
import 'package:mit_bus_app/pages/home/home.dart';
import 'package:mit_bus_app/pages/landing_page.dart';
import 'package:mit_bus_app/widgets/custom_snackbars.dart';
import 'package:mit_bus_app/widgets/custom_texts.dart';
import 'package:mit_bus_app/widgets/drop_down.dart';
import 'package:path/path.dart' as path;

class UploadFeesDoc extends StatefulWidget {
  const UploadFeesDoc({Key? key}) : super(key: key);

  @override
  State<UploadFeesDoc> createState() => _UploadFeesDocState();
}

TextEditingController _transactionID = TextEditingController();
bool _uploading = false;

class _UploadFeesDocState extends State<UploadFeesDoc> {
  String _payment = paymentType[0];
  final storageRef = FirebaseStorage.instance.ref();

  File? image;
  double _uploadProgress = 0.0;

  @override
  void initState() {
    image = null;
    _transactionID.text = '';
    super.initState();
  }

  @override
  void dispose() {
    image = null;
    _transactionID.text = '';
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser!;
    final uid = user.uid;

    Future pickImage() async {
      try {
        XFile? image =
            await ImagePicker().pickImage(source: ImageSource.gallery);
        if (image == null) errorSnackbar(context, 'Failed to pick image');
        final receipt = File(image!.path);
        setState(() {
          this.image = receipt;
        });
      } on PlatformException catch (e) {
        errorSnackbar(context, e.toString());
      }
    }

    Future<void> uploadImageToFirebaseStorage() async {
      String filePath = image!.path;
      File file = File(filePath);

      try {
        var imageRef = storageRef.child("$uid/${_transactionID.text}.png");

        var uploadTask = imageRef.putFile(file);

        uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
          setState(() {
            _uploadProgress = snapshot.bytesTransferred / snapshot.totalBytes;
          });
        });

        await uploadTask;

        successSnackbar(context, 'Image uploaded successfully!');
        Navigator.pop(context);
      } catch (e) {
        errorSnackbar(context, 'Something went wrong: ${e.toString()}');
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 80,
        title: Text(
          "Fee Receipt",
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(height: 10),
          Column(
            children: [
              CustomFormField(
                title: 'Transaction ID',
                hint: 'UPI or Bank transaction ID',
                keyboardType: TextInputType.text,
                controller: _transactionID,
              ),
              const SizedBox(height: 20),
              CustomDropdownMenu(
                value: _payment,
                list: paymentType,
                onChanged: (value) {
                  setState(() {
                    _payment = value!;
                  });
                },
                title: 'Payment method',
              ),
              const SizedBox(height: 20),
              Visibility(
                visible: image != null,
                child: Container(
                  width: w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: purple,
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 25),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    child: SizedBox(
                      height: 200,
                      width: 200,
                      child: image == null
                          ? const CircularProgressIndicator()
                          : Image.file(image!),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: w,
                margin: const EdgeInsets.symmetric(horizontal: 25),
                child: ElevatedButton(
                  onPressed: () {
                    pickImage();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        image == null ? purple : const Color(0XFF3F9056),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.upload_file_outlined,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          image == null
                              ? "Screenshot of transaction"
                              : "Upload Different image",
                          style: GoogleFonts.inter(
                            textStyle: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            width: w,
            margin: const EdgeInsets.fromLTRB(25, 0, 25, 30),
            child: ElevatedButton(
              onPressed: () {
                if (_transactionID.text.trim().isEmpty) {
                  errorSnackbar(context, 'Upload Transaction ID');
                } else if (image == null) {
                  errorSnackbar(context, 'Please add an image');
                } else {
                  if (_uploading != true) {
                    setState(() {
                      _uploading = true;
                    });
                    uploadImageToFirebaseStorage().then((_) {
                      setState(() {
                        _uploading = false;
                      });
                    });
                  }
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: purple),
              child: Container(
                alignment: Alignment.center,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: _uploading
                    ? const CircularProgressIndicator()
                    : Text(
                        "Upload",
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
        ],
      ),
    );
  }
}
