import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:login/screen/upload.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:url_launcher/url_launcher.dart';

class PDF {
  String name;
  String url;
  int year;
  String model;

  PDF(
      {required this.name,
      required this.url,
      required this.year,
      required this.model});
}

class Year {
  int year;
  List<PDF> pdfs;

  Year({required this.year, required this.pdfs});
}

class Model {
  String name;
  List<Year> years;

  Model({required this.name, required this.years});
}

class PDFList extends StatefulWidget {
  @override
  _PDFListState createState() => _PDFListState();
}

class _PDFListState extends State<PDFList> {
  List<Model> models = [];
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String adminEmail = "0000@gmail.com"; // Define the admin email
  bool isAdmin = false;

  @override
  void initState() {
    super.initState();
    _loadPDFs();
    // checkAdmin();
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

  void _loadPDFs() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('pdfs').get();

    // Group the PDFs by year and model
    snapshot.docs.forEach((doc) {
      String name = (doc.data() as Map)['name'];
      String url = (doc.data() as Map)['url'];
      int year = int.parse((doc.data() as Map)['year']);
      String model = (doc.data() as Map)['model'];

      // Find the model in our data structure, or create a new one if it doesn't exist
      Model modelObj = models.firstWhere((m) => m.name == model, orElse: () {
        Model newModel = Model(name: model, years: []);
        models.add(newModel);
        return newModel;
      });

      // Find the year in the model, or create a new one if it doesn't exist
      Year yearObj =
          modelObj.years.firstWhere((y) => y.year == year, orElse: () {
        Year newYear = Year(year: year, pdfs: []);
        modelObj.years.add(newYear);
        return newYear;
      });

      // Add the PDF to the year
      yearObj.pdfs.add(PDF(name: name, url: url, year: year, model: model));
    });

    final User? user = _auth.currentUser;
    if (user != null) {
      // Check if the user is an admin
      setState(() {
        isAdmin = user.email == adminEmail;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('PDF List')),
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
      body: ListView.builder(
        itemCount: models.length,
        itemBuilder: (BuildContext context, int modelIndex) {
          return ExpansionTile(
            title: Text(models[modelIndex].name),
            children: models[modelIndex].years.map((year) {
              return ExpansionTile(
                title: Text(year.year.toString()),
                children: year.pdfs.map((pdf) {
                  return ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => View(url: pdf.url)));
                    },
                    title: Text(pdf.name),
                    subtitle: GestureDetector(
                      onTap: () => launch(pdf.url),
                      child: Text('Download PDF'),
                    ),
                  );
                }).toList(),
              );
            }).toList(),
          );
        },
      ),
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
