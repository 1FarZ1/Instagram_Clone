import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class DataManager {
  static Future<String> AddLikes(uid, postId, List likes) async {
    try {
      if (likes.contains(uid)) {
        // my methode
        // likes.remove(uid);
        await FirebaseFirestore.instance
            .collection("posts")
            .doc(postId)
            .update({
          //another mothode
          "likes": FieldValue.arrayRemove([uid])
        });
        return "already pressed like";
      } else {
        print("here");
        print(likes);
        await FirebaseFirestore.instance
            .collection("posts")
            .doc(postId)
            .update({
          //another mothode
          "likes": FieldValue.arrayUnion([uid])
        });
        return "Added";
      }
    } catch (e) {
      return e.toString();
    }
  }

  static Future<String> AddComment(
      text, postId, uid, time, photo, username) async {
    try {
      var tempuid = Uuid().v1();
      await FirebaseFirestore.instance
          .collection("posts")
          .doc(postId)
          .collection("comments")
          .doc(tempuid)
          .set({
        "commentText": text,
        "time": time,
        "uid": uid,
        "username": username,
        "photo": photo,
      });
      return "comment Success";
    } catch (e) {
      return e.toString();
    }
  }

  static Future<String> Follow(first, second) async {
    try {
      var snap =
          await FirebaseFirestore.instance.collection("users").doc(first).get();

      var following = snap.data()!["following"];
      print(following);
      if (following.contains(second)) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(second)
            .update({
          'followers': FieldValue.arrayRemove([first])
        });
        print(snap.data()!["following"]);

        await FirebaseFirestore.instance.collection('users').doc(first).update({
          'following': FieldValue.arrayRemove([second])
        });
        print(snap.data()!["following"]);
      } else {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(second)
            .update({
          'followers': FieldValue.arrayUnion([first])
        });
        print(snap.data()!["following"]);

        await FirebaseFirestore.instance.collection('users').doc(first).update({
          'following': FieldValue.arrayUnion([second])
        });
      }
      print(snap.data()!["following"]);
      return "Follow Success";
    } catch (e) {
      return e.toString();
    }
  }
}
//TODO ADD 3 THINGS :MESSAGES,4TH SECTION AND TAP ON USER IN HOME AND SHARE