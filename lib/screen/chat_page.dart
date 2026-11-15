
import 'package:chat_app/constant.dart';
import 'package:chat_app/models/message.dart';
import 'package:chat_app/widgets/chat_buble.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatPage extends StatefulWidget {
  static String id = 'ChatPage';

  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ScrollController _scrollController = ScrollController();

  final TextEditingController _textController =
      TextEditingController();

  final CollectionReference messages = FirebaseFirestore.instance
      .collection(kMessagesCollections);

  String? email;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    email = ModalRoute.of(context)!.settings.arguments as String;
  }

  Future<void> sendMessage(String data) async {
    if (data.trim().isEmpty) return;

    try {
      await messages.add({
        kMessage: data.trim(),
        kCreatedAt: FieldValue.serverTimestamp(),
        'id': email,
      });

      _textController.clear();

      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
      }
    } catch (e) {
      debugPrint('Error sending message: $e');
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: messages
          .orderBy(kCreatedAt, descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        List<Message> messagesList = [];

        if (snapshot.hasData) {
          for (var doc in snapshot.data!.docs) {
            messagesList.add(Message.fromJson(doc));
          }
        }

        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: kPrimaryColor,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  kLogo,
                  height: 50,
                ),
                const Text('chat'),
              ],
            ),
            centerTitle: true,
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  reverse: true,
                  controller: _scrollController,
                  itemCount: messagesList.length,
                  itemBuilder: (context, index) {
                    return messagesList[index].id == email
                        ? ChatBuble(
                            message: messagesList[index],
                          )
                        : ChatBubleForFriend(
                            message: messagesList[index],
                          );
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _textController,
                  onSubmitted: sendMessage,
                  decoration: InputDecoration(
                    hintText: 'Send Message',
                    suffixIcon: IconButton(
                      onPressed: () {
                        sendMessage(_textController.text);
                      },
                      icon: Icon(
                        Icons.send,
                        color: kPrimaryColor,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: kPrimaryColor,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
