import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insta/services/Data_manager.dart';
import 'package:insta/utilities/consts.dart';

class ProfileScreen extends StatefulWidget {
  final String uuid;
  const ProfileScreen(this.uuid, {Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var data;
  @override
  void initState() {
    super.initState();
  }

  Future<Map<String, dynamic>> getData() async {
    var postSnap = await FirebaseFirestore.instance
        .collection('posts')
        .where('uid', isEqualTo: widget.uuid)
        .get();

    var snap = await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.uuid)
        .get();
    bool isFollowing = snap
        .data()!['followers']
        .contains(FirebaseAuth.instance.currentUser!.uid);
    data = snap.data();
    var all_data = {
      "pp_url": data["pp_url"],
      "username": data["username"],
      "followers": data["followers"],
      "following": data["following"],
      "bio": data["bio"],
      "post": postSnap.docs.length,
      "Is_following": isFollowing
    };
    return all_data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            leading: Icon(Icons.arrow_back_ios),
            title: Text("Fares bek")),
        body: FutureBuilder(
          future: getData(),
          builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              children: [
                                ClipRRect(
                                    borderRadius: BorderRadius.circular(80.0),
                                    child: Image(
                                      height: 90.0,
                                      width: 90.0,
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                          snapshot.data!["pp_url"]),
                                    )),
                                SizedBox(width: 3),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          CustomTextWidget(
                                              "Posts",
                                              snapshot.data!["followers"].length
                                                  .toString()),
                                          CustomTextWidget(
                                              "Followers",
                                              snapshot.data!["followers"].length
                                                  .toString()),
                                          CustomTextWidget(
                                              "Following",
                                              snapshot.data!["following"].length
                                                  .toString())
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),

                                      // we use this when we need to fetch another user account
                                      // Container(
                                      //   decoration: BoxDecoration(
                                      //       color: Colors.blue,
                                      //       borderRadius: BorderRadius.circular(30),
                                      //   ),
                                      //   padding: EdgeInsets.symmetric(
                                      //       vertical: 10,
                                      //       horizontal:
                                      //           MediaQuery.of(context).size.width * 0.25),

                                      //   child: Text("Follow"),
                                      // )

                                      // but for our progile we display this

                                      FirebaseAuth.instance.currentUser!.uid ==
                                              widget.uuid
                                          ? Container(
                                              decoration: BoxDecoration(
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  border: Border.all(
                                                      color: Colors.white)),
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 10,
                                                  horizontal:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.25),
                                              child: Text("Edit Profile"),
                                            )
                                          : !snapshot.data!["Is_following"]
                                              ? InkWell(
                                                  onTap: () async {
                                                    var result =
                                                        await DataManager
                                                            .Follow(
                                                      FirebaseAuth.instance
                                                          .currentUser!.uid,
                                                      snapshot.data!['uid'],
                                                    );
                                                    print('here');
                                                    print(result);
                                                    setState(() {
                                                      snapshot.data![
                                                          "isFollowing"] = true;
                                                    });
                                                  },
                                                  child: InkWell(
                                                    onTap: () async {
                                                      var result =
                                                          await DataManager
                                                              .Follow(
                                                        FirebaseAuth.instance
                                                            .currentUser!.uid,
                                                        snapshot.data!['uid'],
                                                      );
                                                      print('here');
                                                      print(result);
                                                      setState(() {
                                                        snapshot.data![
                                                                "isFollowing"] =
                                                            false;
                                                      });
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          color: Colors.blue,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(30),
                                                          border: Border.all(
                                                              color: Colors
                                                                  .white)),
                                                      padding: EdgeInsets.symmetric(
                                                          vertical: 10,
                                                          horizontal:
                                                              MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.25),
                                                      child: Text("Follow"),
                                                    ),
                                                  ),
                                                )
                                              : Container(
                                                  decoration: BoxDecoration(
                                                      color: Color.fromARGB(
                                                          255, 0, 0, 0),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30),
                                                      border: Border.all(
                                                          color: Colors.white)),
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 10,
                                                      horizontal:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.25),
                                                  child: Text("unFollow"),
                                                )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),

                          //bio section
                          SizedBox(
                            height: 8,
                          ),
                          Text('  FarZ'),
                          SizedBox(
                            height: 7,
                          ),
                          Text(snapshot.data!["bio"]),

                          // Post Section
                        ]),
                  ),
                );
              } else {
                return Text("something went wrong");
              }
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else {
              print('jere');
              return CircularProgressIndicator();
            }
          },
        ));
  }
}

class CustomTextWidget extends StatelessWidget {
  String upTxt;
  String litTxt;
  CustomTextWidget(this.upTxt, this.litTxt);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(13, 9, 5, 10),
      child: Column(
        children: [
          Text(this.litTxt,
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
          SizedBox(
            height: 3,
          ),
          Text(this.upTxt,
              style: TextStyle(
                  fontSize: 16,
                  color: Color(0xff403E40),
                  fontWeight: FontWeight.w700))
        ],
      ),
    );
  }
}
