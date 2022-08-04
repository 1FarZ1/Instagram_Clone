// ignore_for_file: non_constant_identifier_names

import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:insta/models/componants/User.dart' as model;

class UserProvider with ChangeNotifier {
  // ignore: prefer_typing_uninitialized_variables
  model.User? _user;

  model.User? get GetUser => _user;

  Future<void> Refresh_User() async {
  
    var snap = await FirebaseFirestore.instance
        // FROM THE COLLECTION USERS
        .collection('users')
        // the one that has a name of  our current user associated with this app
        .doc(FirebaseAuth.instance.currentUser!.uid)
        // to get it into a map foramt
        .get();
    var data = snap.data();
    model.User user = model.User(
        data!["uid"],
        data["email"],
        data["password"],
        data["bio"],
        data["username"],
        data["followers"],
        data["following"],
        data["pp_url"]);
    _user = user;
    notifyListeners();
  }
}
