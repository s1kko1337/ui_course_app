import 'package:flutter/material.dart';
import 'package:flutter_course_project/components/my_app_bar.dart';
import 'package:flutter_course_project/pages/db_test_screen.dart';
import 'package:flutter_course_project/pages/feedback_screen.dart';
import 'package:flutter_course_project/pages/main_screen.dart';
import 'package:flutter_course_project/pages/models_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_course_project/db/db_provider.dart';
import 'package:flutter_course_project/app_data_loader.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AppDataManager().readData();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  late TabController tabController;
  final AppDataManager appData = AppDataManager();

  @override
  void initState() {
    super.initState();
    tabController = TabController(length:4 , vsync: this);
    appData.resetModels();
    tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  @override
Widget build(BuildContext context) {
  String backgroundImage;

  switch(tabController.index) {
    case 0:
      backgroundImage = 'assets/img/bg_main.png';
      break;
    case 1:
      backgroundImage = 'assets/img/bg_models.png';
      break;
    case 2:
      backgroundImage = 'assets/img/bg_feedb.png';
      break;
    case 3:
      backgroundImage = 'assets/img/bg_feedb.png';
      break;
    default:
      backgroundImage = 'assets/img/bg_main.png';
  }

  return MaterialApp(
    home: ChangeNotifierProvider(
      create: (_) => DbProvider(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: true,
        appBar: MyAppBar(tabController: tabController),
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(backgroundImage),
                  fit: BoxFit.cover,
                ),
              ),
              child: TabBarView(
                controller: tabController,
                children: const <Widget>[
                  MainScreen(),
                  ModelsScreen(),
                  FeedbackScreen(),
                  DbTestScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
}
