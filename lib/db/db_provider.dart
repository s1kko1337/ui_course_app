import 'package:flutter/material.dart';
import 'package:flutter_course_project/db/db.dart';
import 'package:flutter_course_project/models/messages_stat.dart';
import 'package:flutter_course_project/models/portfolios.dart';
import 'package:flutter_course_project/models/works.dart';

class DbProvider extends ChangeNotifier {
  final DB _db = DB();
  bool _isConnected = false;
  String _statusMessage = 'Not connected';

  bool get isConnected => _isConnected;
  String get statusMessage => _statusMessage;

  Future<void> connect() async {
    try {
      if (_isConnected == false) {
        await _db.connect();
        _isConnected = true;
        _statusMessage = 'Successfully connected to the database!';
      }
    } catch (e) {
      _isConnected = false;
      _statusMessage = 'Connection failed: $e';
    }
    notifyListeners();
  }

  Future<List<Portfolios>> getPortfolios() async {
    if (_isConnected) {
      return await _db.getPortfolios();
    } else {
      _statusMessage = 'No connection available!';
      notifyListeners();
      return [];
    }
  }

  Future<List<Portfolios>> getPortfolio(int id) async {
    if (_isConnected) {
      return await _db.getPortfolio(id);
    } else {
      _statusMessage = 'No connection available!';
      notifyListeners();
      return [];
    }
  }

  Future<List<Work>> getWorks() async {
    if (_isConnected) {
      return await _db.getWorks();
    } else {
      _statusMessage = 'No connection available!';
      notifyListeners();
      return [];
    }
  }

  Future<List<MessageStat>> getMessagesStat(String chatId) async {
    if (_isConnected) {
      return await _db.getMessagesStat(chatId);
    } else {
      _statusMessage = 'No connection available!';
      notifyListeners();
      return [];
    }
  }

  Future<List<MessageStat>> getGlobalMessagesStat() async {
    if (_isConnected) {
      return await _db.getAllMesages();
    } else {
      _statusMessage = 'No connection available!';
      notifyListeners();
      return [];
    }
  }
  Future<void> addMessageStat(MessageStat messageStat) async {
    if (_isConnected) {
      await _db.addMessageStat(messageStat);
      notifyListeners();
    } else {
      _statusMessage = 'No connection available!';
      notifyListeners();
    }
  }

  Future<void> closeConnection() async {
    if (_isConnected) {
      await _db.closeConnection();
      _isConnected = false;
      _statusMessage = 'Connection closed';
    }
    notifyListeners();
  }
}
