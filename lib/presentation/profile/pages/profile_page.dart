import 'package:auto_route/auto_route.dart';
import 'package:blutut_clasic/presentation/widgets/bottom_navbar_widget.dart';
import 'package:flutter/material.dart';

@RoutePage()
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.blueAccent,
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey,
              ),
            ),
            SizedBox(height: 20),
            Card(
              elevation: 3,
              child: ListTile(
                leading: Icon(Icons.person),
                title: Text('Name'),
                subtitle: Text('John Doe'),
              ),
            ),
            SizedBox(height: 10),
            Card(
              elevation: 3,
              child: ListTile(
                leading: Icon(Icons.email),
                title: Text('Email'),
                subtitle: Text('john.doe@example.com'),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavbarWidget(),
    );
  }
}