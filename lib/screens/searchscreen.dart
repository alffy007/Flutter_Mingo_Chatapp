import 'package:chatapp/database.dart';
import 'package:chatapp/helper/constants.dart';
import 'package:chatapp/screens/conversation_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController nameController = TextEditingController();
  DataBaseMethods dataBaseMethods = DataBaseMethods();

  List searchResult = [];

  void getUserByUserName(String username) async {
    final result = await FirebaseFirestore.instance
        .collection("users")
        .where("name", isEqualTo: username)
        .get();

    setState(() {
      searchResult = result.docs.map((e) => e.data()).toList();
    });
  }

  final userRef = FirebaseFirestore.instance.collection('chatroom');
  bool flag = false;
  createChatRoom(String userName) {
    String chatRoomId = getChatRoomId(Constants.myName, userName);

    if (Constants.myName == userName) {
    } else if (flag) {
      userRef.where('users', arrayContains: userName).get().then(
          (QuerySnapshot snapshot) =>
              snapshot.docs.forEach((DocumentSnapshot doc) {
                if (chatRoomId == doc.id) {
                  setState(() {
                    flag = true;
                  });
                }
              }));
    } else if (flag) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ConversationScreen(
                    chatRoomId: chatRoomId,
                    userName: userName,
                  )));
    } else {
      String chatRoomId = getChatRoomId(userName, Constants.myName);
      List<String> users = [Constants.myName, userName];
      Map<String, dynamic> chatRoomMap = {
        "users": users,
        "chatroomId": chatRoomId,
      };
      dataBaseMethods.createChatRoom(chatRoomId, chatRoomMap);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ConversationScreen(
                    chatRoomId: chatRoomId,
                    userName: userName,
                  )));
    }
  }

  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(94, 113, 255, 1),
      appBar: AppBar(
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
          'Search',
          style: GoogleFonts.poppins(
              textStyle: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 40,
                  fontWeight: FontWeight.w700)),
        ),
        toolbarHeight: 120,
      ),
      body: Column(
        children: [
          Container(
            height: 50,
            color: Color.fromRGBO(91, 61, 253, 1),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 9),
              child: TextField(
                controller: nameController,
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 20,
                )),
                cursorColor: Colors.amber,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  fillColor: Color.fromRGBO(94, 113, 255, 1),
                  hintText: 'search full name...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(9)),
                  ),
                  enabledBorder: const OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromRGBO(94, 113, 255, 1))),
                  focusedBorder: const OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromRGBO(94, 113, 255, 1))),
                  filled: true,
                ),
                onChanged: (username) {
                  getUserByUserName(username);
                },
              ),
            ),
          ),
          Expanded(
              child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('users').snapshots(),
            builder: (context, snapshot) {
              return (snapshot.connectionState == ConnectionState.waiting)
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        var data = snapshot.data!.docs[index].data()
                            as Map<String, dynamic>;
                        if (nameController.text.isEmpty) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 6),
                            child: Container(
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(colors: [
                                      Color.fromRGBO(150, 0, 255, 1),
                                      Color.fromRGBO(174, 186, 248, 1),
                                    ]),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(24))),
                                height: 80,
                                child: Row(
                                  children: [
                                    Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 20, left: 35),
                                          child: Text(
                                            data['name'],
                                            style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 255, 255, 255),
                                                    fontSize: 22,
                                                    fontWeight:
                                                        FontWeight.w700)),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Spacer(),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          createChatRoom(data['name']);
                                        },
                                        child: Text('message'),
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                              Color.fromRGBO(91, 61, 253, 1),
                                            ),
                                            shape: MaterialStateProperty.all<
                                                    RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ))),
                                      ),
                                    )
                                  ],
                                )),
                          );
                        }
                        if (data['name']
                            .toString()
                            .toLowerCase()
                            .startsWith(nameController.text.toLowerCase())) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 6),
                            child: Container(
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(colors: [
                                      Color.fromRGBO(150, 0, 255, 1),
                                      Color.fromRGBO(174, 186, 248, 1),
                                    ]),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(24))),
                                height: 80,
                                child: Row(
                                  children: [
                                    Column(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10),
                                          child: Text(
                                            data['name'],
                                            style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 255, 255, 255),
                                                    fontSize: 22,
                                                    fontWeight:
                                                        FontWeight.w700)),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Spacer(),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          createChatRoom(data['name']);
                                        },
                                        child: Text('message'),
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                              Color.fromRGBO(91, 61, 253, 1),
                                            ),
                                            shape: MaterialStateProperty.all<
                                                    RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ))),
                                      ),
                                    )
                                  ],
                                )),
                          );
                        }
                        return Container();
                      });
            },
          ))
        ],
      ),
    );
  }
}
