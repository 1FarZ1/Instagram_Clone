import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../utilities/consts.dart';

class Button extends StatelessWidget {
  final String text;
  VoidCallback fun;
  Button(this.text, this.fun);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30.0),
      child: ButtonTheme(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Color(0xff037EE3),
            fixedSize: const Size(340, 55),
            shape: const StadiumBorder(),
          ),
          child: Text(text),
          onPressed: fun,
        ),
      ),
    );
  }
}

class MyWidget extends StatefulWidget {
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  bool rememberMe = false;

  void _onRememberMeChanged(newValue) => setState(() {
        rememberMe = newValue;

        if (rememberMe) {
          print('he is');
        } else {
          print('he is not');
        }
      });

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Checkbox(
          splashRadius: 20,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          value: rememberMe,
          onChanged: _onRememberMeChanged),
      Text(
        "Remember me",
        style: TextStyle(
            color: Color(0xFFBFBFBF),
            fontWeight: FontWeight.bold,
            fontSize: 13),
      ),
    ]);
  }
}

class CustomTextField extends StatelessWidget {
  var name;
  bool hide;
  TextEditingController _controller;

  CustomTextField(this.name, this.hide, this._controller);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: _controller,
        obscureText: hide,
        decoration: InputDecoration(
            labelText: "",
            floatingLabelStyle: const TextStyle(
                fontSize: 20, color: const Color.fromARGB(255, 255, 191, 0)),
            floatingLabelAlignment: FloatingLabelAlignment.start,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            border: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(80.0),
              borderSide: const BorderSide(
                color: Color.fromARGB(255, 0, 0, 0),
                width: 1,
                style: BorderStyle.none,
              ),
            ),
            filled: true,
            hintStyle: const TextStyle(
              color: Colors.grey,
            ),
            hintText: "  Enter Your $name",
            fillColor: Color(0xff151416)),
        onFieldSubmitted: (value) {},
      ),
    );
  }
}

