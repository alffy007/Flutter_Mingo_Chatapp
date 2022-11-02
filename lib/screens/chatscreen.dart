import 'package:chatapp/database.dart';
import 'package:chatapp/helper/constants.dart';
import 'package:chatapp/helper/helper_functions.dart';
import 'package:chatapp/screens/conversation_screen.dart';
import 'package:chatapp/screens/profilescreen.dart';
import 'package:chatapp/screens/searchscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  DataBaseMethods dataBaseMethods = DataBaseMethods();

  Stream? chatRoomsStream;

  Widget chatRoomList() {
    return StreamBuilder(
        stream: chatRoomsStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ChatRoomsTile(
                        userName: snapshot.data!.docs[index]
                            .get('chatroomId')
                            .toString()
                            .replaceAll("_", "")
                            .replaceAll(Constants.myName, ""),
                        chatRoomId: snapshot.data!.docs[index]
                            .get('chatroomId')
                            .toString());
                  })
              : Container();
        });
  }

  @override
  void initState() {
    getUserInfoChats();
    super.initState();
  }

  getUserInfoChats() async {
    Constants.myName = (await HelperFunctions.getUserNameSharedPreference())!;
    dataBaseMethods.getChatRoom(Constants.myName).then((val) {
      setState(() {
        chatRoomsStream = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        actions: [
          GestureDetector(
            onTap: () async {
              FirebaseAuth.instance.signOut();
             await GoogleSignIn().signOut();
            },
            child: Container(
              alignment: Alignment.topRight,
              child: Icon(
                Icons.logout_rounded,
                size: 30,
              ),
            ),
          ),
        ],
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
            image: AssetImage('assets/images/appbar.jpg'),
            fit: BoxFit.cover,
          )),
        ),
        title: Text(
          'Messages',
          style: GoogleFonts.poppins(
              textStyle: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 40,
                  fontWeight: FontWeight.w700)),
        ),
        toolbarHeight: 140,
      ),
      body: Container(
        child: chatRoomList(),
      ),
      bottomNavigationBar: Container(
        color: Color.fromARGB(255, 21, 226, 144),
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 40,
              width: 140,
              child: Padding(
                padding: const EdgeInsets.only(left: 1, top: 3),
                child: Text(
                  'messages',
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 22,
                          fontWeight: FontWeight.w500)),
                ),
              ),
            ),
            FloatingActionButton(
              onPressed: (() {
                  Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SearchScreen()));
              }),
              child: const Icon(Icons.search),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ProfileScreen(username: Constants.myName)));
              },
              child: Container(
                width: 140,
                height: 40,
                child: Center(
                    child: Text(
                  'profile',
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 22,
                          fontWeight: FontWeight.w500)),
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatRoomsTile extends StatefulWidget {
  final String userName;

  final String chatRoomId;
  ChatRoomsTile({
    required this.userName,
    required this.chatRoomId,
  });

  @override
  State<ChatRoomsTile> createState() => _ChatRoomsTileState();
}

class _ChatRoomsTileState extends State<ChatRoomsTile> {
  late String profile;
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ConversationScreen(
                    chatRoomId: widget.chatRoomId,
                    userName: widget.userName,
                  )));
      },
      splashColor: Colors.blue[200],
      child: Container(
        height: 90,
        color: Colors.transparent,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        child: Row(
          children: [
            FutureBuilder(
                future: fetch(widget.userName),
                builder: ((context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 21, 226, 144),
                          borderRadius: BorderRadius.circular(30)),
                      child: Text(
                        widget.userName.substring(0, 1).toUpperCase(),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                          color: Color.fromARGB(255, 248, 248, 248),
                          fontSize: 33,
                          fontWeight: FontWeight.w500,
                        )),
                      ),
                    );
                  } else if (profile != '') {
                    return Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 21, 226, 144),
                          borderRadius: BorderRadius.circular(30)),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(profile),
                      ),
                    );
                  } else {
                    return Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 21, 226, 144),
                          borderRadius: BorderRadius.circular(30)),
                      child: Text(
                        widget.userName.substring(0, 1).toUpperCase(),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                          color: Color.fromARGB(255, 248, 248, 248),
                          fontSize: 33,
                          fontWeight: FontWeight.w500,
                        )),
                      ),
                    );
                  }
                })),
            SizedBox(
              width: 12,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 0),
              child: Text(
                widget.userName,
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                  letterSpacing: 1,
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                )),
              ),
            )
          ],
        ),
      ),
    );
  }

  fetch(String userName) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userName)
        .get()
        .then((DocumentSnapshot val) {
      profile = val.get('profile_pic').toString();
    }).catchError((e) {
      print(e);
    });
  }
}
