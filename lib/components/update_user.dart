import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_course_project/colors/root_colors.dart';
import 'package:flutter_course_project/components/gray_text.dart';
import 'package:flutter_course_project/components/orange_button_style.dart';
import 'package:flutter_course_project/db/db_provider.dart';
import 'package:flutter_course_project/models/portfolios.dart';
import 'package:provider/provider.dart';

class UpdateUser extends StatefulWidget {
  const UpdateUser({super.key});

  @override
  UpdateUserState createState() => UpdateUserState();
}

class UpdateUserState extends State<UpdateUser> {
  final _formKey = GlobalKey<FormState>();
  int? _id;
  String? _mainInfo;
  String? _additionalInfo;
  String? _artstation;
  String? _tg;
  String? _vk;
  String? _inst;

  // Функция для сохранения данных пользователя
  Portfolios? _saveForm(int id) {
    if (_formKey.currentState!.validate()) {
      Portfolios newUser = Portfolios(
        id: id,
        mainInfo: {
          'info': _mainInfo,
        },
        additionalInfo: {
          'info': _additionalInfo,
        },
        mediaLinks: MediaLinks(
          artstation: _artstation,
          tg: _tg,
          vk: _vk,
          inst: _inst,
        ),
      );
      return newUser;
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
            TextFormField(
              style: TextStyle(
                color: colors.TextCol,
              ),
              decoration: const InputDecoration(labelText: 'Main Info'),
              onSaved: (value) {
                _mainInfo = value;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter main info';
                }
                return null;
              },
            ),
            TextFormField(
              style: TextStyle(
                color: colors.TextCol,
              ),
              decoration: const InputDecoration(labelText: 'Additional Info'),
              onSaved: (value) {
                _additionalInfo = value;
              },
            ),
            TextFormField(
              style: TextStyle(
                color: colors.TextCol,
              ),
              decoration: const InputDecoration(
                  labelText: 'Artstation Link',
                  prefixText: 'https://artstation.com/'),
              onChanged: (value) {
                _artstation =
                    value.isNotEmpty ? 'https://artstation.com/$value' : null;
              },
              onSaved: (value) {
                _artstation = 'https://artstation.com/$value';
              },
            ),
            TextFormField(
              style: TextStyle(
                color: colors.TextCol,
              ),
              decoration: const InputDecoration(
                  labelText: 'Telegram Link', prefixText: 'https://t.me/'),
              onChanged: (value) {
                _tg = value.isNotEmpty ? 'https://t.me/$value' : null;
              },
              onSaved: (value) {
                _tg = 'https://t.me/$value';
              },
            ),
            TextFormField(
              style: TextStyle(
                color: colors.TextCol,
              ),
              decoration: const InputDecoration(
                labelText: 'VK Link',
                prefixText: 'https://vk.com/',
              ),
              onChanged: (value) {
                _vk = value.isNotEmpty ? 'https://vk.com/$value' : null;
              },
              onSaved: (value) {
                _vk = 'https://vk.com/$value';
                ;
              },
            ),
            TextFormField(
              style: TextStyle(
                color: colors.TextCol,
              ),
              decoration: const InputDecoration(
                  labelText: 'Instagram Link',
                  prefixText: 'https://instagram.com/'),
              onChanged: (value) {
                _inst =
                    value.isNotEmpty ? 'https://instagram.com/$value' : null;
              },
              onSaved: (value) {
                _inst = 'https://instagram.com/$value';
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
                  final users = await dbProvider.getPortfolios();
                  final curentUser = await dbProvider.getPortfolio(_id!);
                  if (users.isEmpty || curentUser.isEmpty) {
                    return;
                  } else if (_formKey.currentState!.validate()) {
                    final newUser = _saveForm(_id!);
                    await dbProvider.updatePortfolio(newUser!);
                    log('User w id: $_id updated');
                  }
                }
              },
              child: const GrayText(text: 'Сохранить информацию о партфолио'),
            ),
          ],
        ),
      ),
    );
  }
}

// Функция для проверки правильности формата URL
