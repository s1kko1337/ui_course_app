import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_course_project/db/db_provider.dart';

class AppDataManager {
  static final AppDataManager _instance = AppDataManager._internal();
  factory AppDataManager() {
    return _instance;
  }

  AppDataManager._internal();

  bool isChatCreated = false;
  String? chatId;
  String? chatName;
  List<String> loadedModels = [];

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/appData.json');
  }

  Future<void> readData() async {
    try {
      final file = await _localFile;

      if (await file.exists()) {
        String contents = await file.readAsString();
        Map<String, dynamic> jsonData = jsonDecode(contents);

        isChatCreated = jsonData['isChatCreated'] ?? false;
        chatId = jsonData['chatId'] as String?;
      } else {
        await writeData();
      }
    } catch (e) {
      print('Ошибка при чтении данных: $e');
    }
  }

  Future<void> writeData() async {
    final file = await _localFile;

    Map<String, dynamic> jsonData = {
      'isChatCreated': isChatCreated,
      'chatId': chatId,
      'chatName': chatName,
    };

    String jsonString = jsonEncode(jsonData);
    await file.writeAsString(jsonString, flush: true);
  }

// В AppDataManager
  void createChat(String chatId, String chatName) {
    this.chatId = chatId;
    this.chatName = chatName;
    this.isChatCreated = true;
    saveChatData(chatId, chatName, null);
  }

  void resetChat() {
    chatId = null;
    chatName = null;
    isChatCreated = false;
  }

  void saveChatData(String chatId, String chatName, param2) {
    writeData();
  }
}
