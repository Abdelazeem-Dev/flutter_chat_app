import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatUi extends StatefulWidget {
  const ChatUi({super.key, required this.email});
  final String email;

  @override
  State<ChatUi> createState() => _ChatUiState();
}

class _ChatUiState extends State<ChatUi> {
  final _chatController = InMemoryChatController();
  StreamSubscription? _messagesSubscription;

  // هنا بنخلي الـ currentUserId يقرأ الإيميل اللي مبعوث للشاشة
  late final String currentUserId;

  @override
  void initState() {
    super.initState();
    currentUserId = widget.email.trim().toLowerCase(); // تنظيف المسافات وتوحيد الحروف
    _listenToMessages();
  }

  void _listenToMessages() {
    _messagesSubscription = FirebaseFirestore.instance
        .collection('messages')
        .orderBy('createdAt', descending: false)
        .snapshots()
        .listen((snapshot) {
      final messages = snapshot.docs.map((doc) {
        final data = doc.data();

        final Timestamp? timestamp = data['createdAt'] as Timestamp?;
        final dateTime = timestamp?.toDate() ?? DateTime.now();

        return TextMessage(
          id: doc.id,
          // هنا بنجيب إيميل اللي بعت الرسالة
          authorId: data['authorId'] ?? '',
          createdAt: dateTime.toUtc(),
          text: data['message'] ?? '',
        );
      }).toList();

      _chatController.setMessages(messages);
    });
  }

  @override
  void dispose() {
    _messagesSubscription?.cancel();
    _chatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Chat(
        chatController: _chatController,
        currentUserId: currentUserId,


        theme: ChatTheme(
          colors:  ChatColors(
            primary: Colors.blueAccent,       // لون رسائلك أنت
            surfaceContainer: const Color(0xffE5E5EA), // لون رسائل الطرف التاني
            onPrimary: Colors.white,           // لون نص رسائلك
            onSurface: Colors.black87, surface: Colors.white,
            surfaceContainerLow:  const Color(0xffE5E5EA),
            surfaceContainerHigh: Color(0xffE5E5EA),         // لون نص رسائل الطرف التاني
          ), typography: ChatTypography(bodyLarge: const TextStyle(fontSize: 16) , bodyMedium:  const TextStyle(fontSize: 14), bodySmall: const TextStyle(fontSize: 12), labelLarge: const TextStyle(fontSize: 14), labelMedium:  const TextStyle(fontSize: 12), labelSmall: const TextStyle(fontSize: 10) ), shape:BorderRadiusGeometry.all(Radius.circular(20)),
        ),

        onMessageSend: (text) async {
          await FirebaseFirestore.instance.collection('messages').add({
            'message': text,
            'authorId': currentUserId, // بيبعت إيميلك أنت للفايربيز
            'createdAt': FieldValue.serverTimestamp(),
          });
        },
        resolveUser: (UserID id) async {
          return User(id: id, name: id == currentUserId ? 'Me' : id);
        },
      ),
    );
  }
}