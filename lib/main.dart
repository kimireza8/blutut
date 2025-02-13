
import 'package:blutut_clasic/presentation/auth/bloc/auth_bloc_bloc.dart';
import 'package:blutut_clasic/presentation/auth/pages/login_page.dart';
import 'package:blutut_clasic/presentation/home/bloc/receipt_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/router/app_router.dart';
import 'injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependency();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _appRouter = AppRouter();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ReceiptBloc(receiptFetchUsecase: serviceLocator()),
        ),
        BlocProvider(
          create: (context) => AuthBloc(userLoginUsecase: serviceLocator(), userFetchdataUsecase: serviceLocator()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LoginPage(),
      ),
    );
  }
}
