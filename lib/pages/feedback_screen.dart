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
  bool _isLoading = false;
  List<Map<String, String>> _chatList = [];
  String? _selectedChatId;

  @override
  void initState() {
    super.initState();
    _connectToDatabase();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await appData.readData();
    _loadChatList();
    setState(() {});
  }

  void _loadChatList() {
    setState(() {
      _chatList = appData.chatList;
    });
  }

  Future<void> _connectToDatabase() async {
    final dbProvider = Provider.of<DbProvider>(context, listen: false);
    if (!dbProvider.isConnected) {
      await dbProvider.connect();
    }
    setState(() {});
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

  Widget _buildChatDropdown() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final cardWidth = screenWidth * 0.9;
    final cardHeight = screenHeight * 0.1;
    return CustomCard(
      width: cardWidth,
      height: cardHeight,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              'Список чатов',
              style: TextStyle(
                color: colors.TextCol,
              ),
            ),
            DropdownButton<String>(
              hint: Text(
                'Выберите чат',
                style: TextStyle( 
                  color: colors.TextCol,
                ),
              ),
              value: _selectedChatId,
              items: _chatList.map((chat) {
                return DropdownMenuItem<String>(
                  value: chat['chatId'],
                  child: Text(
                    chat['chatName'] ?? 'Без названия',
                    style: TextStyle(
                      color: colors.TextCol,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedChatId = value;
                });
                _selectChat(value);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatView() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DefaultText(text: 'ID чата: ${appData.chatId ?? 'Не найден'}'),
        ),
        const Expanded(
          child: MessagesList(),
        ),
        _buildMessageInput(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: _goToChatSelection,
            style: ButtonStyles.elevatedButtonStyle(colors),
            child: const Text('Выбрать чат'),
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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final cardWidth = screenWidth * 0.9;
    final cardHeight = screenHeight * 0.4;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center, // Center horizontally
        children: [
          CustomCard(
            height: cardWidth / 1.75,
            width: cardHeight,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Для обратной связи создайте чат или выберите существующий.',
                    style: TextStyle(
                      color: colors.TextCol,
                      fontSize: 30,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: screenHeight * 0.045,
          ),
          // Include the chat dropdown if there are existing chats
          if (_chatList.isNotEmpty) _buildChatDropdown(),
          SizedBox(
            height: screenHeight * 0.045,
          ),
          CustomCard(
            height: cardWidth / 1.65,
            width: cardHeight,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Введите тему обращения.',
                    style: TextStyle(
                      color: colors.TextCol,
                      fontSize: 24,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8.0),
                  TextField(
                    controller: _chatNameController,
                    decoration: InputDecoration(
                      hintText:
                          'Введите тему заказа/ваши замечания по оформлению приложения',
                      hintStyle: TextStyle(
                        color: colors.TextCol,
                        fontSize: 20,
                      ),
                      border: const OutlineInputBorder(),
                      filled: true,
                      fillColor: colors.ColorBgSoftCol,
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
      ),
    );
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
    _loadChatList(); // Refresh the chat list
    setState(() {});
  }

  void _goToChatSelection() {
    setState(() {
      appData.isChatCreated = false;
    });
  }

  void _selectChat(String? chatId) {
    if (chatId == null) return;

    // Find the selected chat
    final selectedChat = _chatList.firstWhere(
      (chat) => chat['chatId'] == chatId,
    );

    appData.createChat(chatId, selectedChat['chatName'] ?? '');
    setState(() {});
  }

  void _createNewChat() async {
    String chatName = _chatNameController.text.trim();
    if (chatName.isEmpty) {
      // Show an error or return
      return;
    }

    // Generate a new chat ID
    String newChatId = DateTime.now().millisecondsSinceEpoch.toString();

    // Create the chat in the database if necessary
    // For example, you can add an entry to your messages_stat table

    // Update the AppDataManager
    await appData.createChat(newChatId, chatName);
    _loadChatList();

    setState(() {});
  }

  Future<void> _resetChat() async {
    // appData.resetChat();
    setState(() {});
  }
}
