import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


  bool _isLoading = false;
  bool get isLoading => _isLoading;
  bool status=false;

  final picker=ImagePicker();
  late String _image;


  Future pickGalleryImage(BuildContext context) async{
    final pickedFile=await picker.pickImage(source: ImageSource.gallery);

    if(pickedFile!=null) {
      _image = pickedFile.path;
    }
  }
  Future pickCameraImage(BuildContext context) async{

    final pickedFile=await picker.pickImage(source: ImageSource.camera);

    if(pickedFile!=null){
     _image=pickedFile.path;
    }
  }

Future<String?> pickImageEdit(BuildContext context) async {
  return showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: SizedBox(
          height: 120,
          child: Column(
            children: [
              ListTile(
                onTap: () async {
                  await pickCameraImage(context);
                  Navigator.pop(context, _image); // Return the image path
                },
                leading: const Icon(Icons.camera_alt),
                title: const Text("Camera"),
              ),
              ListTile(
                onTap: () async {
                  await pickGalleryImage(context);
                  Navigator.pop(context, _image); // Return the image path
                },
                leading: const Icon(Icons.photo),
                title: const Text("Gallery"),
              ),
            ],
          ),
        ),
      );
    },
  );
}





