import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gls/controllers/messageController.dart';
import 'package:gls/helpers/coloors.dart';
import 'package:gls/models/user.dart';
import 'package:intl/intl.dart';

class MessageBoxScreen extends StatefulWidget {
  final User user;
  const MessageBoxScreen({super.key, required this.user});

  @override
  _MessageBoxScreenState createState() => _MessageBoxScreenState();
}

class _MessageBoxScreenState extends State<MessageBoxScreen> {
  final MessageController messageController = Get.put(MessageController());
  final TextEditingController messageInputController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  Timer? refreshTimer;
  RxBool isSending = false.obs; // État pour indiquer l'envoi en cours

  @override
  void initState() {
    super.initState();
    messageController.fetchMessages(widget.user.id!).then((_) {
      _scrollToBottom();
    });

    // 🔄 Démarrer un rafraîchissement automatique toutes les 2 secondes
    refreshTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      messageController.fetchMessages(widget.user.id!);
    });
  }

  @override
  void dispose() {
    messageInputController.dispose();
    scrollController.dispose();
    refreshTimer?.cancel(); // Arrêter le rafraîchissement automatique
    super.dispose();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (scrollController.hasClients) {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      }
    });
  }

  void sendMessage() {
    if (messageInputController.text.trim().isNotEmpty) {
      isSending.value = true; // Début de l'envoi
      String content = messageInputController.text.trim();
      messageInputController.clear();

      messageController.sendMessage(widget.user.id!, content).then((_) {
        messageController.fetchMessages(widget.user.id!).then((_) {
          _scrollToBottom();
        });
      }).whenComplete(() => isSending.value = false); // Fin de l'envoi
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
      backgroundColor: Coloors.primaryColor,
      title: Row(
        children: [
          const CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage("assets/images/user.webp"),
          ),
          const SizedBox(width: 10),
          Text(widget.user.nom!, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
      actions: [
        IconButton(icon: const Icon(Icons.call), onPressed: () {}),
      ],
    );
  }

  Widget _buildMessageList() {
    return Obx(() {
      var sortedMessages = messageController.messages.toList()
        ..sort((a, b) => a.sentAt!.compareTo(b.sentAt!));

      return ListView.builder(
        controller: scrollController,
        padding: const EdgeInsets.all(10),
        itemCount: sortedMessages.length,
        itemBuilder: (context, index) {
          final message = sortedMessages[index];

          return Align(
            alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: message.isMe ? Coloors.primaryColor : Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.content!,
                    style: TextStyle(color: message.isMe ? Colors.white : Colors.black),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    DateFormat('HH:mm').format(message.sentAt!),
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
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
              controller: messageInputController,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => sendMessage(),
              decoration: const InputDecoration(
                hintText: "Écrire un message...",
                border: InputBorder.none,
              ),
            ),
          ),
          Obx(() => isSending.value
              ? const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Coloors.primaryColor),
                  ),
                )
              : IconButton(
                  icon: const Icon(Icons.send, color: Coloors.primaryColor),
                  onPressed: sendMessage,
                )),
        ],
      ),
    );
  }
}
