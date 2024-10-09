import 'package:flutter/material.dart';
import 'package:flutter_course_project/colors/root_colors.dart';
import 'package:flutter_course_project/components/default_text.dart';
import 'package:flutter_course_project/db/db_provider.dart';
import 'package:flutter_course_project/models/users.dart';
import 'package:provider/provider.dart';

class UserList extends StatelessWidget {
  const UserList({super.key});

  @override
  Widget build(BuildContext context) {
    final dbProvider = Provider.of<DbProvider>(context);
    RootColors colors = RootColors();
    return FutureBuilder<List<User>>(
      future: dbProvider.getUsers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Ошибка: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: DefaultText(text: 'Нет пользователей'));
        } else {
          final users = snapshot.data!;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return Container(
                decoration: BoxDecoration(
                  color: colors.CardCol, // Цвет фона
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
                  onTap: () {},
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DefaultText(text: '${user.id}'),
                      DefaultText(text: user.mainInfo['info']),
                      const SizedBox(height: 4),
                      DefaultText(
                        text:
                            '${user.additionalInfo['info']}, ${user.mediaLinks.artstation}',
                      ),
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
