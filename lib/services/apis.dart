import 'dart:developer';
import 'dart:io';

import 'package:baatain/model/messagemodel.dart';
import 'package:baatain/model/usermodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class APIs {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static FirebaseStorage storage = FirebaseStorage.instance;
  static User get user => auth.currentUser!;
  static late UserModel me = UserModel();
  //if user is exits or not
  static Future<bool> userExits() async {
    return (await firestore.collection('users').doc(user.uid).get()).exists;
  }

//for update the value
  static Future<void> userUpdatevalue() async {
    await firestore
        .collection('users')
        .doc(user.uid)
        .update({'name': me.name, 'about': me.about});
  }

// update profile picture for user
  static Future<void> uploadProfileImage(File file) async {
    final ext = file.path.split('.').last;
    log('Extenstion: $ext');

    //storage file ref with path
    final ref = storage.ref().child('profilepicture/${user.uid}.$ext');
    //uploading image
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((val) {
      log('Data Transferred: ${val.bytesTransferred / 1000}kb');
    });
    //updating image in firestore database
    me.image = await ref.getDownloadURL();
    await firestore
        .collection('users')
        .doc(user.uid)
        .update({'image': me.image});
  }

//for save the self info about user
  static Future<void> selfInfo() async {
    return await firestore
        .collection('users')
        .doc(user.uid)
        .get()
        .then((user) async {
      if (user.exists) {
        me = UserModel.fromJson(user.data()!);
      } else {
        await createUser().then((value) => selfInfo());
      }
    });
  }

  // create new users
  static Future<void> createUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final newUser = UserModel(
        id: user.uid,
        name: user.displayName,
        email: user.email,
        image: user.photoURL,
        about: "shreya ji here",
        lastActivity: time,
        isOnline: false,
        createdAt: time,
        pushTocken: '');
    return await firestore
        .collection('users')
        .doc(user.uid)
        .set(newUser.toJson());
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUser() {
    return firestore
        .collection('users')
        .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }

  ///************************chat  related methods ************************///

  ///chats(collection)--> conversation_id(document)---> messages(collection) --> message(doc)

  ///useful for getting conversation id
  static String getConversationID(String id) => user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : '${id}_${user.uid}';

  // add chat to the database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      UserModel getuser) {
    return firestore
        .collection(
            'chats/${getConversationID(getuser.id.toString())}/messages/')
        .snapshots();
  }

  ///getting last msg of specific chat^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  static Stream<QuerySnapshot<Map<String, dynamic>>> getlastMessages(
      UserModel user) {
    return firestore
        .collection('chats/${getConversationID(user.id.toString())}/messages/')
        .orderBy('send', descending: true)
        .limit(1)
        .snapshots();
  }

  //for sending messages
  static Future<void> sendMessages(
      UserModel chatuser, String msg, Type type) async {
    ////msg sending time also used as id
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    // msg to send
    final MessageModel message = MessageModel(
        fromId: user.uid.toString(),
        read: '',
        toId: chatuser.id.toString(),
        message: msg,
        type: type,
        send: time);
    final ref = firestore.collection(
        'chats/${getConversationID(chatuser.id.toString())}/messages/');
    await ref.doc(time).set(message.toJson());
  }

  static Future<void> sendChatImage(UserModel chatuser, File file) async {
    //getting image file extension
    final ext = file.path.split('.').last;

    //storage file ref with path
    final ref = storage.ref().child(
        'images/${getConversationID(chatuser.id.toString())}/${DateTime.now().millisecondsSinceEpoch}.$ext');
    //uploading image
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((value) {
      log('Data Transferred: ${value.bytesTransferred / 1000} kb');
    });

    //updating image in firestore databasr
    final imageUrl = await ref.getDownloadURL();
    await sendMessages(chatuser, imageUrl, Type.image);
  }
}
