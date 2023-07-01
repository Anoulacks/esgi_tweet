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
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.grey,
              width: 0.3,
            ),
          ),
          child: Material(
            child: IconButton(
              onPressed: pickImage,
              icon: Icon(
                Icons.photo_camera,
                color: Colors.blue,
                size: 30,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        image != null ? ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: AspectRatio(
            aspectRatio: 16/9,
            child: GestureDetector(
              onTap: () =>_showUserPictureDialog(context,image!),
              child: Image.file(
                image!,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ) : const Text('')
      ],
    );
  }

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(
          source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() {
        this.image = imageTemp;
        widget.callback(this.image);
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }
  void _showUserPictureDialog(BuildContext context, File imageURL) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
            child: Image.file(
              image!,
              fit: BoxFit.cover,
            )
        );
      },
    );
  }
}
