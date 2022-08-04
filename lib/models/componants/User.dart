import 'dart:typed_data';

class User {
  String username, bio, email, password, photoUrl;
  List following, followers;
  var uid;

  User(this.uid, this.email, this.password, this.bio, this.username,
      this.followers, this.following, this.photoUrl);
  Map<String, dynamic> DataUser() {
    return {
      "uid":uid,
      "username": username,
      "bio": bio,
      "email": email,
      "password": password,
      "followers": followers,
      "following": following,
      "pp_url": photoUrl
    };
  }
}
