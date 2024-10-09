import 'package:flutter/material.dart';
import 'package:flutter_course_project/components/custom_card.dart';
import 'package:flutter_course_project/colors/root_colors.dart';
import 'package:flutter_course_project/components/default_text.dart';
import 'package:flutter_course_project/db/db_provider.dart';
import 'package:flutter_course_project/models/users.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart'; // Импортируем url_launcher

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  bool _isConnected = false;

  @override
  void initState() {
    super.initState();
    _connectToDatabase();
  }

  Future<void> _connectToDatabase() async {
    final dbProvider = Provider.of<DbProvider>(context, listen: false);
    if (dbProvider.isConnected) {
      _isConnected = true;
    } else {
      await dbProvider.connect();
    }
    setState(() {
      _isConnected = dbProvider.isConnected;
    });
  }

  // Функция для открытия ссылки
  Future<void> _openLink(String? url) async {
    if (url != null && url.isNotEmpty) {
      final Uri uri = Uri.parse(url);
      //if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
      //} else {
      //  throw 'Could not launch $url';
      //}
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = RootColors();
    final dbProvider = Provider.of<DbProvider>(context);
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder<List<User>>(
                future: dbProvider.getUser(1),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return CustomCard(
                        height: 313,
                        width: 369,
                        child: Center(
                            child: DefaultText(
                                text: 'Такой пользователь не найден')));
                  } else {
                    final user =
                        snapshot.data!.first; // Since you're fetching one user

                    return CustomCard(
                      height: 313,
                      width: 369,
                      child: DefaultText(text: '${user.mainInfo['info']}'),
                    );
                  }
                },
              ),
              const SizedBox(
                height: 25,
              ),
              FutureBuilder<List<User>>(
                future: dbProvider.getUser(1),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return CustomCard(
                        height: 313,
                        width: 369,
                        child: Center(
                            child: DefaultText(
                                text: 'Такой пользователь не найден')));
                  } else {
                    final user =
                        snapshot.data!.first; // Since you're fetching one user

                    return CustomCard(
                      height: 313,
                      width: 369,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          DefaultText(text: '${user.additionalInfo['info']}'),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              // Иконка ArtStation
                              IconButton(
                                icon: Icon(
                                  Icons.art_track,
                                  color: colors.IconActiveCol,
                                ),
                                onPressed: () =>
                                    _openLink(user.mediaLinks.artstation),
                                tooltip: 'Open ArtStation',
                              ),
                              // Иконка Telegram
                              IconButton(
                                icon: Icon(
                                  Icons.telegram,
                                  color: colors.IconActiveCol,
                                ),
                                onPressed: () => _openLink(user.mediaLinks.tg),
                                tooltip: 'Open Telegram',
                              ),
                              // Иконка VK
                              IconButton(
                                icon: Icon(
                                  Icons.videocam,
                                  color: colors.IconActiveCol,
                                ),
                                onPressed: () => _openLink(user.mediaLinks.vk),
                                tooltip: 'Open VK',
                              ),
                              // Иконка Instagram
                              IconButton(
                                icon: Icon(
                                  Icons.camera_alt,
                                  color: colors.IconActiveCol,
                                ),
                                onPressed: () =>
                                    _openLink(user.mediaLinks.inst),
                                tooltip: 'Open Instagram',
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
