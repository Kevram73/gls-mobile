import 'dart:convert';

class Message {
  final int id;
  final int receiverId; // Remplace conversationId
  final int senderId;
  final String? content;
  final String? file;
  final DateTime? sentAt;
  final DateTime? deletedAt;
  bool isMe = false; // Pour déterminer si le message est envoyé par l'utilisateur courant
  bool isRead = false; // Pour le suivi du statut de lecture

  Message({
    required this.id,
    required this.receiverId,
    required this.senderId,
    this.content,
    this.file,
    this.sentAt,
    this.deletedAt,
    this.isMe = false,
    this.isRead = false,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    DateTime? parsedSentAt;
    // Si date_sent et time_sent sont disponibles, les combiner
    if (json['date_sent'] != null && json['time_sent'] != null) {
      try {
        // On construit une chaîne ISO en insérant un 'T'
        parsedSentAt = DateTime.parse('${json['date_sent']}T${json['time_sent']}');
      } catch (e) {
        parsedSentAt = null;
      }
    } else if (json['created_at'] != null) {
      // Sinon, utiliser created_at
      parsedSentAt = DateTime.parse(json['created_at']);
    }

    return Message(
      id: json['id'],
      receiverId: json['receiver_id'],
      senderId: json['sender_id'],
      content: json['content'],
      file: json['file'],
      sentAt: parsedSentAt,
      deletedAt: json['deleted_at'] != null ? DateTime.parse(json['deleted_at']) : null,
      isRead: json['is_read'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'receiver_id': receiverId,
      'sender_id': senderId,
      'content': content,
      'file': file,
      'sent_at': sentAt?.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
      'is_read': isRead,
    };
  }

  static List<Message> fromJsonList(String str) {
    final jsonData = json.decode(str);
    return List<Message>.from(jsonData.map((x) => Message.fromJson(x)));
  }

  // Méthode pour marquer le message comme lu
  void markAsRead() {
    isRead = true;
  }
}
