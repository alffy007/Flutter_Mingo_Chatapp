import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseMethods {
  getUserByUserName(String username) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("name", isEqualTo: username)
        .get();
  }

  getUserByUserEmail(String username) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: username)
        .get();
  }

  getUserData() async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where('profile_pic')
        .get();
  }

  uploadUserInfo(userMap, String username) {
    FirebaseFirestore.instance.collection("users").doc(username).set(userMap);
  }

  updateUserInfo(String userName) {
    FirebaseFirestore.instance.collection("users").doc(userName);
  }

  createChatRoom(String chatRoomId, chatRoomMap) {
    FirebaseFirestore.instance
        .collection("chatroom")
        .doc(chatRoomId)
        .set(chatRoomMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  addConversationMessage(String chatRoomId, messageMap) {
    FirebaseFirestore.instance
        .collection('chatroom')
        .doc(chatRoomId)
        .collection('Chats')
        .add(messageMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  getConversationMessage(String chatRoomId) async {
    return  FirebaseFirestore.instance
        .collection('chatroom')
        .doc(chatRoomId)
        .collection('Chats')
        .orderBy("time", descending: true)
        .snapshots();
  }

  getChatRoom(String userName) async {
    return  FirebaseFirestore.instance
        .collection('chatroom')
        .where('users', arrayContains: userName)
        .snapshots();
  }
}
