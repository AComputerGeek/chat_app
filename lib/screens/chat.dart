// @author: Amir Armion
// @version: V.01

import 'package:chat_app/widgets/chat_messages.dart';
import 'package:chat_app/widgets/new_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // Setting up the push notifications
  void setupPushNotifications() async {
    final fcm = FirebaseMessaging.instance;

    // First, we should call requestPermission() method to ask user for
    // permission to receive and handle push notification
    await fcm.requestPermission();

    // We can send notification to multiple devices which are subscribed in this topic
    fcm.subscribeToTopic('chat');

    // This token is the address of the device which is running.
    // We can send this token (via HTTP or Firestore SDK) to a backend.
    final fcmToken = await fcm.getToken();
  }

  // This method will only run once when this widget is first loaded.
  @override
  void initState() {
    super.initState();

    setupPushNotifications();
  }

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        backgroundColor: const Color.fromRGBO(168, 255, 255, 1),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut(); // Sign out the user
            },
            icon: const Icon(Icons.exit_to_app),
            color: Theme.of(context).colorScheme.primary,
          )
        ],
      ),
      body: const Column(
        children: [
          Expanded(
            child: ChatMessages(),
          ),
          NewMessage(),
        ],
      ),
    );
  }
}
