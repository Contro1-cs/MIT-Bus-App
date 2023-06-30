import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mit_bus_app/pages/home/home.dart';
import 'package:mit_bus_app/pages/landing_page.dart';
import 'package:mit_bus_app/widgets/custom_snackbars.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class Attendance extends StatefulWidget {
  @override
  _AttendanceState createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  QRViewController? _controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  PermissionStatus _cameraPermissionStatus = PermissionStatus.denied;
  bool _codeScanned = false;

  @override
  void initState() {
    super.initState();
    _checkCameraPermissionStatus();
  }

  Future<void> _checkCameraPermissionStatus() async {
    final status = await Permission.camera.status;
    setState(() {
      _cameraPermissionStatus = status;
    });

    if (_cameraPermissionStatus.isDenied) {
      await _requestCameraPermission();
    }
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    setState(() {
      _cameraPermissionStatus = status;
    });
  }

  Widget _buildCameraPermissionDeniedView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Camera permission is required to use the QR scanner.',
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              _requestCameraPermission();
            },
            child: const Text('Request Permission'),
          ),
        ],
      ),
    );
  }

  Widget _buildCameraPermissionGrantedView() {
    return Column(
      children: [
        Expanded(
          flex: 5,
          child: QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
          ),
        ),
      ],
    );
  }

  Widget _buildCameraPermissionLoadingView() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraPermissionStatus.isDenied) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('QR Code Scanner'),
          backgroundColor: Colors.black,
        ),
        body: _buildCameraPermissionDeniedView(),
      );
    }

    if (_cameraPermissionStatus.isGranted) {
      return WillPopScope(
        onWillPop: () async {
          _controller?.dispose();
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('QR Code Scanner'),
            backgroundColor: Colors.black,
          ),
          body: _buildCameraPermissionGrantedView(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code Scanner'),
        backgroundColor: Colors.black,
      ),
      body: _buildCameraPermissionLoadingView(),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    if (_codeScanned) return;
    setState(() {
      _controller = controller;
      _controller!.scannedDataStream.listen((scanData) {
        _codeScanned = true;
        _controller!.pauseCamera();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QRResultPage(scannedCode: scanData.code!),
          ),
        ).then((_) {
          _controller!.resumeCamera();
          _codeScanned = false;
        });
      });
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}

class QRResultPage extends StatelessWidget {
  final String scannedCode;

  QRResultPage({required this.scannedCode});

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    // var h = MediaQuery.of(context).size.height;

    CollectionReference users = FirebaseFirestore.instance.collection('users');
    CollectionReference attendanceRef =
        FirebaseFirestore.instance.collection('attendance');
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User _user = _auth.currentUser!;
    final uid = _user.uid;

    String time;
    String date;

    String _formatDigits(int digits) {
      return digits < 10 ? '0$digits' : '$digits';
    }

    String getCurrentTime() {
      DateTime now = DateTime.now();
      String currentTime =
          '${_formatDigits(now.hour)}:${_formatDigits(now.minute)}';
      return currentTime;
    }

    String getCurrentDate() {
      DateTime now = DateTime.now();
      String currentDate =
          '${_formatDigits(now.day)}-${_formatDigits(now.month)}-${_formatDigits(now.year)}';
      return currentDate;
    }

    time = getCurrentTime();
    date = getCurrentDate();

    Future<void> markAttendance(
      String name,
      String time,
      String pickup,
      String id,
      String bus,
    ) async {
      DocumentReference addDate = attendanceRef.doc(date);
      DocumentReference docRef =
          attendanceRef.doc(date).collection(date).doc(uid);
      DocumentSnapshot docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        successSnackbar(context, 'Attendance marked already');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
        );
        return;
      }

      addDate.set({
        'date': date,
      });

      docRef.set({
        'name': name,
        'time': time,
        'pickup': pickup,
        'id': id,
        'bus': bus,
      }).then((value) {
        successSnackbar(context, 'Data uploaded successfully');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
        );
      }).catchError((error) {
        errorSnackbar(context, 'Failed to upload data. $error');
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mark Attendance'),
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: users.doc(uid).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong"));
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => LoginPage(),
            //   ),
            // );
            return const Center(
              child: Text('Something went wrong'),
            );
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(height: 10),
                Column(
                  children: [
                    Text(
                      '${data['userName']}',
                      style: GoogleFonts.inter(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      scannedCode,
                      style: GoogleFonts.inter(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 50),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              decoration: BoxDecoration(
                                color: purple,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    "Time",
                                    style: GoogleFonts.inter(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    time,
                                    style: GoogleFonts.inter(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              decoration: BoxDecoration(
                                color: purple,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    "Date",
                                    style: GoogleFonts.inter(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    date,
                                    style: GoogleFonts.inter(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
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
                      width: w,
                      height: 50,
                      margin: const EdgeInsets.symmetric(horizontal: 25),
                      child: ElevatedButton(
                        onPressed: () {
                          markAttendance(
                            data['userName'],
                            time,
                            data['pickupPoint'],
                            uid,
                            scannedCode,
                          );
                        },
                        style:
                            ElevatedButton.styleFrom(backgroundColor: purple),
                        child: const Text('Mark Present'),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                )
              ],
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
