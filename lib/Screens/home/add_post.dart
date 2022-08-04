import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta/models/componants/User.dart';
import 'package:insta/providers/user_provider.dart';
import 'package:insta/services/auth_manager.dart';
import 'package:insta/utilities/consts.dart';
import 'package:provider/provider.dart';

class AddPost extends StatefulWidget {
  const AddPost({Key? key}) : super(key: key);

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  Uint8List? _file;
  bool _isLoading = false;
  TextEditingController lmodir = TextEditingController();
  createDialog(context) {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text("Create  a Post"),
            children: [
              SimpleDialogOption(
                padding: EdgeInsets.all(20),
                child: Text("Take  a photo"),
                onPressed: () async {
                  Navigator.pop(context);
                  var file = await pickImage(ImageSource.camera);

                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: EdgeInsets.all(20),
                child: Text("Choose a photo"),
                onPressed: () async {
                  Navigator.pop(context);
                  var file = await pickImage(ImageSource.gallery);
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: EdgeInsets.all(20),
                child: Text("cancel"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    lmodir.dispose();
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).GetUser as User;

    return _file == null
        ? Center(
            child: InkWell(
              onTap: () {
                // ignore: void_checks
                return createDialog(context);
              },
              child: Icon(
                Icons.upload,
                size: 70,
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              actions: [
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, right: 20),
                  child: InkWell(
                    onTap: () async {
                      setState(() {
                        _isLoading = true;
                      });
                      var result = await AuthManager.AddPost(lmodir.text, _file,
                          user.username, user.uid, user.photoUrl);
                      print(result);
                          setState(() {
                        _isLoading = false;
                      });
                      if (result.contains("Success")) {
                        showSnackBar(context, result);
                        Future.delayed(Duration(seconds: 3));

                        setState(() {
                          _file = null;
                        });
                      } else {
                        showSnackBar(context, result);
                      }
                    },
                    child: Text("Post",
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 18,
                            fontWeight: FontWeight.w800)),
                  ),
                )
              ],
              backgroundColor: Colors.transparent,
              leading: Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Icon(Icons.arrow_back_ios)),
              title: Text(
                "Post to",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800),
              ),
            ),
            body: SingleChildScrollView(
              child: Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 15.0),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(user.photoUrl),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: Stack(
                      alignment: Alignment.topRight,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Container(
                            width: 330,
                            height: 200,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                                image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: MemoryImage(_file as Uint8List))),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Icon(
                            Icons.add,
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: TextField(
                        controller: lmodir,
                        decoration: InputDecoration(
                          hintText: "        write caption....",
                          border: InputBorder.none,
                        ),
                        maxLines: 8,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: _isLoading,
                    child: LinearProgressIndicator(),
                  )
                ],
              )),
            ),
          );
  }
}
