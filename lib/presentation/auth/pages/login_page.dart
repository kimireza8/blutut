import 'package:auto_route/auto_route.dart';
import 'package:blutut_clasic/core/router/app_router.gr.dart';
import 'package:blutut_clasic/domain/entities/login_request_entity.dart';
import 'package:blutut_clasic/presentation/auth/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final username = _usernameController.text;
      final password = _passwordController.text;

      try {
        await context.read<AuthCubit>().login(
              LoginRequestEntity(
                  username: username,
                  password: password,
                  rememberMe: _rememberMe ? 1 : 0),
            );
        if (context.mounted) {
          context.router.push(const HomeRoute());
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/login_background.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Card(
              margin: const EdgeInsets.all(32.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: _buildLoginForm(context),
              ),
            ),
          ),
        ),
      );

  Widget _buildLoginForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildLoginText(),
          const SizedBox(height: 20),
          _buildLogo(),
          const SizedBox(height: 32),
          _buildUsernameTextField(),
          const SizedBox(height: 16),
          _buildPasswordTextField(),
          const SizedBox(height: 16),
          _buildRememberMeCheckbox(),
          const SizedBox(height: 24),
          _buildLoginButton(context),
          _buildForgotPasswordButton(),
        ],
      ),
    );
  }

  Widget _buildLoginText() {
    return const Align(
      alignment: Alignment.topLeft,
      child: Text(
        'LOGIN',
        style: TextStyle(
          color: Colors.blue,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Image.asset(
      'assets/login_logo.png',
      height: 60,
    );
  }

  Widget _buildUsernameTextField() {
    return TextFormField(
      controller: _usernameController,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.person, color: Colors.grey),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.blue),
        ),
        fillColor: Colors.white,
        filled: true,
      ),
      validator: (value) =>
          value == null || value.isEmpty ? 'Enter username' : null,
    );
  }

  Widget _buildPasswordTextField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: true,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.lock, color: Colors.grey),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.blue),
        ),
        fillColor: Colors.white,
        filled: true,
      ),
      validator: (value) =>
          value == null || value.isEmpty ? 'Enter password' : null,
    );
  }

  Widget _buildRememberMeCheckbox() {
    return Row(
      children: [
        Switch(
          value: _rememberMe,
          onChanged: (value) {
            setState(() {
              _rememberMe = value;
            });
          },
          activeColor: Colors.blue,
        ),
        const Text(
          'Remember me',
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _login(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: const Text(
        'Login',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildForgotPasswordButton() {
    return TextButton(
      onPressed: () {},
      child: const Text(
        'Forgot Password',
        style: TextStyle(color: Colors.grey),
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
