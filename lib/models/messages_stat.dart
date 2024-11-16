import 'dart:convert';
class MessageStat {
  final int id;
  final DateTime createdAt;
  final int idUser;
  final DateTime updatedAt;
  final int chatId;
  final String chatStatus;
  final String messageText;
  final String? chatArticle; // может быть null
  final bool? isAdmin; // может быть null

  MessageStat({
    required this.id,
    required this.createdAt,
    required this.idUser,
    required this.updatedAt,
    required this.chatId,
    required this.chatStatus,
    required this.messageText,
    this.chatArticle,
    this.isAdmin,
  });

  // Метод для создания объекта из Map (например, из JSON)
  factory MessageStat.fromMap(Map<String, dynamic> map) {
    return MessageStat(
      id: map['id'],
      createdAt: DateTime.parse(map['created_at']),
      idUser: map['id_user'],
      updatedAt: DateTime.parse(map['updated_at']),
      chatId: map['chat_id'],
      chatStatus: map['chat_status'],
      messageText: map['message_text'],
      chatArticle: map['chat_article'],
      isAdmin: map['is_admin'],
    );
  }

  // Метод для преобразования объекта в Map (например, для сохранения в БД)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'created_at': createdAt.toIso8601String(),
      'id_user': idUser,
      'updated_at': updatedAt.toIso8601String(),
      'chat_id': chatId,
      'chat_status': chatStatus,
      'message_text': messageText,
      'chat_article': chatArticle,
      'is_admin': isAdmin,
    };
  }
}
