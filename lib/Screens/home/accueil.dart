import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:insta/Screens/home/chatScreen.dart';
import 'package:insta/models/componants/Post.dart';
import 'package:insta/models/componants/Post_Card.dart';

class Feed extends StatefulWidget {
  const Feed({Key? key}) : super(key: key);

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  // TODO: I WILL ADD  DELETE A POST LATER ON   ; EZ  DO IT WITH DIALOG
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ChatScreen();
                    }));
                  },
                  child: Icon(Icons.message)),
            ),
          ],
          title: SvgPicture.asset(
            "assets/ic_instagram.svg",
            color: Colors.white,
            height: 40,
          ),
        ),
        // here we need to use stream build bcz we need to event loop  posts
        body: StreamBuilder(
            stream: FirebaseFirestore.instance.collection("posts").snapshots(),
            builder: (ctx,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (ctx, index) {
                        return PostCard(snapshot.data!.docs[index].data());
                      });
                }
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }
              return Text("No Posts now");
            }));
  }
}
