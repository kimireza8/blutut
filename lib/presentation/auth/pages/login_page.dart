// ignore_for_file: avoid_print, use_build_context_synchronously, library_private_types_in_public_api

import 'dart:convert';
import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:blutut_clasic/core/router/app_router.gr.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/';

@RoutePage()
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final Dio _dio = Dio();

  Future<void> _login() async {
    try {
      final response = await _dio.post(
          'https://app.ptmakassartrans.com/index.php/auth/login.json',
          data: {
            'username': 'administrator',
            'password': 'sikomolewat12kali',
            // 'captcha': '',
            // 'remember': '0',
          },
          options: Options(headers: {
            "Accept": "application/json, text/javascript, */*; q=0.01",
            "Content-Type": "application/x-www-form-urlencoded",
            "Origin": "https://app.ptmakassartrans.com",
            "Referer": "https://app.ptmakassartrans.com/index.php/auth/",
            "X-Requested-With": "XMLHttpRequest",
          }));


      print(response.statusCode);
      print(response.data);
      print(response.headers['set-cookie']);

      var token;
      for (var cookie in response.headers['set-cookie'] ?? []) {
        var cookieParts = cookie.split(';');
        var cookieName = cookieParts[0].split('=')[0].trim();
        var cookieValue = cookieParts[0].split('=')[1].trim();
        if (cookieName == 'siklonsession') {
          token = cookieValue;
        }
      }

      log("siklonsession=$token");

      final response_user_info = await _dio.post(
          'https://app.ptmakassartrans.com/index.php/usermanagement/info.json',
          options: Options(headers: {
            'cookie': "siklonsession=$token",
          }));

      print(response_user_info.data);
      print(response_user_info.headers);

      int timestamp = DateTime.now().millisecondsSinceEpoch;

      final response_fetch_data = await _dio.post(
        "https://app.ptmakassartrans.com/index.php/oprincomingreceipt/index.mod?_dc=$timestamp",
        data: {
          'select': jsonEncode([
            "oprincomingreceipt_id",
            "oprincomingreceipt_branch__organization_name",
            "oprincomingreceipt_number",
            "oprincomingreceipt_date",
            "oprincomingreceipt_totalcollies",
            "oprincomingreceipt_colliesnum",
            "oprincomingreceipt_cargonum",
            "oprincomingreceipt_oprkindofservice__oprkindofservice_name",
            "oprincomingreceipt_oprroute__oprroute_name",
            "oprincomingreceipt_oprcustomer__oprcustomer_name",
            "oprincomingreceipt_oprcustomerrole__oprcustomerrole_name",
            "oprincomingreceipt_shippername",
            "oprincomingreceipt_consigneename",
            "oprincomingreceipt_oprincomingreceiptstatus__oprincomingreceiptstatus_name"
          ]),
          'advsearch': null,
          'prefilter': jsonEncode([
            {"field_name": "oprincomingreceipt_branch__organization_id", "field_value": null},
            {"field_name": "oprincomingreceipt_year__year_id", "field_value": null},
            {"field_name": "oprincomingreceipt_month__month_id", "field_value": null},
            {"field_name": "oprincomingreceipt_oprincomingreceiptstatus__oprincomingreceiptstatus_id", "field_value": null}
          ]),
          'sorter': jsonEncode([
            {"field_name": "oprincomingreceipt_date", "sort": "DESC"},
            {"field_name": "oprincomingreceipt_number", "sort": "DESC"}
          ]),
          'grouper': jsonEncode([]),
          'flyoversearch': jsonEncode([]),
          'page': '1',
          'start': '0',
          'limit': '1',
        },
        options: Options(
          headers: {
            'Cookie': "siklonsession=$token",
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        ),
      );

      print(response_fetch_data.data);
      print(response_fetch_data.headers);

      if (response.statusCode == 200) {
        context.router.push(const HomeRoute());
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: ${response.data}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
              ),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: const Text('Login'),
            ),
            TextButton(
              onPressed: () {
                context.router.push(const ForgotPasswordRoute());
              },
              child: const Text('Forgot Password?'),
            ),
          ],
        ),
      ),
    );
  }
}

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: const Center(
        child: Text('Welcome to the Home Page!'),
      ),
    );
  }
}

@RoutePage()
class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
      ),
      body: const Center(
        child: Text('Forgot Password Page'),
      ),
    );
  }
}
