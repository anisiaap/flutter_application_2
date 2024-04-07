import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_2/ui/uihelper.dart';
import 'package:flutter_application_2/ui/homepage/home_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController emailControler = TextEditingController();
  TextEditingController passwordControler = TextEditingController();

  signUp(String email, String password) async {
    if (email == "" && password == "") {
      return UiHelper.CustomAlertBox(context, "Enter Required Fields");
    } else {
      UserCredential? userCredential;
      try {
        userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomePage()));
        });
      } on FirebaseAuthException catch (ex) {
        return UiHelper.CustomAlertBox(context, ex.code.toString());
      }
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up on CityScene"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          UiHelper.CustomTextField(emailControler, "Email", Icons.mail, false),
          UiHelper.CustomTextField(
              passwordControler, "Password", Icons.password, true),
          SizedBox(height: 30),
          UiHelper.CustomButton(() {
            signUp(emailControler.text.toString(),
                passwordControler.text.toString());
          }, "SignUp"),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
