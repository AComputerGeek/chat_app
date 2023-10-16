import 'package:chat_app/widgets/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});

  @override
  Widget build(context) {
    final authenticatedUser = FirebaseAuth.instance.currentUser!;

    // With StreamBuilder we want to listen to stream of messages;
    // so, whenever a new message is submitted, StreamBuilder automatically
    // loaded and displayed here the new message.
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy(
            'createdAt',
            descending: true, // Latest message displays at the bottom
          )
          .snapshots(),
      builder: (ctx, chatSnapshots) {
        // Showing spinner for waiting (loading) time
        if (chatSnapshots.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // If user doesn't have any chat messages
        if (!chatSnapshots.hasData || chatSnapshots.data!.docs.isEmpty) {
          return const Center(
            child: Text(
              'No Message Found!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Color.fromARGB(255, 96, 96, 96),
              ),
            ),
          );
        }

        // Checking the error
        if (chatSnapshots.hasError) {
          return const Center(
            child: Text(
              'Something Went Wrong!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          );
        }

        // All Loaded Chats = chatSnapshots.data!.docs

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
          reverse:
              true, // Revers all list items (messages), and push them in the bottom of the page
          itemCount: chatSnapshots.data!.docs.length,
          itemBuilder: (ctx, index) {
            final currentMessageUserId =
                chatSnapshots.data!.docs[index].data()['userId'];

            final nextChatMessage =
                (index + 1) < chatSnapshots.data!.docs.length
                    ? chatSnapshots.data!.docs[index + 1].data()
                    : null;
            final nextMessageUserId =
                nextChatMessage != null ? nextChatMessage['userId'] : null;

            final nextUserIsSame = (currentMessageUserId == nextMessageUserId);

            if (nextUserIsSame) {
              return MessageBubble.next(
                chatSnapshots.data!.docs[index].data()['text'],
                authenticatedUser.uid == currentMessageUserId,
              );
            } else {
              return MessageBubble.first(
                chatSnapshots.data!.docs[index].data()['userImage'],
                chatSnapshots.data!.docs[index].data()['username'],
                chatSnapshots.data!.docs[index].data()['text'],
                authenticatedUser.uid == currentMessageUserId,
              );
            }
          },
        );
      },
    );
  }
}
