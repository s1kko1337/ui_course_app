import 'package:flutter/material.dart';
import 'package:flutter_course_project/colors/root_colors.dart';
import 'package:flutter_course_project/components/default_text.dart';
import 'package:flutter_course_project/db/db_provider.dart';
import 'package:flutter_course_project/models/messages_stat.dart';
import 'package:flutter_course_project/app_data_loader.dart';
import 'package:provider/provider.dart';

class MessagesList extends StatelessWidget {
  const MessagesList(String chatId, {super.key});

  @override
  Widget build(BuildContext context) {
    final appData = AppDataManager();
    final dbProvider = Provider.of<DbProvider>(context);
    RootColors colors = RootColors();

    return FutureBuilder<List<MessageStat>>(
      future: dbProvider.getMessagesStat(appData.chatId as String),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Ошибка: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: DefaultText(text: 'Нет сообщений'));
        } else {
          final messages = snapshot.data!;
          return ListView.builder(
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final message = messages[index];
              return Container(
                decoration: BoxDecoration(
                  color: colors.CardCol,
                  borderRadius: BorderRadius.circular(20),
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
                    BoxShadow(
                      color: Color.fromRGBO(192, 110, 33, 0.07),
                      blurRadius: 8,
                      spreadRadius: 0,
                      offset: Offset(0, 4),
                    ),
                    BoxShadow(
                      color: Color.fromRGBO(192, 110, 33, 0.07),
                      blurRadius: 16,
                      spreadRadius: 0,
                      offset: Offset(0, 8),
                    ),
                    BoxShadow(
                      color: Color.fromRGBO(192, 110, 33, 0.07),
                      blurRadius: 32,
                      spreadRadius: 0,
                      offset: Offset(0, 16),
                    ),
                    BoxShadow(
                      color: Color.fromRGBO(192, 110, 33, 0.07),
                      blurRadius: 64,
                      spreadRadius: 0,
                      offset: Offset(0, 32),
                    ),
                  ],
                ),
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                padding: const EdgeInsets.all(16),
                child: GestureDetector(
                  onTap: () {
                    // Обработка нажатия на сообщение
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DefaultText(text: 'ID сообщения: ${message.id}'),
                      DefaultText(text: 'ID чата: ${message.chatId}'),
                      DefaultText(text: 'ID пользователя: ${message.idUser}'),
                      const SizedBox(height: 4),
                      DefaultText(
                          text: 'Текст сообщения: ${message.messageText}'),
                      const SizedBox(height: 4),
                      DefaultText(text: 'Статус чата: ${message.chatStatus}'),
                      if (message.chatArticle != null)
                        DefaultText(
                            text: 'Статья чата: ${message.chatArticle}'),
                      DefaultText(text: 'Время создания: ${message.createdAt}'),
                      DefaultText(
                          text: 'Время обновления: ${message.updatedAt}'),
                      if (message.isAdmin != null)
                        DefaultText(
                            text: 'Админ: ${message.isAdmin! ? "Да" : "Нет"}'),
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
