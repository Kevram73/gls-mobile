import 'dart:convert';

class MessageStatus {
  final int id;
  final int messageId;
  final int recipientId;
  final bool isRead;
  final DateTime? readAt;
  final DateTime? deletedAt;

  MessageStatus({
    required this.id,
    required this.messageId,
    required this.recipientId,
    required this.isRead,
    this.readAt,
    this.deletedAt,
  });

  factory MessageStatus.fromJson(Map<String, dynamic> json) {
    return MessageStatus(
      id: json['id'],
      messageId: json['message_id'],
      recipientId: json['recipient_id'],
      isRead: json['is_read'] ?? false,
      readAt: json['read_at'] != null ? DateTime.parse(json['read_at']) : null,
      deletedAt: json['deleted_at'] != null ? DateTime.parse(json['deleted_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message_id': messageId,
      'recipient_id': recipientId,
      'is_read': isRead,
      'read_at': readAt?.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }

  static List<MessageStatus> fromJsonList(String str) {
    return List<MessageStatus>.from(json.decode(str).map((x) => MessageStatus.fromJson(x)));
  }
}