import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insta/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController lmodir = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<UserProvider>(context).GetUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Row(
          children: [
            CircleAvatar(radius: 15, backgroundColor: Colors.blue),
            SizedBox(
              width: 5,
            ),
            Text("Chat Screen"),
          ],
        ),
        leading: Padding(
          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios),
          ),
        ),
        actions: [
          Row(
            children: [
              Icon(
                Icons.videocam,
                size: 43,
              ),
              SizedBox(
                width: 20,
              ),
              Icon(
                Icons.info,
                size: 33,
              ),
              SizedBox(
                width: 20,
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("messages")
                    .snapshots(),
                builder: (context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  List all_mes = [];
                  var sender;
                  var text;
                  var photo;
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (!snapshot.hasData) {
                      return CircularProgressIndicator();
                    }
                    for (var message in snapshot.data!.docs) {
                      print(message.data());
                      sender = message["sender"];
                      text = message["text"];
                      photo = message["Photo"];
                      var Is_me =
                          FirebaseAuth.instance.currentUser!.uid == user!.uid;
                      all_mes.add(MessageCard(sender, text, photo, Is_me));
                    }
                    return Expanded(
                      child: ListView.builder(
                        reverse: true,
                        shrinkWrap: true,
                        itemCount: all_mes.length,
                        itemBuilder: (context, index) {
                          return all_mes[index];
                        },
                      ),
                    );
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else {
                    return Text("NO DATA");
                  }
                }),
          ],
        ),
      ),
      // will change this and add it into the column above since i used expanded woith the list view
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(vertical: 6, horizontal: 14),
        color: Colors.transparent,
        child: Row(
          children: [
            CircleAvatar(radius: 15, backgroundColor: Colors.blue),
            SizedBox(
              width: 20,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.7,
              child: TextField(
                controller: lmodir,
                decoration: InputDecoration(
                  hintText: "write...",
                  border: InputBorder.none,
                ),
              ),
            ),
            Spacer(),
            InkWell(
              onTap: () async {
                var messui = Uuid().v1();
                try {
                  await FirebaseFirestore.instance
                      .collection("messages")
                      .doc(messui)
                      .set({
                    "text": lmodir.text,
                    "sender": user!.username,
                    "Photo": user.photoUrl,
                    "uid": user.uid,
                    "data_published": DateTime.now(),
                  });
                } catch (e) {
                  print("something went wrong ");
                }
                lmodir.clear();
              },
              child: Text(
                "Post",
                style: TextStyle(fontSize: 17, color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageCard extends StatelessWidget {
  final sender;
  final text;
  final photo;
  final is_me;
  const MessageCard(this.sender, this.text, this.photo, this.is_me, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(is_me);
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 10),
        child: is_me
            ? Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(sender),
                        SizedBox(
                          height: 5,
                        ),
                        Material(
                          borderRadius: BorderRadius.circular(20),
                          elevation: 5.0,
                          color: !is_me
                              ? Color.fromARGB(255, 39, 38, 38)
                              : Colors.lightBlueAccent,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 10.0),
                            child: Text(
                              text,
                              maxLines: 20,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  CircleAvatar(
                      radius: 19, backgroundImage: NetworkImage(photo)),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                          radius: 19, backgroundImage: NetworkImage(photo)),
                      SizedBox(
                        width: 10,
                      ),
                      Text(sender),
                      SizedBox(
                        height: 5,
                      ),
                      Material(
                        borderRadius: BorderRadius.circular(20),
                        elevation: 5.0,
                        color: is_me
                            ? Color.fromARGB(255, 39, 38, 38)
                            : Colors.lightBlueAccent,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 10.0),
                          child: Text(
                            text,
                            maxLines: 20,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ));
  }
}
