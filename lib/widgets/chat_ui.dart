
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatUi extends StatefulWidget {
  const ChatUi({
    super.key,
    required this.email,
  });

  final String email;

  @override
  State<ChatUi> createState() => _ChatUiState();
}

class _ChatUiState extends State<ChatUi> {
  final _chatController = InMemoryChatController();

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>?
      _messagesSubscription;

  late final String currentUserId;

  @override
  void initState() {
    super.initState();

    currentUserId = widget.email.trim().toLowerCase();

    _listenToMessages();
  }

  // Listen to Firestore messages
  void _listenToMessages() {
    _messagesSubscription = FirebaseFirestore.instance
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .limit(50)
        .snapshots()
        .listen(
      (snapshot) {
        if (!mounted) return;

        debugPrint(
          'Messages received: ${snapshot.docs.length}',
        );

        final messages = snapshot.docs.map((doc) {
          final data = doc.data();

          final timestamp = data['createdAt'] as Timestamp?;

          return TextMessage(
            id: doc.id,
            authorId: data['authorId'] ?? '',
            createdAt: (timestamp?.toDate() ?? DateTime.now())
                .toUtc(),
            text: data['message'] ?? '',
          );
        }).toList();

        // Display messages from oldest to newest
        _chatController.setMessages(
          messages.reversed.toList(),
        );
      },
      onError: (error) {
        debugPrint('Firestore Stream Error: $error');
      },
    );
  }

  @override
  void dispose() {
    _messagesSubscription?.cancel();
    _chatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Chat(
      chatController: _chatController,
      currentUserId: currentUserId,

      theme: ChatTheme(
        colors: ChatColors(
          primary: Colors.blueAccent,
          surfaceContainer: const Color(0xffE5E5EA),
          onPrimary: Colors.white,
          onSurface: Colors.black87,
          surface: Colors.white,
          surfaceContainerLow: const Color(0xffE5E5EA),
          surfaceContainerHigh: const Color(0xffE5E5EA),
        ),

        typography: ChatTypography(
          bodyLarge: const TextStyle(fontSize: 16),
          bodyMedium: const TextStyle(fontSize: 14),
          bodySmall: const TextStyle(fontSize: 12),
          labelLarge: const TextStyle(fontSize: 14),
          labelMedium: const TextStyle(fontSize: 12),
          labelSmall: const TextStyle(fontSize: 10),
        ),

        shape: BorderRadiusGeometry.all(
          const Radius.circular(20),
        ),
      ),

      // Send message
      onMessageSend: (text) async {
        try {
          await FirebaseFirestore.instance
              .collection('messages')
              .add({
            'message': text,
            'authorId': currentUserId,
            'createdAt': FieldValue.serverTimestamp(),
          });
        } catch (e) {
          debugPrint('Send Message Error: $e');
        }
      },

      // Resolve user
      resolveUser: (UserID id) async {
        return User(
          id: id,
          name: id == currentUserId ? 'Me' : id,
        );
      },
    );
  }
}
