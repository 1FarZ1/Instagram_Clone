import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:insta/models/componants/commentCard.dart';
import 'package:insta/services/Data_manager.dart';
import 'package:provider/provider.dart';

import '../../providers/user_provider.dart';
import '../../utilities/consts.dart';

//TODO: add a top in comment  for the post creator, add extra section for idk

class Comment extends StatefulWidget {
  var snap;

  Comment(this.snap);

  @override
  State<Comment> createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  TextEditingController lmodir = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    lmodir.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<UserProvider>(context).GetUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text("Comments"),
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios, size: 30)),
        toolbarHeight: 50,
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("posts")
              .doc(widget.snap["postId"])
              .collection("comments")
              .orderBy("time")
              .snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return CommenetCard(snapshot.data!.docs[index].data());
                },
              );
            } else {
              return Center(child: Text("no comments"));
            }
          }),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 6, horizontal: 14),
          color: Colors.transparent,
          child: Row(
            children: [
              CircleAvatar(
                radius: 15,
                backgroundImage: NetworkImage(user!.photoUrl == null
                    ? "https://images.unsplash.com/photo-1657299143548-658603d76b1b?ixlib=rb-1.2.1&ixid=MnwxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=402&q=80"
                    : user.photoUrl),
              ),
              SizedBox(
                width: 20,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.7,
                child: TextField(
                  controller: lmodir,
                  decoration: InputDecoration(
                    hintText: "write comment...",
                    border: InputBorder.none,
                  ),
                ),
              ),
              Spacer(),
              InkWell(
                onTap: () async {
                  var result = await DataManager.AddComment(
                      lmodir.text,
                      widget.snap["postId"],
                      FirebaseAuth.instance.currentUser!.uid,
                      DateTime.now(),
                      user.photoUrl,
                      user.username);
                  Future.delayed(Duration(seconds: 2));
                  if (result.contains("Success")) {
                    showSnackBar(context, result);
                    setState(() {
                      lmodir.clear();
                    });
                  } else {
                    showSnackBar(context, result);
                    setState(() {
                      lmodir.clear();
                    });
                  }
                },
                child: Text(
                  "Post",
                  style: TextStyle(fontSize: 17, color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
