import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddPdfModal extends StatefulWidget {
  @override
  _AddPdfModalState createState() => _AddPdfModalState();
}

class _AddPdfModalState extends State<AddPdfModal> {
  late File _pdfFile;
  late String _selectedYear = '2021';
  late String _selectedModel = 'math';

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ******************************_selectedYear
        DropdownButtonFormField<String>(
          value: _selectedYear,
          items: [
            DropdownMenuItem<String>(
              value: '2021',
              child: Text('2021'),
            ),
            DropdownMenuItem<String>(
              value: '2022',
              child: Text('2022'),
            ),
            DropdownMenuItem<String>(
              value: '2023',
              child: Text('2023'),
            ),
          ],
          onChanged: (value) {
            setState(() {
              _selectedYear = value!;
            });
          },
          decoration: InputDecoration(
            labelText: 'Year',
          ),
        ),
        // ******************************_selectedModel
        DropdownButtonFormField<String>(
          value: _selectedModel,
          items: [
            DropdownMenuItem<String>(
              value: 'math',
              child: Text('math'),
            ),
            DropdownMenuItem<String>(
              value: 'phy',
              child: Text('phy'),
            ),
            DropdownMenuItem<String>(
              value: 'svt',
              child: Text('svt'),
            ),
          ],
          onChanged: (value) {
            setState(() {
              _selectedModel = value!;
            });
          },
          decoration: InputDecoration(
            labelText: 'Model',
          ),
        ),
        TextButton(
          onPressed: () async {
            final result = await FilePicker.platform.pickFiles(
              type: FileType.custom,
              allowedExtensions: ['pdf'],
            );
            if (result != null && result.files.isNotEmpty) {
              setState(() {
                _pdfFile = File(result.files.single.path!);
              });
            }
          },
          child: Text('Select PDF'),
        ),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: () async {
            if (_pdfFile != null && _selectedModel != null) {
              // Upload the PDF file to Firebase Storage
              Reference ref = FirebaseStorage.instance
                  .ref()
                  .child("pdfs/${_pdfFile.path.split('/').last}");
              UploadTask uploadTask = ref.putFile(_pdfFile);
              TaskSnapshot taskSnapshot = await uploadTask;
              String downloadUrl = await taskSnapshot.ref.getDownloadURL();

              // Store the PDF file metadata in Firebase Firestore
              FirebaseFirestore.instance.collection("pdfs").add({
                'name': _pdfFile.path.split('/').last,
                'url': downloadUrl,
                'year': _selectedYear,
                'model': _selectedModel,
              });

              // Close the modal bottom sheet
              Navigator.pop(context);
            }
          },
          child: Text('Submit'),
        ),
      ],
    );
  }
}
