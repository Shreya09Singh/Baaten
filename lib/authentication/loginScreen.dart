import 'dart:developer';
import 'dart:io';

import 'package:baatain/Screens/homeScreen.dart';
import 'package:baatain/services/apis.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  handleGooglebuttonClick() {
    //for showing progress bar
    // Dialogs.showProgressIndicator(context);
    _signInWithGoogle().then((user) async {
      //for hiding the progress bar
      if (user != null) {
        log('\nUser:${user.user}');
        log('\nUserAdditional Info:${user.additionalUserInfo}');

        if ((await APIs.userExits())) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomeScreen()));
        } else {
          await APIs.createUser().then((value) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => HomeScreen()));
          });
        }
      }
    });
  }

  Future<UserCredential?> _signInWithGoogle() async {
    try {
      await InternetAddress.lookup('google.com');

      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      log('\n_signInWithGoogle :$e');
      // Dialogs.showSnakebar(context, 'went wrong something!');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
              child: TextButton(
                  onPressed: () {}, child: Text("Sign in with Google"))),
          SizedBox(
            height: 10,
          ),
          ElevatedButton(
              onPressed: () {
                handleGooglebuttonClick();
              },
              child: Text("Signin"))
        ],
      ),
    );
  }
}
