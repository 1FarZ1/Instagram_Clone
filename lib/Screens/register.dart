import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:insta/Screens/home/home_screen.dart';
import 'package:insta/services/auth_manager.dart';
import 'package:insta/utilities/consts.dart';
import '../models/componants/classes.dart';
import 'package:image_picker/image_picker.dart';

var _image;

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  // creating a controller for email and password
  TextEditingController _Emailcontroller = TextEditingController();
  TextEditingController _Passcontroller = TextEditingController();
  TextEditingController _Biocontroller = TextEditingController();
  TextEditingController _Usernamecontroller = TextEditingController();
  String error = "";
  bool _isLoading = false;
  var imageInstance;
  @override
  void initState() {
    // TODO: implement initState
    imageInstance = Photo_with_icon();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose

    // we need to clear our controllers after we destroy this widget
    super.dispose();
    _Emailcontroller.dispose();
    _Passcontroller.dispose();
    _Biocontroller.dispose();
    _Usernamecontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(30, 20, 30, 10),
        child: Column(
          children: [
            SvgPicture.asset("assets/ic_instagram.svg",
                height: 64, color: kPrimaryColor),
            Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: imageInstance),
            const SizedBox(
              height: 24,
            ),
            CustomTextField("Email", false, _Emailcontroller),
            CustomTextField("Password", true, _Passcontroller),
            CustomTextField("Bio", false, _Biocontroller),
            CustomTextField("Username", false, _Usernamecontroller),
            Text(
              error,
              style: TextStyle(
                  color: error.contains("Success")
                      ? Color.fromARGB(255, 4, 243, 12)
                      : Color.fromARGB(255, 239, 12, 12),
                  fontSize: 16),
            ),
            Button("Register", () async {
              setState(() {
                _isLoading = true;
              });
              Uint8List mypath = _image;
              if (mypath != null) {
                print("good");
              } else {
                print("Failed----");
              }

              await Future.delayed(Duration(seconds: 2));

              var result = await AuthManager.RegisterWithEmailandPassword(
                  _Emailcontroller.text,
                  _Passcontroller.text,
                  _Biocontroller.text,
                  _Usernamecontroller.text,
                  mypath);
              print(result);
              setState(() {
                error = result;
              });
              if (result.contains("Success")) {
                setState(() {
                  _isLoading = false;
                });
                await Future.delayed(Duration(seconds: 10));
                Navigator.of(context)
                    .pushReplacement(MaterialPageRoute(builder: (e) {
                  return Home();
                }));
              } else {
                setState(() {
                  _isLoading = false;
                });
                showSnackBar(context, result);
              }
            }),
            Visibility(visible: _isLoading, child: CircularProgressIndicator())
          ],
        ),
      )),
    );
  }
}

class Photo_with_icon extends StatefulWidget {
  dynamic image = NetworkImage(
      "https://soccerpointeclaire.com/wp-content/uploads/2021/06/default-profile-pic-e1513291410505.jpg");

  @override
  State<Photo_with_icon> createState() => _Photo_with_iconState();
}

///// a big comment here: I will change this so i can use it from another file later on , i tried to do it but i didnt  manage to do it  , i tried to return the image in a variable or a methode but all i recieved was null , i tried everything  i can so i guess im wrong with the architucutre not the logic , i think i need to use a key
class _Photo_with_iconState extends State<Photo_with_icon> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        ClipRRect(
            borderRadius: BorderRadius.circular(80.0),
            child: Image(
              height: 120.0,
              width: 120.0,
              fit: BoxFit.cover,
              image: widget.image,
            )),
        InkWell(
          onTap: () async {
            var result = await pickImage(ImageSource.gallery);
            setState(() {
              widget.image = MemoryImage(result);
              _image = result;
            });
          },
          child: Icon(
            Icons.photo_camera,
            size: 30,
          ),
        )
      ],
    );
  }
}
