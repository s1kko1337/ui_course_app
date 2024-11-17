import 'dart:developer';
import 'dart:io';
import 'dart:convert';
import 'package:flutter_course_project/models/messages_stat.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ftpconnect/ftpconnect.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_course_project/db/db_provider.dart';
import 'package:flutter_course_project/db/db.dart';

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
        chatName = jsonData['chatName'] as String?;
        loadedModels = List<String>.from(jsonData['loadedModels'] ?? []);
      } else {
        await writeData();
      }
    } catch (e) {
      log('Ошибка при чтении данных: $e');
    }
  }

  Future<void> writeData() async {
    final file = await _localFile;

    Map<String, dynamic> jsonData = {
      'isChatCreated': isChatCreated,
      'chatId': chatId,
      'chatName': chatName,
      'loadedModels': loadedModels,
    };

    String jsonString = jsonEncode(jsonData);
    await file.writeAsString(jsonString, flush: true);
  }

  MessageStat? firstWhereOrNull(
      Iterable<MessageStat> iterable, bool Function(MessageStat) test) {
    for (var element in iterable) {
      if (test(element)) return element;
    }
    return null;
  }

  Future<void> createChat(String chatId, String chatName) async {
    try {
      final allMessages = await DbProvider().getGlobalMessagesStat();

      int? chatIdInt = int.tryParse(chatId);

      if (chatIdInt == null) {
        log('Ошибка: chatId "$chatId" не является корректным числом.');
        return;
      }

      MessageStat? messageWithChatId = firstWhereOrNull(
        allMessages,
        (message) => message.chatId == chatIdInt,
      );

      if (messageWithChatId != null && messageWithChatId.chatArticle != null) {
        this.chatName = messageWithChatId.chatArticle!;
      } else {
        this.chatName = chatName;
      }

      // Устанавливаем значения свойств
      this.chatId = chatId;
      this.isChatCreated = true;

      saveChatData(this.chatId!, this.chatName!, null);
    } catch (e) {
      print('Ошибка в createChat: $e');
    }
  }

  Future<void> getModels() async {
    final FTPConnect _ftpConnect = FTPConnect(
      dotenv.env['FTP_HOST']!,
      user: dotenv.env['FTP_USERNAME']!,
      pass: dotenv.env['FTP_PASSWORD']!,
      securityType: SecurityType.FTPES,

      showLog: true,
    );

    try {
      var dbProvider = DbProvider();
      if (!dbProvider.isConnected) {
        await dbProvider.connect(); // Добавили await здесь
      }
      var allWorks = await dbProvider.getWorks();
      log(allWorks.toString());
      log('Получено ${allWorks.length} моделей из базы данных.');

      for (var work in allWorks) {
        log('Модель ID: ${work.id}, Путь к модели: ${work.pathToModel}');
      }

      // Проверяем, есть ли модели для загрузки
      if (allWorks.isEmpty) {
        log('Нет моделей для загрузки.');
        return;
      }

      // После успешного получения данных из базы начинаем загрузку с FTP
      final directory = await getApplicationDocumentsDirectory();
      String localPath = directory.path;
      List<String> downloadedModels = [];

      // Подключаемся к FTP-серверу
      await _ftpConnect.connect();
      log('Подключение к FTP-серверу установлено.');

      for (var work in allWorks) {
        String modelPath = '/home/ftpuser/ftp/${work.pathToModel}';
        String fileName = modelPath.split('/').last;
        File localFile = File('$localPath/$fileName');

        // Проверяем, была ли модель уже загружена
        if (!localFile.existsSync()) {
          bool result;
          try {
            // Загружаем файл с FTP
            result = await _ftpConnect.downloadFile(modelPath, localFile);
          } catch (e) {
            log('Ошибка при загрузке файла $modelPath: $e');
            continue;
          }

          if (result) {
            log('Файл $fileName успешно загружен.');
            downloadedModels.add(fileName);
          } else {
            log('Ошибка при загрузке файла $fileName.');
          }
        } else {
          log('Файл $fileName уже существует локально.');
          downloadedModels.add(fileName);
        }
      }

      // Отключаемся от FTP-сервера
      await _ftpConnect.disconnect();
      log('Отключение от FTP-сервера.');

      loadedModels = downloadedModels;
      await writeData();
      log('Список загруженных моделей обновлен и сохранен.');
    } catch (e) {
      log('Ошибка в getModels: $e');
    }
  }

  void resetChat() {
    chatId = null;
    chatName = null;
    isChatCreated = false;
    writeData();
  }

  Future<void> resetModels() async {
    // Получаем путь к локальной директории
    final directory = await getApplicationDocumentsDirectory();
    String localPath = directory.path;

    // Удаляем файлы моделей из локальной директории
    for (String fileName in loadedModels) {
      String filePath = '$localPath/$fileName';
      final file = File(filePath);

      if (await file.exists()) {
        try {
          await file.delete();
          log('Файл $fileName удален.');
        } catch (e) {
          log('Ошибка при удалении файла $fileName: $e');
        }
      } else {
        log('Файл $fileName не найден.');
      }
    }

    // Очищаем список загруженных моделей и сохраняем данные
    loadedModels = [];
    await writeData();
    log('Список загруженных моделей очищен и данные сохранены.');
  }

  void saveChatData(String chatId, String chatName, param2) {
    writeData();
  }
}
