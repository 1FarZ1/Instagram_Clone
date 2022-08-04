import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String description;
  final String uid;
  final String username;
  final likes;
  final String postId;
  final DateTime datePublished;
  final String postUrl;
  final String profImage;

  const Post(
       this.description,
       this.uid,
       this.username,
       this.likes,
       this.postId,
       this.datePublished,
       this.postUrl,
       this.profImage,
      );

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Post(
       snapshot["description"],
       snapshot["uid"],
       snapshot["likes"],
       snapshot["postId"],
       snapshot["datePublished"],
       snapshot["username"],
       snapshot['postUrl'],
       snapshot['profImage']
    );
  }

   Map<String, dynamic> toJson() => {
        "description": description,
        "uid": uid,
        "likes": likes,
        "username": username,
        "postId": postId,
        "datePublished": datePublished,
        'postUrl': postUrl,
        'profImage': profImage
      };
}

