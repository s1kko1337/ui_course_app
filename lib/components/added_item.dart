// import 'package:flutter/material.dart';
// import 'package:flutter_course_project/models/works.dart';

// class UserInfoPage extends StatelessWidget {
//   final Work userInfo;
//   const UserInfoPage({super.key, required this.userInfo});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('User info'),
//         centerTitle: true,
//       ),
//       body: Card(
//         margin: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             ListTile(
//               title: Text(
//                 userInfo.name,
//                 style: const TextStyle(fontWeight: FontWeight.w500),
//               ),
//               subtitle: Text('${userInfo.story}'),
//               leading: const Icon(
//                 Icons.person,
//                 color: Colors.black,
//               ),
//               trailing: Text('${userInfo.country}'),
//             ),
//             ListTile(
//               title: Text(
//                 userInfo.phone,
//                 style: const TextStyle(fontWeight: FontWeight.w500),
//               ),
//               leading: const Icon(
//                 Icons.phone,
//                 color: Colors.black,
//               ),
//             ),
//             ListTile(
//               title: Text(
//                 userInfo.email,
//                 style: const TextStyle(fontWeight: FontWeight.w500),
//               ),
//               leading: const Icon(
//                 Icons.email,
//                 color: Colors.black,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
