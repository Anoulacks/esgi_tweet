import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatefulWidget {
  final Function(File?) callback;
  const ImagePickerWidget({Key? key, required this.callback}) : super(key: key);

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {

  File? image;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
            onPressed: () {
              pickImage();
            },
            child: const Text('selectionnez un fichier')
        ),
        const SizedBox(height: 20,),
        image != null ? Image.file(image!) : const Text('')
      ],
    );
  }

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery, maxHeight: 100, maxWidth: 100);
      if(image == null) return;
      final imageTemp = File(image.path);
      setState(() {
        this.image = imageTemp;
        widget.callback(this.image);
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }
}
