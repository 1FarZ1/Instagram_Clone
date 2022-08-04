import "package:flutter/material.dart";
import 'package:insta/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class CommenetCard extends StatefulWidget {
  var snap;
  CommenetCard(this.snap);
    var len = 0;

  @override
  State<CommenetCard> createState() => _CommenetCardState();
}

class _CommenetCardState extends State<CommenetCard> {
  ///  when i solved the problem i got in register screen  i  will change this to what i want so basically the uid is enough for all informations  but since my firestore of users is broken now i need to get all  data whe  he right comment unfortunally
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 13),
      child: Container(
          child: Row(
        children: [
          CircleAvatar(
            radius: 12,
            backgroundImage: NetworkImage(widget.snap["photo"]),
          ),
          SizedBox(
            width: 18,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(" ${widget.snap["username"]} ${widget.snap['commentText']}"),
                SizedBox(height: 8),
                Text(DateFormat.yMMMd().format(widget.snap["time"].toDate()),
                    style: TextStyle(color: Color(0xff565556), fontSize: 13))
              ],
            ),
          ),
          Icon(
            Icons.favorite_border,
            size: 15,
          ),
        ],
      )),
    );
  }
}
