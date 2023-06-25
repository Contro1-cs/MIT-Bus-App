import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mit_bus_app/lists/lists.dart';
import 'package:mit_bus_app/pages/landing_page.dart';
import 'package:mit_bus_app/widgets/custom_snackbars.dart';
import 'package:mit_bus_app/widgets/custom_texts.dart';
import 'package:mit_bus_app/widgets/drop_down.dart';
import 'package:path/path.dart' as path;

class UploadFeesDoc extends StatefulWidget {
  const UploadFeesDoc({super.key});

  @override
  State<UploadFeesDoc> createState() => _UploadFeesDocState();
}

TextEditingController _transactionID = TextEditingController();

class _UploadFeesDocState extends State<UploadFeesDoc> {
  String _payment = paymentType[0];

  File? image;

  Future pickImage() async {
    try {
      XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) errorSnackbar(context, 'Faild to pick image');
      final receipt = File(image!.path);
      setState(() {
        this.image = receipt;
      });
      successSnackbar(context, 'Image picked successfully');
    } on PlatformException catch (e) {
      errorSnackbar(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
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
        automaticallyImplyLeading: false,
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
                    _payment = value!;
                  },
                  title: 'Payment method'),
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
                  child: image == null
                      ? Container(
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
                                "Screenshot of transaction",
                                style: GoogleFonts.inter(
                                  textStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.image,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                "Upload Different image",
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 200,
                          width: 200,
                          child: image == null
                              ? const CircularProgressIndicator()
                              : Image.file(image!),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          image == null
                              ? '0 MB'
                              : 'Size: ${(image!.lengthSync() / (1024 * 1024)).toStringAsFixed(2)} MB',
                          style: GoogleFonts.inter(
                            textStyle: TextStyle(
                              color: (image!.lengthSync() / (1024 * 1024)) <= 10
                                  ? Colors.white
                                  : Colors.red,
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
          Container(
            width: w,
            margin: const EdgeInsets.fromLTRB(25, 0, 25, 30),
            child: ElevatedButton(
              onPressed: () {
                if (_transactionID.text.trim().isEmpty) {
                  errorSnackbar(context, 'Upload Transaction ID');
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: purple),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Text(
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
