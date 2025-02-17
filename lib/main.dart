import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/router/app_router.dart';
import 'dependency_injections.dart';
import 'presentation/auth/cubit/auth_cubit.dart';
import 'presentation/home/bloc/receipt_bloc.dart';
import 'presentation/profile/cubit/profile_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependency();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    var appRouter = AppRouter();
    return MultiBlocProvider(
      providers: _getBlocProviders(context),
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: appRouter.config(),
      ),
    );
  }

  List<BlocProvider> _getBlocProviders(BuildContext context) => [
      BlocProvider<AuthCubit>(
        create: (context) => serviceLocator<AuthCubit>(),
      ),
      BlocProvider<ReceiptBloc>(
        create: (context) => serviceLocator<ReceiptBloc>(),
      ),
      BlocProvider<ProfileCubit>(
        create: (context) => serviceLocator<ProfileCubit>(),
      ),
    ];
}
