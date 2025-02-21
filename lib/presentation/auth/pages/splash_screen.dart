import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../core/router/app_router.gr.dart';

@RoutePage(name: 'SplashRoute')
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(
        const Duration(seconds: 2),
        () => context.router.replace(const LoginRoute()),
      );
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/login_logo.png',
              height: 80,
            ),
            const SizedBox(height: 16),
            const Text(
              'MATRANS',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            const Text(
              'PT. Makassar Trans',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
