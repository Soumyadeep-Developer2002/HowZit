import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:how_zit/fire_models_database/chat_consumers_model.dart';
import 'package:how_zit/fire_models_database/chat_messages_model.dart';

// ignore: camel_case_types
class hereAllAPI {
  static FirebaseAuth auth =
      FirebaseAuth.instance; // For authentication create a instance...

  static FirebaseMessaging pushMessaging =
      FirebaseMessaging
          .instance; // For Access Messaging in FireBase, create a instance...

  static FirebaseFirestore database =
      FirebaseFirestore.instance; // For access Database in Firebase...

  static late Consumers me;

  // This func is used to get another registered users on Chat Screen...
  static Stream<QuerySnapshot<Map<String, dynamic>>> getOthersUSer() {
    return database
        .collection("Consumers")
        .where("ID", isNotEqualTo: auth.currentUser!.uid)
        .snapshots();
  }

  // This func is used to get user's own details...
  static Future<void> ownDetails() async {
    await database
        .collection('Consumers')
        .doc(auth.currentUser!.uid)
        .get()
        .then((User) async {
          if (User.exists) {
            me = Consumers.fromJson(User.data()!);
            await getMSGToken();
          } else {
            ifUserDontExist().then((Value) => ownDetails());
          }
        });
  }

  //If user exist then get all details...
  static Future<bool> ifUserExist() async {
    return (await database
            .collection('Consumers')
            .doc(auth.currentUser!.uid)
            .get())
        .exists;
  }

  // If user does not exist then create...
  static Future<void> ifUserDontExist() async {
    final onTime = DateTime.now().microsecondsSinceEpoch.toString();

    final userAdd = Consumers(
      isOnline: false,
      LastActive: onTime,
      CreatedOn: onTime,
      Email: auth.currentUser!.email.toString(),
      ID: auth.currentUser!.uid,
      Image: auth.currentUser!.photoURL.toString(),
      About: "Using HowZit to keep in touch🫱🏻‍🫲🏼",
      Name: auth.currentUser!.displayName.toString(),
      PushNotification: '',
    );

    return await database
        .collection('Consumers')
        .doc(auth.currentUser!.uid)
        .set(userAdd.toJson());
  }

  // It is used for update user's name and about on profile screen and it is also save in database...
  static Future<void> updateUserDetails() async {
    await database.collection('Consumers').doc(auth.currentUser!.uid).update({
      'Name': me.Name,
      'About': me.About,
    });
  }

  // This is very important to saving all chats and a comparison is being made here so that whoever starts chatting will be saved in one place...
  static String generateConversationID(String id) =>
      auth.currentUser!.uid.hashCode <= id.hashCode
          ? '${auth.currentUser!.uid}_$id'
          : '${id}_${auth.currentUser!.uid}';

  // For geting Masseges...
  static Stream<QuerySnapshot<Map<String, dynamic>>> getMessages(
    Consumers otherUser,
  ) {
    return database
        .collection("Chats/${generateConversationID(otherUser.ID)}/Messages/")
        .snapshots();
  }

  // For sending Messages...
  static Future<void> sendMessages(Consumers otherUser, String msg) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final Messages message = Messages(
      Read: '',
      Type: Types.Text,
      Message: msg,
      SenderID: auth.currentUser!.uid,
      ReciverID: otherUser.ID,
      Sent: time,
    );

    final reference = database.collection(
      "Chats/${generateConversationID(otherUser.ID)}/Messages/",
    );
    await reference.doc(time).set(message.toJson());
  }

  // When other user read the message and the time save in the database so that the blue tick features can be performed
  static Future<void> readStatus(Messages msg) async {
    database
        .collection("Chats/${generateConversationID(msg.SenderID)}/Messages/")
        .doc(msg.Sent)
        .update({'Read': DateTime.now().millisecondsSinceEpoch.toString()});
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> viewLastMessage(
    Consumers otherUser,
  ) {
    return database
        .collection("Chats/${generateConversationID(otherUser.ID)}/Messages/")
        .limit(1)
        .snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> otherUserActiveInfo(
    Consumers otherUser,
  ) {
    return database
        .collection('Consumers')
        .where('ID', isEqualTo: otherUser.ID)
        .snapshots();
  }

  static Future<void> getInfo(bool is_Online) async {
    database.collection('Consumers').doc(auth.currentUser!.uid).update({
      'is_Online': is_Online,
      'Last_active': DateTime.now().millisecondsSinceEpoch.toString(),
      'Push_Notification': me.PushNotification,
    });
  }

  static Future<void> getMSGToken() async {
    await pushMessaging.requestPermission();
    await pushMessaging.getToken().then((t) async {
      if (t != null) {
        me.PushNotification = t;
        print('Push Notification : :  $t');
        await getInfo(true);
      }
    });
  }
}
