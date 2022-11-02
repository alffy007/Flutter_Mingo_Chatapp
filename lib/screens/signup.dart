import 'package:chatapp/database.dart';
import 'package:chatapp/helper/google_signin.dart';
import 'package:chatapp/helper/helper_functions.dart';
import 'package:chatapp/widget.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';


class SignUp extends StatefulWidget {
  final VoidCallback onClickedLogin;

  const SignUp({super.key, required this.onClickedLogin});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  DataBaseMethods dataBaseMethods = DataBaseMethods();

  final formKey = GlobalKey<FormState>();
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.deepPurple[700],
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height - 50,
            padding: EdgeInsets.symmetric(horizontal: 24),
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            cursorColor: Colors.amber,
                            validator: (value) {
                              return value!.isEmpty || value.length < 3
                                  ? "please provide valid username"
                                  : null;
                            },
                            controller: userNameController,
                            decoration: textFieldInputDecoration("Username"),
                            style: simpleTextStyle(),
                          ),
                          TextFormField(
                            cursorColor: Colors.amber,
                            controller: emailController,
                            decoration: textFieldInputDecoration("email"),
                            style: simpleTextStyle(),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (email) =>
                                email != null && !EmailValidator.validate(email)
                                    ? 'Enter a Valid email'
                                    : null,
                          ),
                          TextFormField(
                            cursorColor: Colors.amber,
                            obscureText: true,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) =>
                                value != null && value.length < 6
                                    ? 'Enter Min 6+ characters'
                                    : null,
                            controller: passwordController,
                            decoration: textFieldInputDecoration("password"),
                            style: simpleTextStyle(),
                          ),
                          const SizedBox(
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
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: () {
                              signUpEmailPassword();
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
                                'Sign Up',
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
                                'Sign Up with google',
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
                                  'Already have an account ? ',
                                  style: simpleTextStyle(),
                                ),
                                RichText(
                                    text: TextSpan(
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = widget.onClickedLogin,
                                        text: 'Log in',
                                        style: TextStyle(
                                            fontSize: 15,
                                            decoration:
                                                TextDecoration.underline))),
                              ]),
                          SizedBox(
                            height: 120,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future signUpEmailPassword() async {
    Map<String, String> userInfoMap = {
      "name": userNameController.text,
      "email": emailController.text,
      "profile_pic": ''
    };
    HelperFunctions.saveUserEmailSharedPref(emailController.text);
    HelperFunctions.saveUserNameSharedPref(userNameController.text);
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator()));

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
    } on FirebaseAuthException catch (e) {
      print(e);
    }
    dataBaseMethods.uploadUserInfo(userInfoMap, userNameController.text);
    HelperFunctions.saveUserLoggedInSharedPref(true);
    // ignore: use_build_context_synchronously
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}
