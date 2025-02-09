import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gls/helpers/coloors.dart';

class MessageBoxScreen extends StatefulWidget {
  const MessageBoxScreen({super.key});

  @override
  _MessageBoxScreenState createState() => _MessageBoxScreenState();
}

class _MessageBoxScreenState extends State<MessageBoxScreen> {
  final TextEditingController messageController = TextEditingController();
  final List<Map<String, dynamic>> messages = [
    {"text": "Salut !", "isMe": false, "time": "14:30"},
    {"text": "Comment vas-tu ?", "isMe": false, "time": "14:31"},
    {"text": "Ça va bien, merci !", "isMe": true, "time": "14:32"},
    {"text": "Quoi de neuf ?", "isMe": true, "time": "14:33"},
  ];

  void sendMessage() {
    if (messageController.text.trim().isNotEmpty) {
      setState(() {
        messages.add({
          "text": messageController.text.trim(),
          "isMe": true,
          "time": TimeOfDay.now().format(context),
        });
        messageController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(child: _buildMessageList()),
          _buildMessageInput(),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Row(
        children: [
          const CircleAvatar(
            backgroundImage: AssetImage("assets/images/user.webp"),
          ),
          const SizedBox(width: 10),
          const Text("Karen Den", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
      actions: [
        IconButton(icon: const Icon(Icons.call), onPressed: () {}),
        IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
      ],
    );
  }

  Widget _buildMessageList() {
    return ListView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: messages.length,
      reverse: true, // Pour afficher le dernier message en bas
      itemBuilder: (context, index) {
        final message = messages.reversed.toList()[index];
        return Align(
          alignment: message["isMe"] ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: message["isMe"] ? Coloors.primaryColor : Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(message["text"], style: TextStyle(color: message["isMe"] ? Colors.white : Colors.black)),
                const SizedBox(height: 5),
                Text(message["time"], style: TextStyle(fontSize: 12, color: Colors.black54)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        children: [
          IconButton(icon: const Icon(Icons.emoji_emotions_outlined), onPressed: () {}),
          Expanded(
            child: TextField(
              controller: messageController,
              decoration: const InputDecoration(
                hintText: "Écrire un message...",
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(icon: const Icon(Icons.send, color: Coloors.primaryColor), onPressed: sendMessage),
        ],
      ),
    );
  }
}
