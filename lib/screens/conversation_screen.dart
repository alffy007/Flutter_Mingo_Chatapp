import 'package:chatapp/database.dart';
import 'package:chatapp/helper/constants.dart';
import 'package:chatapp/widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ConversationScreen extends StatefulWidget {
  const ConversationScreen(
      {super.key, required this.chatRoomId, required this.userName});
  final String chatRoomId;
  final String userName;

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  DataBaseMethods dataBaseMethods = DataBaseMethods();
  TextEditingController messageController = TextEditingController();

  Stream? chatMessageStream;
  Widget chatMessageList() {
    return StreamBuilder(
        stream: chatMessageStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  reverse: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    return MessageTiles(
                      message: snapshot.data!.docs[index].get('message'),
                      sendbyme: Constants.myName ==
                          snapshot.data.docs[index].get('sender'),
                    );
                  })
              : Container();
        });
  }

  sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "message": messageController.text,
        "sender": Constants.myName,
        "time": DateTime.now().millisecondsSinceEpoch
      };
      dataBaseMethods.addConversationMessage(widget.chatRoomId, messageMap);
      setState(() {
        messageController.text = "";
      });
    }
  }

  Widget MessageBar() {
    return Container(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(top: 5, bottom: 12, left: 12, right: 12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(80),
            color: Color.fromARGB(255, 42, 47, 102),
          ),
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            children: [
              Expanded(
                  child: TextField(
                controller: messageController,
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 20,
                )),
                decoration: InputDecoration(
                    hintText: "Message...",
                    hintStyle: GoogleFonts.poppins(
                        textStyle: TextStyle(
                      color: Color.fromARGB(150, 254, 254, 254),
                      fontSize: 18,
                    )),
                    border: InputBorder.none),
              )),
              GestureDetector(
                  onTap: () {
                    sendMessage();
                  },
                  child: GlowingActionButton())
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    dataBaseMethods.getConversationMessage(widget.chatRoomId).then((value) {
      setState(() {
        chatMessageStream = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 245, 244, 246),
        appBar: AppBar(
          title: Text(
            widget.userName,
            style: GoogleFonts.poppins(
                textStyle: TextStyle(
              color: Color.fromARGB(255, 248, 248, 248),
              fontSize: 22,
              fontWeight: FontWeight.w500,
            )),
          ),
          shadowColor: Colors.purple,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
              image: AssetImage('assets/images/appbar.jpg'),
              fit: BoxFit.cover,
            )),
          ),
          toolbarHeight: 70,
        ),
        body: Column(
          children: [Expanded(child: chatMessageList()), MessageBar()],
        ));
  }
}

class MessageTiles extends StatelessWidget {
  const MessageTiles(
      {super.key, required this.message, required this.sendbyme});
  final String message;
  final bool sendbyme;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          sendbyme ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          child: Container(
              decoration: BoxDecoration(
                gradient: sendbyme ?  LinearGradient(
             colors: [Color(0xFF19B7FF), Color(0xFF491CCB)] ) :  LinearGradient( colors: [Color.fromARGB(255, 82, 83, 155), Color(0xFF3A364B)]),
                borderRadius: sendbyme
                    ? BorderRadius.only(
                        topLeft: Radius.circular(23),
                        topRight: Radius.circular(23),
                        bottomLeft: Radius.circular(23))
                    : BorderRadius.only(
                        topLeft: Radius.circular(23),
                        topRight: Radius.circular(23),
                        bottomRight: Radius.circular(23)),
              ),
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Text(
                        message,
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 18,
                        )),
                      ),
                      Text(
                        DateTime(0).hour.toString(),
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 18,
                        )),
                      ),
                    ],
                  ),
                ),
              )),
        )
      ],
    );
  }
}
