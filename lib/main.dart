import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:insta/Screens/home/home_screen.dart';
import 'package:insta/Screens/login.dart';
import 'package:insta/providers/user_provider.dart';
import 'package:insta/utilities/consts.dart';
import 'package:provider/provider.dart';
import 'package:flutter/widgets.dart';

// created by farz
// i  didnt optimize it yet for ios (i dont have mac ) and web
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    // TODO  dont forget to add  posts to the user profile ez af using frid and the snap i got from post 
    // i got this error and tried to solved it for 5 hours , so after a  lot of googling and trying i found out that the problem is that i need to  make  provider in seperate widget so he can rebuild , fuck me
    const App(),
  );
}

class App extends StatelessWidget {
  const App({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserProvider>(
      create: (ctx) => UserProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.dark,
        darkTheme: ThemeData.dark()
            .copyWith(scaffoldBackgroundColor: kMobilebackgroundColor),
        // initialRoute:"/",
        // routes: {
        //   "/":(context)=>const Login(),
        //   "/Register":(context) => const Register(),
        // },

        // here we used  a stream builder bcz we going to use a stream that is provided by firebase that we will detect if any changes in user authentication  if so we will display , so if the auth state has data we will make him go home  otherwise he needs to login or register (if snapshot is empty );
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
                    
            if (snapshot.connectionState == ConnectionState.active) {
         
              if (snapshot.hasData) {
                return Home();
              } else if (snapshot.hasError) {
          
                return Center(child: Text(snapshot.error.toString()));
              }
              
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
                    
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return Login();
          },
        ),
      ),
    );
  }
}
