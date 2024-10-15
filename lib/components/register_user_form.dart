

import 'package:flutter/material.dart';
import 'package:flutter_course_project/colors/root_colors.dart';
import 'package:flutter_course_project/components/gray_text.dart';
import 'package:flutter_course_project/components/orange_button_style.dart';
import 'package:flutter_course_project/db/db_provider.dart';
import 'package:flutter_course_project/models/portfolios.dart';
import 'package:provider/provider.dart';

class RegisterUserForm extends StatefulWidget {
  const RegisterUserForm({super.key});

  @override
  RegisterUserFormState createState() => RegisterUserFormState();
}

class RegisterUserFormState extends State<RegisterUserForm> {
  final _formKey = GlobalKey<FormState>();
  String? _mainInfo;
  String? _additionalInfo;
  String? _artstation;
  String? _tg;
  String? _vk;
  String? _inst;

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
              decoration: const InputDecoration(labelText: 'Additional Info'),
              onSaved: (value) {
                _additionalInfo = value;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                  labelText: 'Artstation Link',
                  prefixText: 'https://artstation.com/'),
              onSaved: (value) {
                _artstation = 'https://artstation.com/$value';
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                  labelText: 'Telegram Link', prefixText: 'https://t.me/'),
              onSaved: (value) {
                _tg = 'https://t.me/$value';
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'VK Link',
                prefixText: 'https://vk.com/',
              ),
              onSaved: (value) {
                _vk = 'https://vk.com/$value';
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                  labelText: 'Instagram Link',
                  prefixText: 'https://instagram.com/'),
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
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  final users = await dbProvider.getPortfolios();
                  late var id;
                  if (users.isEmpty) {
                    id = 1;
                  } else {
                    id = users.last.id + 1;
                  }
                  final newUser = _saveForm(id);
                  if (dbProvider.isConnected) {
                    await dbProvider.addPortfolio(newUser!);
                  }
                }
              },
              child:
                  const GrayText(text: 'Сохранить информацию для нового партфолио'),
            ),
          ],
        ),
      ),
    );
  }
}
