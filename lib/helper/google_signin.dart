import 'package:chatapp/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'helper_functions.dart';

// GOOGLE SIGN IN
Future<void> signInWithGoogle(BuildContext context) async {
  try {
    final  googleUser = await GoogleSignIn().signIn();

    final  googleAuth =
        await googleUser?.authentication;

    if (googleAuth?.accessToken != null && googleAuth?.idToken != null) {
      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // if you want to do specific task like storing information in firestore
      // only for new users using google sign in (since there are no two options
      // for google sign in and google sign up, only one as of now),
      // do the following:

      if (userCredential.user != null) {
        if (userCredential.additionalUserInfo!.isNewUser) {
           Map<String, String> userInfoMap = {
      "name":userCredential.user!.displayName.toString(),
      "email":  userCredential.user!.email.toString(),
      "profile_pic": '',
      'created_at': DateTime.now().toString()
    };
  DataBaseMethods dataBaseMethods = DataBaseMethods();

     dataBaseMethods.uploadUserInfo(userInfoMap,userCredential.user!.displayName.toString());
          HelperFunctions.saveUserLoggedInSharedPref(true);
          HelperFunctions.saveUserEmailSharedPref(
              userCredential.user!.email.toString());
          HelperFunctions.saveUserNameSharedPref(
              userCredential.user!.displayName.toString());
        } else {
          HelperFunctions.saveUserLoggedInSharedPref(true);
          HelperFunctions.saveUserEmailSharedPref(
              userCredential.user!.email.toString());
          HelperFunctions.saveUserNameSharedPref(
              userCredential.user!.displayName.toString());
        }
      }
    }
  } on FirebaseAuthException catch (e) {
    print(e.message); // Displaying the error message
  }
}
