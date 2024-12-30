import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pro_image_editor/pro_image_editor.dart';

import '../pages/preview_img.dart';

mixin ExampleHelperState<T extends StatefulWidget> on State<T> {
  final editorKey = GlobalKey<ProImageEditorState>();
  Uint8List? editedBytes;

  Future<void> onImageEditingComplete(bytes) async {
    String filename = DateTime.now().millisecondsSinceEpoch.toString();
    final Directory appDocumentsDir = await getApplicationDocumentsDirectory();
    final file = File('${appDocumentsDir.path}/$filename.jpg');
    await file.writeAsBytes(bytes);
    editedBytes = bytes;
    Navigator.pop(context);
  }
  void check (){

}
  void onCloseEditor() {
    if (editedBytes != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return PreviewImgPage(imgBytes: editedBytes!);
          },
        ),
      ).whenComplete(() {
        editedBytes = null;
      });
    } else {
      Navigator.pop(context);
      print(editedBytes);
    }
  }
}
