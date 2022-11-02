import 'package:chatapp/database.dart';
import 'package:chatapp/helper/google_signin.dart';
import 'package:chatapp/helper/helper_functions.dart';
import 'package:chatapp/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../main.dart';

class SignIn extends StatefulWidget {
  final VoidCallback onClickedSignUp;
  const SignIn({super.key, required this.onClickedSignUp});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  DataBaseMethods dataBaseMethods = DataBaseMethods();
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.deepPurple[700],
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height - 50,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircleAvatar(
                          backgroundImage: AssetImage('assets/images/logo.png'),
                          radius: 80,
                        ),
                        TextFormField(
                          cursorColor: Colors.amber,
                          controller: emailController,
                          decoration: textFieldInputDecoration("email"),
                          style: simpleTextStyle(),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (email) =>
                              email != null && !EmailValidator.validate(email)
                                  ? 'Enter a Valid email'
                                  : null,
                        ),
                        TextFormField(
                           obscureText: true,
                          cursorColor: Colors.amber,
                          controller: passwordController,
                          decoration: textFieldInputDecoration("password"),
                          style: simpleTextStyle(),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) =>
                              value != null && value.length < 6
                                  ? 'Enter Min 6+ characters'
                                  : null,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Container(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              'Forgot Password',
                              style: simpleTextStyle(),
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        GestureDetector(
                          onTap: () {
                            signInEmailPassword();
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(vertical: 20),
                            decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xff007EF4),
                                    Color.fromARGB(255, 159, 21, 186)
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(30)),
                            child: Text(
                              'Sign In',
                              style: simpleTextStyle(),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        GestureDetector(
                          onTap: () {
                            signInWithGoogle(context);
                        
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(vertical: 20),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30)),
                            child: const Text(
                              'Sign in with google',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Dont have an account? ',
                              style:
                                  TextStyle(fontSize: 15, color: Colors.white),
                            ),
                            RichText(
                                text: TextSpan(
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = widget.onClickedSignUp,
                                    text: 'Signup',
                                    style: TextStyle(
                                        fontSize: 15,
                                        decoration: TextDecoration.underline)))
                          ],
                        ),
                        SizedBox(
                          height: 150,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future signInEmailPassword() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    QuerySnapshot snapshotUserInfo;
    dataBaseMethods.getUserByUserEmail(emailController.text).then((val) {
      snapshotUserInfo = val;
      HelperFunctions.saveUserNameSharedPref(
          snapshotUserInfo.docs[0].get('name'));
    });

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator()));
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
    } on FirebaseAuthException catch (e) {
      print(e);
    }

    HelperFunctions.saveUserLoggedInSharedPref(true);
    navigatorkey.currentState!.popUntil((route) => route.isFirst);
  }
}
