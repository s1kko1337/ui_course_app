import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_course_project/colors/root_colors.dart';
import 'package:flutter_course_project/components/gray_text.dart';
import 'package:flutter_course_project/components/orange_button_style.dart';
import 'package:flutter_course_project/db/db_provider.dart';
import 'package:provider/provider.dart';

class DeleteUserCard extends StatefulWidget {
  const DeleteUserCard({super.key});

  @override
  DeleteUserCardState createState() => DeleteUserCardState();
}

class DeleteUserCardState extends State<DeleteUserCard> {
  final _formKey = GlobalKey<FormState>();
  int? _id;


  // Функция для сохранения данных пользователя
  int? _saveForm(int id) {
    if (_formKey.currentState!.validate()) {
      _id = id;
      return _id;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    RootColors colors = RootColors();
    final dbProvider = Provider.of<DbProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            TextFormField(
              style: TextStyle(
                color: colors.TextCol,
              ),
              decoration: const InputDecoration(labelText: 'ID'),
              keyboardType: TextInputType
                  .number, // Устанавливаем тип клавиатуры на числовой
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter
                    .digitsOnly, // Ограничиваем ввод только цифрами
              ],
              onChanged: (value) {
                _id = value.isNotEmpty ? int.tryParse(value) : null;
              },
              onSaved: (value) {
                _id = int.tryParse(value!);
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter ID';
                }
                // Проверяем, является ли введенное значение целым числом
                if (int.tryParse(value) == null) {
                  return 'Please enter a valid ID';
                }
                return null;
              },
            ),
           
            const SizedBox(height: 20),
            ElevatedButton(
              style: ButtonStyles.elevatedButtonStyle(colors),
              onPressed: () async {
                if (!dbProvider.isConnected) {
                  await dbProvider.connect();
                }
                if (_id != null && dbProvider.isConnected) {
                  _formKey.currentState!.save();
                  final users = await dbProvider.getUsers();
                  final curentUser = await dbProvider.getUser(_id!);
                  if (users.isEmpty || curentUser.isEmpty) {
                    return;
                  } else if (_formKey.currentState!.validate()) {
                    final idU = _saveForm(_id!);
                    await dbProvider.deleteUser(idU!);
                    log('User w id: $_id updated');
                  }
                }
              },
              child: const GrayText(text: 'Удалить информацию о партфолио'),
            ),
          ],
        ),
      ),
    );
  }
}

// Функция для проверки правильности формата URL
