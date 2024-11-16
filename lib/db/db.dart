import 'dart:ffi';

import 'package:postgres/postgres.dart';
import 'package:flutter_course_project/models/messages_stat.dart';
import 'package:flutter_course_project/models/portfolios.dart';
import 'package:flutter_course_project/models/works.dart';
import 'dart:developer';
import 'dart:convert';
import 'dart:core';
// import 'dart:io' show Platform;
// import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DB {
  late var connection;
  Future<void> connect() async {
    try {
      await dotenv.load(fileName: ".env");
      var conn = Endpoint(
        host: dotenv.env['DB_HOST']!,
        database: dotenv.env['DB_NAME']!,
        username: dotenv.env['DB_USERNAME']!,
        password: dotenv.env['DB_PASSWORD']!,
        port: int.parse(dotenv.env['DB_PORT']!),
      );
      connection = await Connection.open(
        conn,
        settings: const ConnectionSettings(sslMode: SslMode.disable),
      );
    } catch (e) {
      log(e.toString());
    }
    log('Connected to the database!');
    log(connection.toString());
  }

  Future<void> testGET() async {
    if (!connection.isOpen) {
      log('Database connection is closed!');
      return;
    }

    try {
      List<List<dynamic>> results = await connection.execute(
        "SELECT table_name FROM information_schema.tables WHERE table_schema = 'public'",
      );

      for (final row in results) {
        log('Table: ${row[0]}');
      }
    } catch (e) {
      log('Error during database query: $e');
    }
  }

//Для portfolios

  Future<List<Portfolios>> getPortfolio(int id) async {
    if (!connection.isOpen) {
      log('Database connection is closed!');
      return [];
    }

    try {
      List<List<dynamic>> results = await connection.execute(
        "SELECT * FROM public.portfolios WHERE id = $id",
      );

      return results.map((row) {
        return Portfolios.fromList(row);
      }).toList();
    } catch (e) {
      log('Error during database query: $e');
      return [];
    }
  }

  Future<List<Portfolios>> getPortfolios() async {
    if (!connection.isOpen) {
      log('Database connection is closed!');
      return [];
    }

    try {
      List<List<dynamic>> results = await connection.execute(
        "SELECT * FROM public.portfolios ORDER BY id ASC",
      );

      return results.map((row) {
        return Portfolios.fromList(row);
      }).toList();
    } catch (e) {
      log('Error during database query: $e');
      return [];
    }
  }

  Future<List<Work>> getWorks() async {
    if (!connection.isOpen) {
      log('Database connection is closed!');
      return [];
    }

    try {
      List<List<dynamic>> results = await connection.execute(
        "SELECT * FROM public.works",
      );

      return results.map((row) {
        return Work.fromMap({
          'id': row[0],
          'modeler_id': row[1],
          'path_to_model': row[2],
          'additional_info': jsonEncode(row[3]),
        });
      }).toList();
    } catch (e) {
      log('Error during database query: $e');
      return [];
    }
  }

//Для Messages_stat
  Future<int?> getLastChatId() async {
    if (!connection.isOpen) {
      log('Database connection is closed!');
      return null;
    }

    try {
      int result = await connection.execute(
        "SELECT MAX(chat_id) AS max_chat_id FROM public.messages_stat",
      );
      //log('Error deleting work: $result');
      return result;
    } catch (e) {
      log('Error deleting work: $e');
      return null;
    }
  }

  Future<List<MessageStat>> getMessagesStat(String chatId) async {
    if (!connection.isOpen) {
      log('Database connection is closed!');
      return [];
    }

    try {
      List<List<dynamic>> results = await connection.execute(
        "SELECT * FROM public.messages_stat WHERE chat_id = '$chatId' ORDER BY id ASC",
      );

      return results.map((row) {
        return MessageStat.fromMap({
          'id': row[0],
          'created_at': row[1].toString(),
          'id_user': row[2],
          'updated_at': row[3].toString(),
          'chat_id':
              row[4], // предполагается, что chat_id находится в этом индексе
          'chat_status': row[5],
          'message_text': row[6],
          'chat_article': row[7],
          'is_admin': false, // всегда false
        });
      }).toList();
    } catch (e) {
      log('Error during database query: $e');
      return [];
    }
  }

  Future<void> addMessageStat(MessageStat messageStat) async {
    if (!connection.isOpen) {
      log('Database connection is closed!');
      return;
    }

    try {
      await connection.execute(
        "INSERT INTO public.messages_stat (id, created_at, id_user, updated_at, chat_id, chat_status, message_text, chat_article, is_admin) VALUES "
        "('${messageStat.id}', '${messageStat.createdAt.toIso8601String()}', '${messageStat.idUser}', '${messageStat.updatedAt.toIso8601String()}', "
        "'${messageStat.chatId}', '${messageStat.chatStatus}', '${messageStat.messageText}', '${messageStat.chatArticle}', false)",
      );
      log('MessageStat added successfully');
    } catch (e) {
      log('Error adding MessageStat: $e');
    }
  }

  Future<void> closeConnection() async {
    await connection.close();

    log('Database connection closed!');
  }
}
