import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login/screen/upload.dart';

import 'pdf.dart';

class YearPage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String adminEmail = "0000@gmail.com"; // Define the admin email
  bool isAdmin = false;

  Future<void> checkAdmin() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      // Check if the user is an admin
      isAdmin = user.email == adminEmail;
    }
  }
  // const YearPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CollectionReference pdfs = FirebaseFirestore.instance.collection('pdfs');
    checkAdmin();

    return Scaffold(
      appBar: AppBar(
        title: Text('Available Years'),
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
      body: StreamBuilder<QuerySnapshot>(
        stream: pdfs.orderBy('year', descending: true).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          List<int> years = [];

          for (var doc in snapshot.data!.docs) {
            int year = int.parse(doc['year']);
            if (!years.contains(year)) {
              years.add(year);
            }
          }

          return GridView.builder(
            padding: EdgeInsets.all(10),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.5,
            ),
            itemCount: years.length,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => YearPageNew(year: years[index])),
                  );
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    years[index].toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
