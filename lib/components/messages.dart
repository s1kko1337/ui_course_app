import 'dart:async'; // Добавлен импорт для Timer
import 'package:flutter/material.dart';
import 'package:flutter_course_project/colors/root_colors.dart';
import 'package:flutter_course_project/components/default_text.dart';
import 'package:flutter_course_project/db/db_provider.dart';
import 'package:flutter_course_project/models/messages_stat.dart';
import 'package:flutter_course_project/app_data_loader.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MessagesList extends StatefulWidget {
  const MessagesList({super.key});

  @override
  _MessagesListState createState() => _MessagesListState();
}

class _MessagesListState extends State<MessagesList> {
  final AppDataManager appData = AppDataManager();
  List<MessageStat> _messages = [];
  Timer? _timer;
  final RootColors colors = RootColors();

  @override
  void initState() {
    super.initState();
    _fetchMessages(); // Начальное получение сообщений
    _startTimer(); // Запуск таймера для периодического обновления
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      _fetchMessages();
    });
  }

  Future<void> _fetchMessages() async {
    final dbProvider = Provider.of<DbProvider>(context, listen: false);
    List<MessageStat> newMessages =
        await dbProvider.getMessagesStat(appData.chatId as String);

    newMessages = newMessages
        .where((message) =>
            message.messageText != 'nullablefirstmessageforopenchat')
        .toList()
      ..sort((a, b) => a.id.compareTo(b.id));

    if (newMessages.length != _messages.length) {
      setState(() {
        _messages = newMessages;
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel(); // Отменяем таймер при уничтожении виджета
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_messages.isEmpty) {
      return const Center(child: DefaultText(text: 'Нет сообщений'));
    } else {
      return ListView.builder(
        itemCount: _messages.length,
        itemBuilder: (context, index) {
          final message = _messages[index];
          final isAdmin = message.isAdmin ?? false;
          final alignment =
              isAdmin ? CrossAxisAlignment.start : CrossAxisAlignment.end;
          final containerAlignment =
              isAdmin ? Alignment.topLeft : Alignment.topRight;
          final borderRadius = BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft:
                isAdmin ? const Radius.circular(0) : const Radius.circular(20),
            bottomRight:
                isAdmin ? const Radius.circular(20) : const Radius.circular(0),
          );

          // Форматируем дату в часовом поясе Москвы (UTC+3)
          final DateTime createdAtInMoscow =
              message.createdAt.toUtc().add(const Duration(hours: 3));
          final String formattedDate =
              DateFormat('dd.MM.yyyy HH:mm').format(createdAtInMoscow);

          return Align(
            alignment: containerAlignment,
            child: Container(
              decoration: BoxDecoration(
                color: colors.CardCol,
                borderRadius: borderRadius,
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(192, 110, 33, 0.07),
                    blurRadius: 2,
                    spreadRadius: 0,
                    offset: Offset(0, 1),
                  ),
                  BoxShadow(
                    color: Color.fromRGBO(192, 110, 33, 0.07),
                    blurRadius: 4,
                    spreadRadius: 0,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: alignment,
                children: [
                  DefaultText(
                    text: message.messageText,
                  ),
                  const SizedBox(height: 4),
                  DefaultText(
                    text: formattedDate,
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }
}
