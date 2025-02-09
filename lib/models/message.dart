import 'dart:convert';

class Message {
  final int id;
  final int conversationId;
  final int senderId;
  final String? content;
  final String? file;
  final DateTime? sentAt;
  final DateTime? deletedAt;

  Message({
    required this.id,
    required this.conversationId,
    required this.senderId,
    this.content,
    this.file,
    this.sentAt,
    this.deletedAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      conversationId: json['conversation_id'],
      senderId: json['sender_id'],
      content: json['content'],
      file: json['file'],
      sentAt: json['sent_at'] != null ? DateTime.parse(json['sent_at']) : null,
      deletedAt: json['deleted_at'] != null ? DateTime.parse(json['deleted_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'conversation_id': conversationId,
      'sender_id': senderId,
      'content': content,
      'file': file,
      'sent_at': sentAt?.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }

  static List<Message> fromJsonList(String str) {
    return List<Message>.from(json.decode(str).map((x) => Message.fromJson(x)));
  }
}