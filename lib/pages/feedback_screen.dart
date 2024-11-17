import 'package:flutter/material.dart';
import 'package:flutter_course_project/colors/root_colors.dart';
import 'package:flutter_course_project/components/custom_card.dart';
import 'package:flutter_course_project/components/default_text.dart';
import 'package:flutter_course_project/components/orange_button_style.dart';
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
  final colors = RootColors();
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
        child: Column(
      children: [
        const SizedBox(
          height: 150,
        ),
        CustomCard(
          height: 200,
          width: 0,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                'Для обратной связи напишите создайте чат.',
                style: TextStyle(
                  color: colors.TextCol,
                  fontSize: 48,
                ),
              ),
            ]),
          ),
        ),
        const SizedBox(
          height: 150,
        ),
        CustomCard(
          height: 300,
          width: 450,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Для обратной связи напишите создайте чат.',
                  style: TextStyle(
                    color: colors.TextCol,
                    fontSize: 30,
                  ),
                ),
                const SizedBox(height: 8.0),
                TextField(
                  controller: _chatNameController,
                  decoration: InputDecoration(
                    hintText: 'Введите тему обращения',
                    hintStyle: TextStyle(
                      color: colors.TextCol,
                      fontSize: 20,
                    ),
                    border:
                        const OutlineInputBorder(), // Добавляет рамку вокруг TextField
                    filled: true, // Заполняет фон
                    fillColor: colors.ColorBgSoftCol, // Цвет фона
                  ),
                  style: TextStyle(
                    color: colors.TextCol,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  style: ButtonStyles.elevatedButtonStyle(colors),
                  onPressed: _createChat,
                  child: const Text('Создать чат'),
                ),
              ],
            ),
          ),
        ),
      ],
    ));
  }

  Future<void> _createChat() async {
    String chatName = _chatNameController.text.trim();
    if (chatName.isEmpty) {
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
