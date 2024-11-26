import 'package:flutter/material.dart';
import 'package:flutter_course_project/colors/root_colors.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TabController tabController;

  const MyAppBar({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    final colors = RootColors();

    return AppBar(
      backgroundColor: colors.NoneCol,
      automaticallyImplyLeading: false, // Скрыть стандартную кнопку назад
      title: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: colors.MainScreenBgCol,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: TabBar(
          controller: tabController,
          labelColor: Colors.white,
          unselectedLabelColor: colors.IconNonActiveCol,
          tabs: <Widget>[
            Tab(
              icon: Icon(
                Icons.explore,
                color: tabController.index == 0
                    ? colors.IconActiveCol
                    : colors.IconNonActiveCol,
              ),
            ),
            Tab(
              icon: Icon(
                Icons.view_in_ar,
                color: tabController.index == 1
                    ? colors.IconActiveCol
                    : colors.IconNonActiveCol,
              ),
            ),
            Tab(
              icon: Icon(
                Icons.mail,
                color: tabController.index == 2
                    ? colors.IconActiveCol
                    : colors.IconNonActiveCol,
              ),
            ),
            Tab(
              icon: Icon(
                Icons.settings,
                color: tabController.index == 3
                    ? colors.IconActiveCol
                    : colors.IconNonActiveCol,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}
