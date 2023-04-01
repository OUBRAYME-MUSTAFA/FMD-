import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login/screen/signup_screen.dart';

import '../resauble_widget/res_widget.dart';
import '../utils/color_utils.dart';
import 'home2.dart';
import 'home4.dart';
import 'pdf.dart';
import 'years.dart';
import 'home_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          hexStringToColor("004e92"),
          hexStringToColor("2A4D69"),
          hexStringToColor("4B86B4"),
          hexStringToColor("ADCBE3"),
          // hexStringToColor("E7EFF6"),
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                20, MediaQuery.of(context).size.height * 0.2, 20, 0),
            child: Column(children: <Widget>[
              logoWidget("assets/images/test1.png"),
              SizedBox(height: 10),
              reusableTextFietd("Enter User Name ", Icons.person_outline, false,
                  _emailTextController),
              SizedBox(height: 20),
              reusableTextFietd("Enter Password", Icons.lock_outline, true,
                  _passwordTextController),
              SizedBox(height: 20),
              signInSignUpButton(context, true, () {
                FirebaseAuth.instance
                    .signInWithEmailAndPassword(
                        email: _emailTextController.text,
                        password: _passwordTextController.text)
                    .then((value) {
                  print(" sign in ");
                  Navigator.push(context,
                          MaterialPageRoute(builder: (context) => YearPage()))
                      .onError((error, stackTrace) {
                    print("Error ${error.toString()}");
                  });
                });
              }),
              signUpOption()
            ]),
          ),
        ),
      ),
    );
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have account?",
            style: TextStyle(color: Colors.white70)),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SignUpScreen()));
          },
          child: const Text(
            "Sign Up",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}
