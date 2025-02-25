import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/constant.dart';
import '../../../core/router/app_router.gr.dart';
import '../../../domain/entities/auth/login_request_entity.dart';
import '../cubit/auth_cubit.dart';

@RoutePage()
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Login failed: ${state.message}')),
            );
          } else if (state is AuthLoaded) {
            context.router.replace(const ReceiptRoute());
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 48),
                    _buildLoginLogo(),
                    const SizedBox(height: 32),
                    _buildWelcomeText(),
                    const SizedBox(height: 24),
                    _buildEmailField(),
                    const SizedBox(height: 16),
                    _buildPasswordField(),
                    const SizedBox(height: 8),
                    _buildForgotPasswordButton(),
                    const SizedBox(height: 24),
                    _buildLoginButton(),
                    const SizedBox(height: 24),
                    _buildDontHaveAccountRow(),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

  Widget _buildEmailField() => BlocBuilder<AuthCubit, AuthState>(
        buildWhen: (previous, current) => current is AuthError,
        builder: (context, state) => TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          style: Constant.inputTextStyle,
          enabled: state is! AuthLoading,
          decoration: InputDecoration(
            hintText: 'Enter your email',
            hintStyle: Constant.hintTextStyle,
            contentPadding: Constant.inputContentPadding,
            enabledBorder: Constant.underlineInputBorder,
            focusedBorder: Constant.outlineInputBorder,
            errorText: state is AuthError ? state.message : null,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            return null;
          },
        ),
      );

  Widget _buildPasswordField() => BlocBuilder<AuthCubit, AuthState>(
        buildWhen: (previous, current) => current is AuthError,
        builder: (context, state) => TextFormField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          style: Constant.inputTextStyle,
          enabled: state is! AuthLoading,
          decoration: InputDecoration(
            hintText: 'Enter your password',
            hintStyle: Constant.hintTextStyle,
            contentPadding: Constant.inputContentPadding,
            enabledBorder: Constant.underlineInputBorder,
            focusedBorder: Constant.outlineInputBorder,
            errorText: state is AuthError ? state.message : null,
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: Colors.grey[400],
                size: 20,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your password';
            }
            return null;
          },
        ),
      );

  Widget _buildLoginButton() => BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) => SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: state is AuthLoading
                ? null
                : () async {
                    if (_formKey.currentState!.validate()) {
                      await context.read<AuthCubit>().login(
                            LoginRequestEntity(
                              username: _emailController.text,
                              password: _passwordController.text,
                              rememberMe: 0,
                            ),
                          );
                    }
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(29, 79, 215, 1),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32),
              ),
              elevation: 0,
            ),
            child: state is AuthLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(color: Colors.white),
                  )
                : const Text(
                    'Login now',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
      );

  Widget _buildForgotPasswordButton() => BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) => Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: state is! AuthLoading ? () {} : null,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text(
              'Forgot Password',
              style: TextStyle(
                fontSize: 14,
                color: Color.fromRGBO(29, 79, 215, 1),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      );

  Widget _buildLoginLogo() => Column(
        children: [
          Image.asset(
            'assets/login_logo.png',
            height: 48,
          ),
          const SizedBox(height: 12),
          const Text(
            'MATRANS',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const Text(
            'PT. Makassar Trans',
            style: TextStyle(
              fontSize: 16.75,
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      );

  Widget _buildWelcomeText() => const Align(
        alignment: Alignment.topLeft,
        child: Text(
          textAlign: TextAlign.left,
          'Welcome back! Please enter your details.',
          style: TextStyle(
            fontSize: 14,
            color: Color.fromRGBO(155, 155, 155, 1),
            fontWeight: FontWeight.w600,
          ),
        ),
      );

  Widget _buildDontHaveAccountRow() => BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Don't have an account? ",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            TextButton(
              onPressed: state is! AuthLoading ? () {} : null,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                'Sign up',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF246BFD),
                ),
              ),
            ),
          ],
        ),
      );
}
