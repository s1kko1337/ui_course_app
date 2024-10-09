import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_course_project/components/default_text.dart';
import 'package:flutter_course_project/components/gray_text.dart';
import 'package:flutter_course_project/components/orange_button_style.dart';
import 'package:provider/provider.dart';
import 'package:flutter_course_project/db/db_provider.dart';
import 'package:flutter_course_project/models/users.dart';
import 'package:flutter_course_project/components/custom_card.dart';
import 'package:flutter_course_project/colors/root_colors.dart';

class DbTestScreen extends StatelessWidget {
  const DbTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = RootColors();
    final dbProvider = Provider.of<DbProvider>(context);

    return Center(
      child: CustomCard(
        height: 650,
        width: 450,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DefaultText(text: dbProvider.statusMessage),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ButtonStyles.elevatedButtonStyle(colors),
              onPressed: () async {
                await dbProvider.connect();
              },
              child: const GrayText(text: 'Подключиться к базе'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ButtonStyles.elevatedButtonStyle(colors),
              onPressed: () async {
                await dbProvider.testQuery();
              },
              child: const GrayText(text: 'Тестовый запрос к базе'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ButtonStyles.elevatedButtonStyle(colors),
              onPressed: dbProvider.isConnected
                  ? () async {
                      // Получаем пользователей
                      final users = await dbProvider.getUsers();

                      // Выводим информацию о каждом пользователе в лог
                      for (var user in users) {
                        log('User ID: ${user.id}, Main: ${user.mainInfo['info']}, Additional info: ${user.additionalInfo['info']}');
                        log('Media Links: Artstation: ${user.mediaLinks.artstation}, TG: ${user.mediaLinks.tg}, VK: ${user.mediaLinks.vk}, Instagram: ${user.mediaLinks.inst}');
                      }
                    }
                  : null,
              child: const GrayText(text: 'Получить список портфолио'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ButtonStyles.elevatedButtonStyle(colors),
              onPressed: dbProvider.isConnected
                  ? () async {
                      final users = await dbProvider.getUsers();
                      late var idT;
                      if (users.isEmpty) {
                        idT = 1;
                      } else {
                        idT = users.last.id + 1;
                      }
                      User newUser = User(
                        id: idT,
                        mainInfo: {
                          'info':
                              'Я — 3D художник с опытом работы в создании реалистичных моделей и анимаций, специализирующийся на разработке визуальных эффектов для игр и фильмов.'
                        },
                        additionalInfo: {
                          'info':
                              'Мое портфолио включает в себя разнообразные проекты, от концептуального дизайна до финальной визуализации, демонстрируя мою способность превращать идеи в захватывающие 3D-изображения.'
                        },
                        mediaLinks: MediaLinks(
                          artstation: 'https://artstation.com/johndoe',
                          tg: 'https://t.me/johndoe',
                          vk: 'https://vk.com/johndoe',
                          inst: 'https://instagram.com/johndoe',
                        ),
                      );
                      await dbProvider.addUser(newUser);
                    }
                  : null,
              child: const GrayText(text: 'Добавить портфолио'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ButtonStyles.elevatedButtonStyle(colors),
              onPressed: dbProvider.isConnected
                  ? () async {
                      User updatedUser = User(
                        id: 1,
                        mainInfo: {
                          'info':
                              'Я — 3D художник с опытом работы в создании реалистичных моделей и анимаций, специализирующийся на разработке визуальных эффектов для игр и фильмов.'
                        },
                        additionalInfo: {
                          'info':
                              'Мое портфолио включает в себя разнообразные проекты, от концептуального дизайна до финальной визуализации, демонстрируя мою способность превращать идеи в захватывающие 3D-изображения.'
                        },
                        mediaLinks: MediaLinks(
                          artstation: 'https://artstation.com/johndoe1',
                          tg: 'https://t.me/johndoe1',
                          vk: 'https://vk.com/johndoe1',
                          inst: 'https://instagram.com/johndoe1',
                        ),
                      );
                      await dbProvider.updateUser(updatedUser);
                    }
                  : null,
              child: const GrayText(text: 'Обновить портфолио'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ButtonStyles.elevatedButtonStyle(colors),
              onPressed: dbProvider.isConnected
                  ? () async {
                      final users = await dbProvider.getUsers();
                      if (users.isEmpty) {
                      } else {
                        final id = users.last.id;
                        await dbProvider.deleteUser(id);
                      }
                    }
                  : null,
              child: const GrayText(text: 'Удалить портфолио'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ButtonStyles.elevatedButtonStyle(colors),
              onPressed: dbProvider.isConnected
                  ? () async {
                      await dbProvider.closeConnection();
                    }
                  : null,
              child: const GrayText(text: 'Отключиться от базы'),
            ),
          ],
        ),
      ),
    );
  }
}