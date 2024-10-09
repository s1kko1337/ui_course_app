import 'package:flutter/material.dart';
import 'package:flutter_course_project/components/my_app_bar.dart';
import 'package:flutter_course_project/pages/feedback_screen.dart';
import 'package:flutter_course_project/pages/main_screen.dart';
import 'package:flutter_course_project/pages/models_screen.dart';
import 'package:flutter_course_project/pages/simple_admin_page.dart';
import 'package:provider/provider.dart';
import 'package:flutter_course_project/db/db_provider.dart';
import 'package:flutter_course_project/pages/db_test_screen.dart';

Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 5, vsync: this);
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
  Widget build(BuildContext context) {
    //final colors = RootColors();

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
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/img/bg_main.png'),
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
                    SimpleAdminPage(),
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
