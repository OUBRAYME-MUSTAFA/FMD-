// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class PdfList extends StatefulWidget {
//   @override
//   _PdfListState createState() => _PdfListState();
// }

// class _PdfListState extends State<PdfList> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('PDF List'),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance.collection('pdfs').orderBy('year').snapshots(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return Center(child: CircularProgressIndicator());
//           }

//           // Group documents by year
//           final yearGroups = groupBy(snapshot.data.docs, (doc) => doc['year']);

//           return ListView.builder(
//             itemCount: yearGroups.length,
//             itemBuilder: (context, index) {
//               final year = yearGroups.keys.toList()[index];
//               final yearDocs = yearGroups[year];

//               // Group year documents by model
//               final modelGroups = groupBy(yearDocs, (doc) => doc['model']);

//               return ExpansionTile(
//                 title: Text('Year $year'),
//                 children: [
//                   for (var model in modelGroups.keys)
//                     Column(
//                       children: [
//                         ListTile(title: Text
