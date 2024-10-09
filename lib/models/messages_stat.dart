import 'dart:convert';

class MessageStat {
  final String id;
  final Map<String, dynamic> messageBody;
  final String email;
  final DateTime createdAt;

  MessageStat({
    required this.id,
    required this.messageBody,
    required this.email,
    required this.createdAt,
  });

  // Фабричный метод для создания объекта MessageStat из Map
  factory MessageStat.fromMap(Map<String, dynamic> map) {
    return MessageStat(
      id: map['id'],
      messageBody: jsonDecode(map['message_body']),
      email: map['email'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  // Метод для преобразования объекта MessageStat в Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'message_body': jsonEncode(messageBody),
      'email': email,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
