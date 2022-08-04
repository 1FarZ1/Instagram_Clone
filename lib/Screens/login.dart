import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:insta/Screens/home/home_screen.dart';
import 'package:insta/Screens/register.dart';
import 'package:insta/services/auth_manager.dart';
import 'package:insta/utilities/consts.dart';
import '../models/componants/classes.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // creating a controller for email and password
  TextEditingController _econtroller = TextEditingController();
  TextEditingController _pcontroller = TextEditingController();
  bool _isLoading = false;
  var error = "";
  @override
  void dispose() {
    // TODO: implement dispose

    // we need to clear our controllers after we destroy this widget
    _econtroller.dispose();
    _pcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(30, 80, 30, 50),
        child: Column(
          children: [
            SvgPicture.asset("assets/ic_instagram.svg",
                height: 64, color: kPrimaryColor),
            const SizedBox(
              height: 104,
            ),
            CustomTextField("Email", false, _econtroller),
            CustomTextField("Password", true, _pcontroller),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyWidget(),
                SizedBox(
                  width: 30,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, "/reset");
                  },
                  child: Text("Forget Password",
                      style: TextStyle(
                          color: Colors.white,
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w700)),
                ),
              ],
            ),
            Button("Login", () async {
              setState(() {
                _isLoading = true;
              });

              await Future.delayed(Duration(seconds: 1));
              var result = await AuthManager.SignInWithEmailandPassword(
                  _econtroller.text, _pcontroller.text);
              setState(() {
                _isLoading = false;
              });

              setState(() {
                error = result;
              });
              if (!result.contains("Success")) {
                showSnackBar(context, result);
              } else {
                await Future.delayed(Duration(seconds: 2));
                Navigator.push(context, MaterialPageRoute(builder: (e) {
                  return Home();
                }));
              }
            }),
            Visibility(visible: _isLoading, child: CircularProgressIndicator()),
            Text(
              error,
              style: TextStyle(
                  color: error.contains("Success")
                      ? Color.fromARGB(255, 4, 243, 12)
                      : Color.fromARGB(255, 239, 12, 12),
                  fontSize: 16),
            ),
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an Account ? ",
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xffffffff),
                  ),
                ),
                //will change this to text button
                GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                        return Register();
                      }));
                    },
                    child: Text(
                      "Sign up",
                      style: TextStyle(color: Colors.blue, fontSize: 15),
                    ))
              ],
            )
          ],
        ),
      )),
    );
  }
}
