import 'package:flutter/material.dart';
import 'package:flutter_course_project/app_data_loader.dart';
import 'package:flutter_course_project/components/messages.dart';
import 'package:flutter_course_project/db/db_provider.dart';
import 'package:flutter_course_project/models/messages_stat.dart';
import 'package:flutter_course_project/components/messages.dart'; // Импортируйте ваш виджет сообщений
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final appData = AppDataManager();
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _chatNameController = TextEditingController();
  bool _isConnected = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _connectToDatabase();
    _initializeData();
  }

  Future<void> _connectToDatabase() async {
    final dbProvider = Provider.of<DbProvider>(context, listen: false);
    if (!dbProvider.isConnected) {
      await dbProvider.connect();
    }
    setState(() {
      _isConnected = dbProvider.isConnected;
    });
  }

  void _initializeData() async {
    await appData.readData();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _chatNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Обратная связь'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Обратная связь'),
      ),
      body: appData.isChatCreated ? _buildChatView() : _buildNoChatView(),
    );
  }

  Widget _buildChatView() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('ID чата: ${appData.chatId ?? 'Не найден'}'),
        ),
        Expanded(
          child: _buildMessagesList(),
        ),
        _buildMessageInput(),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: _resetChat,
            child: Text('Сбросить чат'),
          ),
        ),
      ],
    );
  }

  Widget _buildMessagesList() {
    return MessagesList(appData.chatId as String);
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Введите сообщение',
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              _sendMessage(_messageController.text);
              _messageController.clear();
            },
          ),
        ],
      ),
    );
  }

  void _sendMessage(String message) async {
    if (message.trim().isEmpty) return;
    List<MessageStat> msg =
        await Provider.of<DbProvider>(context, listen: false)
            .getMessagesStat(appData.chatId as String);
    int newMessageId = msg.last.id + 1;
    await Provider.of<DbProvider>(context, listen: false).addMessageStat(
      MessageStat(
        id: newMessageId,
        createdAt: DateTime.now(),
        idUser: int.parse(dotenv.env['USER_ID']!),
        updatedAt: DateTime.now(),
        chatId: int.parse(appData.chatId as String),
        chatStatus: 'active', // Или ваш статус по умолчанию
        messageText: message,
        chatArticle: null,
        isAdmin: false,
      ),
    );
    setState(() {});
  }

  Widget _buildNoChatView() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Введите название чата:'),
            SizedBox(height: 8.0),
            TextField(
              controller: _chatNameController,
              decoration: InputDecoration(
                hintText: 'Название чата',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _createChat,
              child: Text('Создать чат'),
            ),
          ],
        ),
      ),
    );
  }

  void _createChat() async {
    String chatName = _chatNameController.text.trim();
    if (chatName.isEmpty) {
      return;
    }
    String newChatId = '${DateTime.now().millisecondsSinceEpoch}';
    appData.createChat(newChatId, chatName);
    setState(() {});
  }

  void _resetChat() async {
    appData.resetChat();
    setState(() {});
  }
}
