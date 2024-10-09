import 'package:postgres/postgres.dart';
import 'package:flutter_course_project/models/messages_stat.dart';
import 'package:flutter_course_project/models/users.dart';
import 'package:flutter_course_project/models/works.dart';
import 'dart:developer';
import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

//TODO Шаблонизировать функции для запросов к базе, чтобы они работали в зависимости от типа принятого объекта
class DB {
  late final connection;
  final connWeb = Endpoint(
    host: '0.0.0.0',
    database: 'postgres',
    username: 'postgres',
    password: 'postgres',
    port: 5432,
  );
  final conn = Endpoint(
    host: '10.0.2.2',
    database: 'postgres',
    username: 'postgres',
    password: 'postgres',
    port: 5432,
  );
  Future<void> connect() async {
    try {
      if (kIsWeb) {
        connection = await Connection.open(
          connWeb,
          settings: const ConnectionSettings(sslMode: SslMode.disable),
        );
      }
      if (Platform.isAndroid) {
        connection = await Connection.open(
          conn,
          settings: const ConnectionSettings(sslMode: SslMode.disable),
        );
      }
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

//Для Users

  Future<List<User>> getUser(int id) async {
    if (!connection.isOpen) {
      log('Database connection is closed!');
      return [];
    }

    try {
      List<List<dynamic>> results = await connection.execute(
        "SELECT * FROM public.users WHERE id = $id",
      );

      return results.map((row) {
        return User.fromList(row);
      }).toList();
    } catch (e) {
      log('Error during database query: $e');
      return [];
    }
  }

  Future<List<User>> getUsers() async {
    if (!connection.isOpen) {
      log('Database connection is closed!');
      return [];
    }

    try {
      List<List<dynamic>> results = await connection.execute(
        "SELECT * FROM public.users ORDER BY id ASC",
      );

      return results.map((row) {
        return User.fromList(row);
      }).toList();
    } catch (e) {
      log('Error during database query: $e');
      return [];
    }
  }

  Future<void> addUser(User user) async {
    if (!connection.isOpen) {
      log('Database connection is closed!');
      return;
    }
    final id = user.id;
    final mainInfo = jsonEncode(user.mainInfo);
    final additionalInfo = jsonEncode(user.additionalInfo);
    final mediaLinks = jsonEncode(user.mediaLinks.toJson());
    try {
      await connection.execute(
          "INSERT INTO public.users (id, main_info, additional_info, media_links) VALUES ('$id', '$mainInfo', '$additionalInfo', '$mediaLinks')");
      log('User added successfully');
    } catch (e) {
      log('Error adding user: $e');
    }
  }

  Future<void> updateUser(User user) async {
    if (!connection.isOpen) {
      log('Database connection is closed!');
      return;
    }

    final id = user.id;
    final mainInfo = jsonEncode(user.mainInfo);
    final additionalInfo = jsonEncode(user.additionalInfo);
    final mediaLinks = jsonEncode(user.mediaLinks.toJson());

    try {
      await connection.execute(
        "UPDATE public.users SET main_info = '$mainInfo', additional_info = '$additionalInfo', media_links = '$mediaLinks' WHERE id = $id",
      );
      log('User updated successfully');
    } catch (e) {
      log('Error updating user: $e');
    }
  }

  Future<void> deleteUser(int id) async {
    if (!connection.isOpen) {
      log('Database connection is closed!');
      return;
    }

    try {
      await connection.execute(
        "DELETE FROM public.users WHERE id = '$id'",
      );
      log('User deleted successfully');
    } catch (e) {
      log('Error deleting user: $e');
    }
  }

//Для Works

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

  Future<void> addWork(Work work) async {
    if (!connection.isOpen) {
      log('Database connection is closed!');
      return;
    }
    final id = work.id;
    final modelerId = work.modelerId;
    final pathToModel = work.pathToModel;
    final additionalInfo = jsonEncode(work.additionalInfo);
    try {
      await connection.execute(
        "INSERT INTO public.works (id, modeler_id, path_to_model, additional_info) VALUES ('$id', '$modelerId', '$pathToModel', '$additionalInfo')",
      );
      log('Work added successfully');
    } catch (e) {
      log('Error adding work: $e');
    }
  }

  Future<void> updateWork(Work work) async {
    if (!connection.isOpen) {
      log('Database connection is closed!');
      return;
    }
    final id = work.id;
    final modelerId = work.modelerId;
    final pathToModel = work.pathToModel;
    final additionalInfo = jsonEncode(work.additionalInfo);
    try {
      await connection.execute(
        "UPDATE public.works SET modeler_id = '$modelerId', path_to_model = '$pathToModel', additional_info = '$additionalInfo' WHERE id = '$id'",
      );
      log('Work updated successfully');
    } catch (e) {
      log('Error updating work: $e');
    }
  }

  Future<void> deleteWork(String id) async {
    if (!connection.isOpen) {
      log('Database connection is closed!');
      return;
    }

    try {
      await connection.execute(
        "DELETE FROM public.works WHERE id = '$id'",
      );
      log('Work deleted successfully');
    } catch (e) {
      log('Error deleting work: $e');
    }
  }

//Для Messages_stat

  Future<List<MessageStat>> getMessagesStat() async {
    if (!connection.isOpen) {
      log('Database connection is closed!');
      return [];
    }

    try {
      List<List<dynamic>> results = await connection.execute(
        "SELECT * FROM public.messages_stat",
      );

      return results.map((row) {
        return MessageStat.fromMap({
          'id': row[0],
          'message_body': jsonEncode(row[1]),
          'email': row[2],
          'created_at': row[3].toString(),
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
    final id = messageStat.id;
    final messageBody = jsonEncode(messageStat.messageBody);
    final email = messageStat.email;
    final createdAt = messageStat.createdAt.toIso8601String();
    try {
      await connection.execute(
        "INSERT INTO public.messages_stat (id, message_body, email, created_at) VALUES ('$id', '$messageBody', '$email', '$createdAt')",
      );
      log('MessageStat added successfully');
    } catch (e) {
      log('Error adding MessageStat: $e');
    }
  }

  Future<void> updateMessageStat(MessageStat messageStat) async {
    if (!connection.isOpen) {
      log('Database connection is closed!');
      return;
    }
    final id = messageStat.id;
    final messageBody = jsonEncode(messageStat.messageBody);
    final email = messageStat.email;
    final createdAt = messageStat.createdAt.toIso8601String();
    try {
      await connection.execute(
        "UPDATE public.messages_stat SET message_body = '$messageBody', email = '$email', created_at = '$createdAt' WHERE id = '$id'",
      );
      log('MessageStat updated successfully');
    } catch (e) {
      log('Error updating MessageStat: $e');
    }
  }

  Future<void> deleteMessageStat(String id) async {
    if (!connection.isOpen) {
      log('Database connection is closed!');
      return;
    }

    try {
      await connection.execute(
        "DELETE FROM public.messages_stat WHERE id = $id",
      );
      log('MessageStat deleted successfully');
    } catch (e) {
      log('Error deleting MessageStat: $e');
    }
  }

  Future<void> closeConnection() async {
    await connection.close();

    log('Database connection closed!');
  }
}
