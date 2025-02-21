import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/router/app_router.gr.dart';
import '../../../core/services/shared_preferences_service.dart';
import '../../../dependency_injections.dart';
import '../../../domain/entities/login_request_entity.dart';
import '../../data_list/bloc/receipt_bloc.dart';
import '../../receipt/bloc/cubit/data_provider_cubit.dart';
import '../cubit/auth_cubit.dart';

@RoutePage()
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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

  Future<void> _login(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      String username = _emailController.text;
      String password = _passwordController.text;

      await context.read<AuthCubit>().login(
            LoginRequestEntity(
              username: username,
              password: password,
              rememberMe: 0,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) => BlocListener<AuthCubit, AuthState>(
        listener: (context, state) async {
          if (state is AuthLoaded) {
            context.read<ReceiptBloc>().add(
                  FetchOprIncomingReceipts(
                    serviceLocator<SharedPreferencesService>()
                        .getString('cookie')!,
                  ),
                );
            if (context.mounted) {
              await context.router.replace(const DataListRoute());
            }
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
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
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: _inputTextStyle,
                      decoration: InputDecoration(
                        hintText: 'Enter your email',
                        hintStyle: _hintTextStyle,
                        contentPadding: _inputContentPadding,
                        enabledBorder: _underlineInputBorder,
                        focusedBorder: _outlineInputBorder,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      style: _inputTextStyle,
                      decoration: InputDecoration(
                        hintText: 'Enter your password',
                        hintStyle: _hintTextStyle,
                        contentPadding: _inputContentPadding,
                        enabledBorder: _underlineInputBorder,
                        focusedBorder: _outlineInputBorder,
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
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
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
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async => _login(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(29, 79, 215, 1),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Login now',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildDontHaveAccountRow(),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

  static const TextStyle _inputTextStyle = TextStyle(
    fontSize: 14,
    color: Colors.black87,
  );

  static const TextStyle _hintTextStyle = TextStyle(
    fontSize: 14,
    color: Color.fromRGBO(153, 153, 153, 1),
    fontWeight: FontWeight.w400,
  );

  static const EdgeInsets _inputContentPadding = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 12,
  );

  static final UnderlineInputBorder _underlineInputBorder =
      UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.grey[300]!),
  );

  static final OutlineInputBorder _outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
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

  Widget _buildDontHaveAccountRow() => Row(
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
            onPressed: () {},
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
      );
}
