import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_course_project/app_data_loader.dart';
import 'package:flutter_course_project/components/messages.dart';
import 'package:flutter_course_project/db/db_provider.dart';
import 'package:flutter_course_project/models/messages_stat.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final AppDataManager appData = AppDataManager();
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _chatNameController = TextEditingController();
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
    setState(() {});
  }

  Future<void> _initializeData() async {
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
      return const SafeArea(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return SafeArea(
      child: appData.isChatCreated ? _buildChatView() : _buildNoChatView(),
    );
  }

  Widget _buildChatView() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('ID чата: ${appData.chatId ?? 'Не найден'}'),
        ),
        const Expanded(
          child: MessagesList(),
        ),
        _buildMessageInput(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: _resetChat,
            child: const Text('Сбросить чат'),
          ),
        ),
      ],
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                hintText: 'Введите сообщение',
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              _sendMessage(_messageController.text);
              _messageController.clear();
            },
          ),
        ],
      ),
    );
  }

  Future<void> _sendMessage(String message) async {
    if (message.trim().isEmpty) return;
    final dbProvider = Provider.of<DbProvider>(context, listen: false);
    List<MessageStat> messages =
        await dbProvider.getMessagesStat(appData.chatId!);
    int newMessageId = messages.isNotEmpty ? messages.last.id + 1 : 1;
    await dbProvider.addMessageStat(
      MessageStat(
        id: newMessageId,
        createdAt: DateTime.now(),
        idUser: int.parse(dotenv.env['USER_ID']!),
        updatedAt: DateTime.now(),
        chatId: int.parse(appData.chatId!),
        chatStatus: 'active',
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
        padding: const EdgeInsets.all(16.0), // Добавлено для удобства
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Введите название чата:'),
            const SizedBox(height: 8.0),
            TextField(
              controller: _chatNameController,
              decoration: const InputDecoration(
                hintText: 'Название чата',
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _createChat,
              child: const Text('Создать чат'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _createChat() async {
    String chatName = _chatNameController.text.trim();
    if (chatName.isEmpty) {
      // Дополнительно: показать предупреждение о необходимости ввода названия
      return;
    }
    final dbProvider = Provider.of<DbProvider>(context, listen: false);
    List<MessageStat> messages = await dbProvider.getGlobalMessagesStat();
    int newMessageId = messages.isNotEmpty ? messages.last.id + 1 : 1;
    String newChatId = DateTime.now().millisecondsSinceEpoch.toString();
    await dbProvider.addMessageStat(
      MessageStat(
        id: newMessageId,
        createdAt: DateTime.now(),
        idUser: int.parse(dotenv.env['USER_ID']!),
        updatedAt: DateTime.now(),
        chatId: int.parse(newChatId),
        chatStatus: 'active',
        messageText: 'nullablefirstmessageforopenchat',
        chatArticle: chatName,
        isAdmin: false,
      ),
    );
    appData.createChat(newChatId, chatName);
    setState(() {});
  }

  Future<void> _resetChat() async {
    appData.resetChat();
    setState(() {});
  }
}
