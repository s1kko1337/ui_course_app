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

  Future<void> testQuery() async {
    if (_isConnected) {
      await _db.testGET();
    } else {
      _statusMessage = 'No connection available!';
      notifyListeners();
    }
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

  Future<void> addPortfolio(Portfolios user) async {
    if (_isConnected) {
      await _db.addPortfolio(user);
      notifyListeners();
    } else {
      _statusMessage = 'No connection available!';
      notifyListeners();
    }
  }

  Future<void> updatePortfolio(Portfolios user) async {
    if (_isConnected) {
      await _db.updatePortfolio(user);
      notifyListeners();
    } else {
      _statusMessage = 'No connection available!';
      notifyListeners();
    }
  }

  Future<void> deletePortfolio(int id) async {
    if (_isConnected) {
      await _db.deletePortfolio(id);
      notifyListeners();
    } else {
      _statusMessage = 'No connection available!';
      notifyListeners();
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

  Future<void> addWork(Work work) async {
    if (_isConnected) {
      await _db.addWork(work);
      notifyListeners();
    } else {
      _statusMessage = 'No connection available!';
      notifyListeners();
    }
  }

  Future<void> updateWork(Work work) async {
    if (_isConnected) {
      await _db.updateWork(work);
      notifyListeners();
    } else {
      _statusMessage = 'No connection available!';
      notifyListeners();
    }
  }

  Future<void> deleteWork(String id) async {
    if (_isConnected) {
      await _db.deleteWork(id);
      notifyListeners();
    } else {
      _statusMessage = 'No connection available!';
      notifyListeners();
    }
  }

  Future<List<MessageStat>> getMessagesStat() async {
    if (_isConnected) {
      return await _db.getMessagesStat();
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

  Future<void> updateMessageStat(MessageStat messageStat) async {
    if (_isConnected) {
      await _db.updateMessageStat(messageStat);
      notifyListeners();
    } else {
      _statusMessage = 'No connection available!';
      notifyListeners();
    }
  }

  Future<void> deleteMessageStat(String id) async {
    if (_isConnected) {
      await _db.deleteMessageStat(id);
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
