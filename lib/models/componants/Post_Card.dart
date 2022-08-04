import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insta/Screens/home/comment_screen.dart';
import 'package:insta/services/Data_manager.dart';
import 'package:insta/utilities/consts.dart';
import 'package:intl/intl.dart';

class PostCard extends StatefulWidget {
  Map<String, dynamic> snap;
  PostCard(
    this.snap,
  );

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  var len ;

  @override
  void initState() {
    super.initState();
    len= getComments();
  }

  Future<int> getComments() async {
 
      var temp = await FirebaseFirestore.instance
          .collection("posts")
          .doc(widget.snap["postId"])
          .collection("comments")
          .get();
        return temp.docs.length;

  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 13),
      child: Container(
        color: Color.fromARGB(255, 0, 0, 0),
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        width: double.infinity,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            children: [
              CircleAvatar(
                radius: 15,
                backgroundImage: NetworkImage(widget.snap["profImage"]),
              ),
              SizedBox(
                width: 12,
              ),
              Text(widget.snap["username"]),
              Spacer(),
              Icon(Icons.menu)
            ],
          ),
          SizedBox(
            height: 10,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.5,
              image: NetworkImage(widget.snap["postUrl"]),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            children: [
              InkWell(
                  onTap: () async {
                    var res = await DataManager.AddLikes(
                        FirebaseAuth.instance.currentUser!.uid,
                        widget.snap["postId"],
                        widget.snap["likes"]);
                   
                  },
                  child: Icon(
                    Icons.favorite,
                    color: widget.snap["likes"]
                            .contains(FirebaseAuth.instance.currentUser!.uid)
                        ? Colors.red
                        : Colors.white,
                  )),
              SizedBox(
                width: 20,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (ctx) => Comment(widget.snap)));
                },
                child: Icon(Icons.comment),
              ),
              SizedBox(
                width: 20,
              ),
              Icon(Icons.send),
              Spacer(),
              Icon(Icons.bookmark)
            ],
          ),
          SizedBox(
            height: 12,
          ),
          Text(" ${widget.snap['likes'].length} likes"),
          SizedBox(
            height: 7,
          ),
          Text.rich(TextSpan(
            children: [
              TextSpan(
                  text: '${widget.snap["username"]}\t',
                  style: TextStyle(fontWeight: FontWeight.w900)),
              TextSpan(
                  text: widget.snap["description"],
                  style: TextStyle(fontWeight: FontWeight.w700))
            ],
          )),
          SizedBox(
            height: 9,
          ),
          Text(
            "View All $len comments",
            style: TextStyle(color: Color(0xff565556)),
          ),
          SizedBox(
            height: 7,
          ),
          Text(
            DateFormat.yMMMd().format(widget.snap["datePublished"].toDate()),
            style: TextStyle(color: Color(0xff565556)),
          )
        ]),
      ),
    );
  }
}
