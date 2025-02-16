// import 'package:auto_route/auto_route.dart';
// import 'package:flutter/material.dart';

// import '../pages/data_list_page.dart';
// import '../../profile/pages/profile_page.dart';

// @RoutePage()
// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage>
//     with TickerProviderStateMixin {
//   late TabController _tabController;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//     _tabController.index = 0; // Set initial tab to Receipts (DataListPage)
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) => Scaffold(
//         appBar: AppBar(
//           title: const Text('Home'),
//           bottom: TabBar(
//             controller: _tabController,
//             tabs: const [
//               Tab(text: 'Receipts', icon: Icon(Icons.receipt)),
//               Tab(text: 'Profile', icon: Icon(Icons.person)),
//             ],
//           ),
//         ),
//         body: TabBarView(
//           controller: _tabController,
//           children: const [
//             DataListPage(),
//             ProfilePage(),
//           ],
//         ),
//       );
// }
