import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/router/app_router.dart';
import 'dependency_injections.dart';
import 'presentation/auth/cubit/auth_cubit.dart';
import 'presentation/home/bloc/receipt_bloc.dart';
import 'presentation/profile/cubit/profile_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependency();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
        providers: [
          BlocProvider<AuthCubit>(
            create: (context) => serviceLocator<AuthCubit>(),
          ),
          BlocProvider(
            create: (context) => ReceiptBloc(
              receiptFetchUsecase: serviceLocator(),
              hiveService: serviceLocator(),
            ),
          ),
          BlocProvider<ProfileCubit>(
            create: (context) => serviceLocator<ProfileCubit>(),
          ),
        ],
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: _appRouter.config(),
        ),
      );
}
