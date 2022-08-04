import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:insta/models/componants/Post.dart';
import 'package:uuid/uuid.dart';
import '../models/componants/User.dart' as model;

abstract class AuthManager {
  static final _auth = FirebaseAuth.instance;
  static final _db = FirebaseFirestore.instance;
  static final _storage = FirebaseStorage.instance;
  //siging here
  static Future<String> SignInWithEmailandPassword(email, password) async {
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        var result = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        print(result);
        return "Login Success";
      } else {
        return "pls fill all the fields";
      }
    } on FirebaseException catch (e) {
      var unwant = e.toString().split(" ")[0];
      return e.toString().replaceFirst(unwant, '');
    } catch (e) {
      return e.toString();
    }
  }

  //add  apost
  static Future<String> AddPost(caption, file, username, uid, profimg) async {
    try {
      // save image in storage
      var x = await addImage("posts", file, true);
      // creating a unique id using uuid package
      String Postid = Uuid().v1();

      var post =
          Post(caption, uid, username, [], Postid, DateTime.now(), x, profimg);

      var dbresult = _db.collection("posts").doc(Postid).set(post.toJson());

      return "Added Success";
    } catch (e) {
      return e.toString();
    }
  }

  // add image to storage
  static Future addImage(child, file, IsPost) async {
    try {
      if (!IsPost) {
        Reference ref =
            _storage.ref().child(child).child(_auth.currentUser!.uid);
        UploadTask myup = ref.putData(file);
        TaskSnapshot snap = await myup;
        return snap.ref.getDownloadURL();
      } else {
        var me = Uuid().v1();
        Reference ref =
            _storage.ref().child(child).child(_auth.currentUser!.uid).child(me);
        TaskSnapshot snap = await ref.putData(file);
        return snap.ref.getDownloadURL();
      }
    } catch (e) {
      print(e.toString());
    }
  }

  // registring here
  static Future<String> RegisterWithEmailandPassword(
      String email, String password, bio, username, Uint8List file) async {
    try {
      print("premier data");
      print(email);
      print(password);
      print(bio);
      print(username);
      print(file.runtimeType);
      if (email.isNotEmpty &&
          password.isNotEmpty &&
          username.isNotEmpty &&
          bio.isNotEmpty) {
        // creating a User instance

        UserCredential result = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        print(result);
        // add profile pic to our storage database because  we cant add it into firestore so basically  we created a fucntion for saving image and we will use it here to
        String url = await addImage("profilepics", file, false);
        print(url);
        //Creating a User Model
        model.User my_user = model.User(
            result.user!.uid, email, password, bio, username, [], [], url);
     
        print(my_user);

        var temp = await _db
            .collection("/users")
            .doc(result.user!.uid)
            .set(my_user.DataUser());
        print("i made it");

        return "Login Success";
      } 
      else{
        return " please fill all the fields";
      }
    } on FirebaseException catch (e) {
      String unwant = e.toString().split(" ")[0];
      return e.toString().replaceFirst(unwant, '');
    } catch (e) {
      return e.toString();
    }
  }
}
