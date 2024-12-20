import 'package:postgres/postgres.dart';
import 'package:flutter_course_project/models/messages_stat.dart';
import 'package:flutter_course_project/models/portfolios.dart';
import 'package:flutter_course_project/models/works.dart';
import 'dart:developer';
import 'dart:core';
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
        "SELECT * FROM public.works WHERE modeler_id = '${dotenv.env['USER_ID']!}'",
      );

      return results.map((row) {
        log('Transforming row: $row');

        Work work = Work.fromMap({
          'id': row[0],
          'modeler_id': row[1],
          'path_to_model': row[2],
          'additional_info': row[3],
          'model_name': row[6],
          'binary_file': row[7],
          'binary_preview': row[8],
        });

        log('Created Work object: $work');

        return work;
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
      return result;
    } catch (e) {
      log('Error deleting work: $e');
      return null;
    }
  }

  Future<List<MessageStat>> getAllMesages() async {
    if (!connection.isOpen) {
      log('Database connection is closed!');
      return [];
    }

    try {
      List<List<dynamic>> results = await connection.execute(
        "SELECT * FROM public.messages_stat WHERE id_user = '${dotenv.env['USER_ID']!}' ORDER BY id ASC",
      );

      return results.map((row) {
        return MessageStat.fromMap({
          'id': row[0],
          'created_at': row[1].toString(),
          'id_user': row[2],
          'updated_at': row[3].toString(),
          'chat_id': row[4],
          'chat_status': row[5],
          'message_text': row[6],
          'chat_article': row[7],
          'is_admin': false,
        });
      }).toList();
    } catch (e) {
      log('Error during database query: $e');
      return [];
    }
  }

  Future<List<List<dynamic>>> getChatList() async {
    if (!connection.isOpen) {
      log('Database connection is closed!');
      return [];
    }

    // Assuming 'messages_stat' is your table name
    List<List<dynamic>> results = await connection.execute(
        "SELECT DISTINCT chatId, chatArticle FROM messages_stat WHERE id_user = '${dotenv.env['USER_ID']!}'");
    return results;
  }

  Future<List<MessageStat>> getMessagesStat(String chatId) async {
    if (!connection.isOpen) {
      log('Database connection is closed!');
      return [];
    }

    try {
      List<List<dynamic>> results = await connection.execute(
        "SELECT * FROM public.messages_stat WHERE chat_id = '$chatId' AND id_user = '${dotenv.env['USER_ID']!}' ORDER BY id ASC",
      );

      return results.map((row) {
        return MessageStat.fromMap({
          'id': row[0],
          'created_at': row[1].toString(),
          'id_user': row[2],
          'updated_at': row[3].toString(),
          'chat_id': row[4],
          'chat_status': row[5],
          'message_text': row[6],
          'chat_article': row[7],
          'is_admin': row[8],
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

  Future<void> incrementViews() async {
    if (!connection.isOpen) {
      log('Database connection is closed!');
      return;
    }
    final portfolioId = dotenv.env['USER_ID']!;

    try {
      await connection.execute(
        "UPDATE public.portfolios SET views = views + 1 WHERE id = '$portfolioId'",
      );
      log('MessageStat added successfully');
    } catch (e) {
      log('Error adding MessageStat: $e');
    }
  }

    Future<void> incrementViewsModel(int modelID) async {
    if (!connection.isOpen) {
      log('Database connection is closed!');
      return;
    }

    try {
      await connection.execute(
        "UPDATE public.works SET views = views + 1 WHERE id = '$modelID'",
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
