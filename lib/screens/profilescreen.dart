import 'dart:io';
import 'package:chatapp/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  final String username;

  const ProfileScreen({super.key, required this.username});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  DataBaseMethods dataBaseMethods = DataBaseMethods();

  String imageUrl = '';
  File? image;
  String imagepath = '';
  Future pickImage() async {
    String name = widget.username;
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (image == null) return;
      File? imageTemp = File(image.path);
      setState(() {
        this.image = imageTemp;
      });
    } on PlatformException catch (e) {
      print('failed to pik image');
    }
    Reference ref = FirebaseStorage.instance.ref().child('profilepic$name.jpg');
    await ref.putFile(File(image!.path));
    ref.getDownloadURL().then((value) {
      setState(() {
        imageUrl = value;
        saveImage(image!.path);
      });
    });
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.username)
        .update({'profile_pic': imageUrl});
  }

  @override
  void initState() {
    loadImage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 52, 79, 236),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(shape: BoxShape.circle),
                child: imagepath == ''
                    ? CircleAvatar(
                        radius: 200,
                        child: Text('no image'),
                      )
                    : imageUrl == ''
                        ? CircleAvatar(
                            radius: 120,
                            backgroundImage: FileImage(File(imagepath)),
                          )
                        : CircleAvatar(
                            radius: 120,
                            backgroundImage: NetworkImage(imageUrl),
                          ),
              ),
              MaterialButton(
                onPressed: () {
                  pickImage();
                },
                child: Text('Update photo'),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                child: Text(
                  'Hi ${widget.username}',
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 35,
                          fontWeight: FontWeight.w500)),
                ),
              ),
              SizedBox(
                height: 80,
              ),
              MaterialButton(
                color: Colors.black54,
                onPressed: ()async {
                     GoogleSignIn _googleSignIn = GoogleSignIn();
await _googleSignIn.disconnect();
await FirebaseAuth.instance.signOut();
                  FirebaseAuth.instance.signOut();
                 final snakbar = SnackBar(
                 
                  backgroundColor: Color.fromARGB(255, 76, 35, 187),
                    content: Text('Sign out successfully! please go back to sign in',
                    ),
                  );

                  ScaffoldMessenger.of(context).showSnackBar(snakbar);
                },
                child: Text(
                  'Sign out',
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                          color: Color.fromARGB(255, 0, 255, 64),
                          fontSize: 25,
                          fontWeight: FontWeight.w500)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void saveImage(path) async {
    SharedPreferences saveImage = await SharedPreferences.getInstance();
    saveImage.setString("image_path", path);
  }

  void loadImage() async {
    SharedPreferences saveImage = await SharedPreferences.getInstance();
    setState(() {
      imagepath = saveImage.getString("image_path")!;
    });
  }
}
