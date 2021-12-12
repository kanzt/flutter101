import 'dart:async';

import 'package:chattalk_explicit_animations/constants.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

// final _firestore = FirebaseFirestore.instance;
// final _auth = FirebaseAuth.instance;
// late User? loggedInUser = _auth.currentUser;

// Mock
class Message {
  late final String text;
  late final String sender;
  late final DateTime createdAt;

  Message(this.text, this.sender, this.createdAt);
}

class User {
  late final String email;

  User(this.email);
}

late User? loggedInUser;

class ChatScreen extends StatefulWidget {
  static const String id = 'chat';

  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  late String messageText;

  BehaviorSubject<List<Message>> messages$ = BehaviorSubject();

  Stream<List<Message>> get _messages => messages$.stream;

  @override
  void initState() {
    super.initState();
    messages$.add([Message("Hello", "FT", DateTime.now())]);
    getCurrentUser();
  }

  @override
  void dispose() {
    messages$.close();
    super.dispose();
  }

  void getCurrentUser() async {
    try {
      // final user = await _auth.currentUser;
      // Mock user
      final user = User("Paper");

      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                // _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: const Text('Chatalk'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessagesStream(messages$: _messages),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      messageTextController.clear();
                      // _firestore.collection(kCollectionName).add({
                      //   kTextName: messageText,
                      //   kSenderName: loggedInUser!.email,
                      //   kTimestamp: Timestamp.now(),
                      // });

                      messages$.add([
                        ...messages$.value,
                        Message(messageText, loggedInUser!.email, DateTime.now())
                      ]);
                    },
                    child: const Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {
  const MessagesStream({Key? key, required this.messages$}) : super(key: key);

  final Stream<List<Message>> messages$;

  @override
  Widget build(BuildContext context) {
    return

        //   StreamBuilder<QuerySnapshot>(
        //   stream: _firestore
        //       .collection(kCollectionName)
        //       .orderBy(kTimestamp, descending: false)
        //       .snapshots(),
        //   builder: (context, snapshot) {
        //     if (snapshot.hasData) {
        //       final messages = (snapshot.data as QuerySnapshot).docs.reversed;
        //       List<MessageBubble> messageBubbles = [];
        //       for (var message in messages) {
        //         final messageText = message[kTextName];
        //         final messageSender = message[kSenderName];
        //         final messageTimestamp = message[kTimestamp];
        //         final currentUser = loggedInUser!.email;
        //         final messageBubble = MessageBubble(
        //             text: messageText,
        //             sender: messageSender,
        //             timestamp: messageTimestamp,
        //             isMe: currentUser == messageSender);
        //         messageBubbles.add(messageBubble);
        //       }
        //       return Expanded(
        //           child: ListView(
        //               reverse: true,
        //               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        //               children: messageBubbles));
        //     } else {
        //       return const Center(
        //         child: CircularProgressIndicator(),
        //       );
        //     }
        //   },
        // );

        // Mock data
        StreamBuilder<List<Message>>(
      stream: messages$,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final messages = snapshot.data as List<Message>;
          List<MessageBubble> messageBubbles = [];
          for (var message in messages) {
            final messageText = message.text;
            final messageSender = message.sender;
            final messageDateTime = message.createdAt;
            final currentUser = loggedInUser!.email;
            final messageBubble = MessageBubble(
                text: messageText,
                sender: messageSender,
                dateTime: messageDateTime,
                isMe: currentUser == messageSender);
            messageBubbles.add(messageBubble);
          }
          return Expanded(
              child: ListView(
                  reverse: false,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  children: messageBubbles));
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class MessageBubble extends StatefulWidget {
  MessageBubble(
      {Key? key,
      required this.text,
      required this.sender,
      required this.dateTime,
      required this.isMe})
      : super(key: key);

  late String text;
  late String sender;

  late DateTime dateTime;
  final bool isMe;

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            widget.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            widget.sender,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black54,
            ),
          ),
          Material(
            elevation: 5.0,
            borderRadius: widget.isMe
                ? const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    topRight: Radius.circular(30))
                : const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomRight: Radius.circular(30)),
            color: widget.isMe ? Colors.lightBlueAccent : Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                widget.text,
                style: TextStyle(
                    fontSize: 15,
                    color: widget.isMe ? Colors.white : Colors.black54),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            child: Text(
              '${widget.dateTime.hour}:${widget.dateTime.minute}',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
