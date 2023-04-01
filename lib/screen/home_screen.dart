import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/animation/animation_controller.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/src/widgets/ticker_provider.dart';
import 'package:login/screen/signin_screen.dart';
import 'package:login/screen/upload.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class homeScreen extends StatefulWidget {
  const homeScreen({super.key});

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  String url = "";
  int? num;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String adminEmail = "0000@gmail.com"; // Define the admin email
  bool isAdmin = false;

  @override
  void initState() {
    super.initState();
    checkAdmin();
  }

  Future<void> checkAdmin() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      // Check if the user is an admin
      setState(() {
        isAdmin = user.email == adminEmail;
      });
    }
  }

  // UploadDataToFirebase() async {
  //   // pick pdf file
  //   num = Random().nextInt(10);
  //   FilePickerResult? result = await FilePicker.platform.pickFiles();
  //   File pick = File(result!.files.single.path.toString());
  //   var file = pick.readAsBytesSync();
  //   String name = DateTime.now().millisecondsSinceEpoch.toString();
  //   // upload file to fire base

  //   var pdfFile = FirebaseStorage.instance.ref().child(name).child("/.pdf");
  //   UploadTask task = pdfFile.putData(file);
  //   TaskSnapshot snapshot = await task;
  //   url = await snapshot.ref.getDownloadURL();

  //   await FirebaseFirestore.instance
  //       .collection("file/2020")
  //       .doc()
  //       .set({'fileUrl': url, 'num': "Book" + num.toString()});
  // }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("PDF"),
      ),
      floatingActionButton: isAdmin
          ? FloatingActionButton(
              // onPressed: UploadDataToFirebase,
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return AddPdfModal();
                  },
                );
              },
              child: Icon(Icons.add),
            )
          : null,
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("pdfs").snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, i) {
                  QueryDocumentSnapshot x = snapshot.data!.docs[i];
                  return ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => View(url: x['url'])));
                    },
                    leading: Icon(Icons.picture_as_pdf),
                    title: Text(x["name"]),
                    // child: Container(
                    //   margin: EdgeInsets.symmetric(vertical: 10),
                    //   child: Text(x["num"]),
                    // ),
                  );
                });
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      // body: Center(
      //   child: ElevatedButton(
      //     child: Text("Log out"),
      //     onPressed: () {
      //       FirebaseAuth.instance.signOut().then((value) {
      //         print("you loged out successfully");
      //         Navigator.push(context,
      //             MaterialPageRoute(builder: (context) => SignInScreen()));
      //       });
      //     },
      //   ),
      // ),
    );
  }
}

class View extends StatelessWidget {
  final url;
  View({this.url});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text("PDF View"),
        ),
        body: Container(
            child: SfPdfViewer.network(url,
                pageLayoutMode: PdfPageLayoutMode.single)));
  }
}
