import 'dart:developer';
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_course_project/models/messages_stat.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ftpconnect/ftpconnect.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_course_project/db/db_provider.dart';
import 'package:flutter_course_project/db/db.dart';
//import 'package:pure_ftp/pure_ftp.dart';

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
  List<String> loadedModelsNames = [];
  List<String> loadedInfoAboutModels = [];
  List<Map<String, String>> chatList = [];

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

        if (jsonData['chatList'] != null) {
          chatList = List<Map<String, String>>.from(
            jsonData['chatList'].map((chat) => Map<String, String>.from(chat)),
          );
        } else {
          chatList = [];
        }
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
      'loadedInfoAboutModels': loadedInfoAboutModels,
      'loadedModelsNames': loadedModelsNames,
      'chatList': chatList,
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

      this.chatId = chatId;
      this.isChatCreated = true;

      if (!chatList.any((chat) => chat['chatId'] == chatId)) {
        chatList.add({'chatId': chatId, 'chatName': this.chatName!});
      }

      await writeData();
    } catch (e) {
      log('Ошибка в createChat: $e');
    }
  }

  Future<void> getModels() async {
    try {
      var dbProvider = DbProvider();
      if (!dbProvider.isConnected) {
        await dbProvider.connect();
      }
      var allWorks = await dbProvider.getWorks();
      log(allWorks.toString());
      log('Получено ${allWorks.length} моделей из базы данных.');

      for (var work in allWorks) {
        log('Модель ID: ${work.id}, Путь к модели: ${work.pathToModel}');
      }

      if (allWorks.isEmpty) {
        log('Нет моделей для загрузки.');
        return;
      }

      final directory = await getApplicationDocumentsDirectory();
      String localPath = directory.path;
      List<String> downloadedModels = [];
      List<String> loadedInfo = [];
      List<String> loadedModelsNamesT = [];

      for (var work in allWorks) {
        String fileName = work.pathToModel.split('/').last;
        String modelName = fileName;
        String modelNameJpg = fileName.split('.').first;
        String previewName = '${modelNameJpg}_preview.jpg';

        Uint8List fileBytes;
        Uint8List previewBytes;
        try {
          fileBytes = base64Decode(work.binaryFile);
          previewBytes = base64Decode(work.binaryPreview);
        } catch (e) {
          log('Ошибка декодирования base64 для модели ${work.id}: $e');
          continue;
        }
        String modelFilePath = '$localPath/$modelName';
        File modelFile = File(modelFilePath);
        await modelFile.writeAsBytes(fileBytes);
        log('Файл модели $modelName успешно сохранен.');

        String previewFilePath = '$localPath/$previewName';
        File previewFile = File(previewFilePath);
        await previewFile.writeAsBytes(previewBytes);
        log('Файл превью $previewName успешно сохранен.');
        loadedInfo.add(work.additionalInfo);
        downloadedModels.add(modelFilePath);
        loadedModelsNamesT.add(work.modelName);
      }
      loadedModels = downloadedModels;
      loadedInfoAboutModels = loadedInfo;
      loadedModelsNames = loadedModelsNamesT;
      await writeData();
      log('Список загруженных моделей обновлен и сохранен.');
    } catch (e) {
      log('Ошибка в getModels: $e');
    }
  }

  void resetChats() {
    chatId = null;
    chatName = null;
    isChatCreated = false;
    chatList = [];
    writeData();
  }

  Future<void> resetModels() async {
    for (String fileName in loadedModels) {
      String filePath = fileName;
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

    loadedModels = [];
    loadedInfoAboutModels = [];
    loadedModelsNames = [];
    await writeData();
    log('Список загруженных моделей очищен и данные сохранены.');
  }

  void saveChatData(String chatId, String chatName, param2) {
    writeData();
  }
}
