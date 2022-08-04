import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

const kMobilebackgroundColor = Color.fromRGBO(0, 0, 0, 1);
const kWebBackgroundColor = Color.fromRGBO(18, 18, 18, 1);
const kMobileSearchColor = Color.fromRGBO(38, 38, 38, 1);
const kBlueColor = Color.fromRGBO(0, 149, 246, 1);
const kPrimaryColor = Colors.white;
const kSecondaryColor = Colors.grey;

// a flutter package to grap image from the gallery
pickImage(ImageSource source) async {
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _file = await _imagePicker.pickImage(source: source);
  if (_file != null) {
    return await _file.readAsBytes();
  }
  print('No Image Selected');
}

// returning a snackbar ;
showSnackBar(BuildContext context, String text) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      
      duration: Duration(seconds: 3),
      padding: EdgeInsets.fromLTRB(0,30,0,30),
      backgroundColor: Colors.white,
      content: Text(
        text,
        style:TextStyle(
          color:Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.w800
        ),
      ),
    ),
  );
}
