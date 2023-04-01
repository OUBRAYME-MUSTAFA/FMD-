import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:url_launcher/url_launcher.dart';

class YearPageNew extends StatelessWidget {
  final int year;
  const YearPageNew({required this.year});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$year"),
      ),
      body: Center(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('pdfs')
              .where('year', isEqualTo: year.toString())
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            if (!snapshot.hasData) {
              print('***************************this year= ${year}');
              return Text('No Data Found! in year  ${year}');
            }
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.0,
              ),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final doc = snapshot.data!.docs[index];
                final String? model = doc['model'] as String?;
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ModelPage(
                          year: year,
                          model: model!,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    child: Center(
                      child: Text('$model'),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class ModelPage extends StatelessWidget {
  final int year;
  final String model;
  const ModelPage({required this.year, required this.model});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$year - $model"),
      ),
      body: Center(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('pdfs')
              .where('year', isEqualTo: year.toString())
              .where('model', isEqualTo: model)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            if (!snapshot.hasData) {
              return Text('No Data Found!');
            }
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.0,
              ),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final doc = snapshot.data!.docs[index];
                final String? name = doc['name'] as String?;
                final String? url = doc['url'] as String?;
                return ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => View(url: url)));
                  },
                  title: Text('$name'),
                  trailing: IconButton(
                    icon: Icon(Icons.download),
                    onPressed: () => launch('$url'),
                  ),
                  //   subtitle: GestureDetector(
                  //   onTap: () => launch('$url'),
                  //   child: Text('Download PDF'),
                  // ),
                );
                // return InkWell(
                //   onTap: () {
                //     Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //             builder: (context) => View(url: url)));
                //   },
                //   // child: Card(
                //   //   child: Center(
                //   //     child: Text('$name'),
                //   //   ),
                //   // ),
                // );
              },
            );
          },
        ),
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
