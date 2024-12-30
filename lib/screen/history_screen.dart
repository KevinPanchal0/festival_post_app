import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});
  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadImage();
  }

  List<File> editedImage = [];
  Future<void> loadImage() async {
    List<File> loadImage = await getHistory();
    setState(() {
      editedImage = loadImage;
    });
  }

  Future<void> deleteImage(File file) async {
    try {
      await file.delete();
      loadImage(); // Reload the images after deletion
    } catch (e) {
      print("Error deleting file: $e");
    }
  }

  Future<void> shareImage(File file) async{
    try {
      XFile xFile = XFile(file.path);
      await Share.shareXFiles([xFile]);
    } catch (e){
      print("Error sharing file: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: loadImage, icon: const Icon(Icons.restore_rounded))
        ],
      ),
      body: GridView.count(
        crossAxisCount: 3,
        children: List.generate(
          editedImage.length,
          (index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text(
                          'Options',
                          style: TextStyle(color: Colors.black),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              deleteImage(editedImage[index]);
                              Navigator.of(context).pop();
                            },
                            child: const Text('Delete'),
                          ),
                          TextButton(
                            onPressed: () {
                              shareImage(editedImage[index]);
                            },
                            child: const Text('Share'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Card(
                  elevation: 5,
                  child: Image(
                      width: 250,
                      height: 250,
                      image: Image.file(
                        File(editedImage[index].path),
                      ).image),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<List<File>> getHistory() async {
    List<File> editedImage = [];
    Directory? directory = await getApplicationDocumentsDirectory();
    List<FileSystemEntity> files = directory.listSync(recursive: true);
    for (FileSystemEntity file in files) {
      if (file is File && file.path.endsWith('.jpg')) {
        editedImage.add(file);
      }
    }
    return editedImage;
  }
}
