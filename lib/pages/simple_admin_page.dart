// import 'package:flutter/material.dart';
// import 'package:flutter_course_project/components/custom_card.dart';
// import 'package:flutter_course_project/colors/root_colors.dart';
// import 'package:flutter_course_project/components/default_text.dart';
// import 'package:flutter_course_project/components/delete_user_card.dart';
// import 'package:flutter_course_project/components/register_user_form.dart';
// import 'package:flutter_course_project/components/update_user.dart';
// import 'package:flutter_course_project/components/users_list.dart';
// import 'package:flutter_course_project/db/db_provider.dart';
// import 'package:provider/provider.dart';

// class SimpleAdminPage extends StatefulWidget {
//   const SimpleAdminPage({super.key});

//   @override
//   SimpleAdminPageState createState() => SimpleAdminPageState();
// }

// class SimpleAdminPageState extends State<SimpleAdminPage> {
//   bool _isConnected = false;
//   bool _isUserListExpanded = false;

//   @override
//   void initState() {
//     super.initState();
//     _connectToDatabase();
//   }

//   Future<void> _connectToDatabase() async {
//     final dbProvider = Provider.of<DbProvider>(context, listen: false);
//     if (dbProvider.isConnected) {
//       _isConnected = true;
//     } else {
//       await dbProvider.connect();
//     }
//     setState(() {
//       _isConnected = dbProvider.isConnected;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     RootColors colors = RootColors();
//     return SafeArea(
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Center(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               ExpansionTile(
//                 minTileHeight: 50,
//                 shape: const BorderDirectional(),
//                 title: const Center(
//                   child: CustomCard(
//                     height: 50,
//                     width: 0,
//                     child: DefaultText(text: 'Добавить партфолио'),
//                   ),
//                 ),
//                 backgroundColor: colors.CardCol,
//                 children: const [
//                   SizedBox(height: 5),
//                   CustomCard(
//                     height: 300,
//                     width: 0,
//                     child: RegisterUserForm(),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 25),
//               ExpansionTile(
//                 minTileHeight: 50,
//                 shape: const BorderDirectional(),
//                 title: const Center(
//                   child: CustomCard(
//                     height: 50,
//                     width: 0,
//                     child: DefaultText(text: 'Обновить партфолио'),
//                   ),
//                 ),
//                 backgroundColor: colors.CardCol,
//                 children: const [
//                   SizedBox(height: 5),
//                   CustomCard(
//                     height: 300,
//                     width: 0,
//                     child: UpdateUser(),
//                   ),
//                 ],
//               ),
//               ExpansionTile(
//                 minTileHeight: 50,
//                 shape: const BorderDirectional(),
//                 title: const Center(
//                   child: CustomCard(
//                     height: 50,
//                     width: 0,
//                     child: DefaultText(text: 'Удалить партфолио'),
//                   ),
//                 ),
//                 backgroundColor: colors.CardCol,
//                 children: const [
//                   SizedBox(height: 5),
//                   CustomCard(
//                     height: 175,
//                     width: 0,
//                     child: DeleteUserCard(),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 5),
//               GestureDetector(
//                 onTap: () {
//                   setState(() {
//                     _isUserListExpanded = !_isUserListExpanded;
//                   });
//                 },
//                 child: const CustomCard(
//                   height: 50,
//                   width: 0,
//                   child: DefaultText(text: 'Список партфолио'),
//                 ),
//               ),
//               if (_isUserListExpanded) // Показываем список только если он развернут
//                 Expanded(
//                   child: _isConnected
//                       ? const UserList()
//                       : const Center(
//                           child: Text('Подключение к базе данных...')),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
