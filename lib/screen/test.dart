import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class folders extends StatefulWidget {
  const folders({super.key});

  @override
  State<folders> createState() => _foldersState();
}

class Folder {
  String name;
  IconData icon;

  Folder({required this.name, required this.icon});
}

class _foldersState extends State<folders> {
  List<Folder> folders = [
    Folder(name: "Folder 1", icon: Icons.folder),
    Folder(name: "Folder 2", icon: Icons.folder),
    Folder(name: "Folder 3", icon: Icons.folder),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: folders.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: [
            Icon(folders[index].icon, size: 64),
            SizedBox(height: 8),
            Text(folders[index].name),
          ],
        );
      },
    );
  }
}
