// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PdfsPage extends StatelessWidget {
  final CollectionReference pdfsCollection =
      FirebaseFirestore.instance.collection('pdfs');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDFs'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: pdfsCollection.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final documents = snapshot.data!.docs;

          // Group documents by model, then by year
          final Map<String, Map<int, List<DocumentSnapshot>>> groupedDocuments =
              {};

          for (final doc in documents) {
            final model = doc['model'];
            final year = int.parse(doc['year']);

            if (!groupedDocuments.containsKey(model)) {
              groupedDocuments[model] = {};
            }

            if (!groupedDocuments[model]!.containsKey(year)) {
              groupedDocuments[model]![year] = [];
            }

            groupedDocuments[model]![year]!.add(doc);
          }

          // Create a list of models
          final models = groupedDocuments.keys.toList();

          return ListView.builder(
            itemCount: models.length,
            itemBuilder: (context, index) {
              final model = models[index];
              final years = groupedDocuments[model]!.keys.toList();

              return ExpansionTile(
                title: Text(model),
                children: years.map((year) {
                  final pdfs = groupedDocuments[model]![year]!;
                  return ListTile(
                    title: Text(year.toString()),
                    onTap: () {},
                    subtitle: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: pdfs.length,
                      itemBuilder: (context, index) {
                        final pdf = pdfs[index];
                        return GestureDetector(
                          child: Text(pdf['name']),
                          onTap: () => launch(pdf['url']),
                        );
                      },
                    ),
                  );
                }).toList(),
              );
            },
          );
        },
      ),
    );
  }
}
