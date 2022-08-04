import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insta/Screens/home/SearchScreen.dart';
import 'package:insta/Screens/home/accueil.dart';
import 'package:insta/Screens/home/add_post.dart';
import 'package:insta/Screens/home/profileScreen.dart';
import 'package:insta/providers/user_provider.dart';
import 'package:insta/utilities/consts.dart';
import "package:provider/provider.dart";
import 'package:insta/models/componants/User.dart' as model;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    addData();
  }

  void addData() async {
    print("here");
    var x = Provider.of<UserProvider>(context, listen: false);
    print(x);
    await x.Refresh_User();
  }
  // void getUsername() async {
  //   // so now as we can see here  i starting getting  insecure  of my self since i  didnt full understand one concept earlier when i  was in lafa9
  //   // first to get a certain data from our firestore (we create a firestore instance that will  take care of the func of our database )

  //   var x = await FirebaseFirestore.instance
  //       // FROM THE COLLECTION USERS
  //       .collection('users')
  //       // the one that has a name of  our current user associated with this app
  //       .doc(FirebaseAuth.instance.currentUser!.uid)
  //       // to get it into a map foramt
  //       .get();
  //   // data to get into a json format
  //   setState(() {
  //     username = x.data()?["username"];
  //   });

  //   print("3");
  // }
  var provided;
  int current_page = 0;
  PageController lmodir = PageController();
  dynamic Waiting1() {
    provided = Provider.of<UserProvider>(context).GetUser;
    if (provided == null) {
      return NetworkImage(
          "https://images.unsplash.com/photo-1533035353720-f1c6a75cd8ab?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80");
    } else {
      return NetworkImage(provided.photoUrl);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    lmodir.dispose();
  }

  @override
  Widget build(BuildContext context) {
    provided = Provider.of<UserProvider>(context).GetUser;
    return provided ==null ?
      CircularProgressIndicator():

    Scaffold(
      body: PageView(controller: lmodir, children: [
        Feed(),
        SearchScreen(),
        AddPost(),
        Center(child: Text("page4")),
        ProfileScreen(provided.uid),
      ]),
      bottomNavigationBar: CupertinoTabBar(
          currentIndex: current_page,
          onTap: (index) {
            setState(() {
              current_page = index;
              lmodir.jumpToPage(index);
            });
          },
          backgroundColor: Colors.black,
          activeColor: Colors.white,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              backgroundColor: kPrimaryColor,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              backgroundColor: kPrimaryColor,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle),
              backgroundColor: kPrimaryColor,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag_outlined),
              backgroundColor: kPrimaryColor,
            ),
            BottomNavigationBarItem(
              icon: CircleAvatar(radius: 17, backgroundImage: Waiting1()),
              backgroundColor: kPrimaryColor,
            ),
          ]),
    );
  }
}
