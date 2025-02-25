import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/router/app_router.dart';
import 'core/services/hive_service.dart';
import 'dependency_injections.dart';
import 'presentation/auth/cubit/auth_cubit.dart';
import 'presentation/input/cubit/input_cubit.dart';
import 'presentation/print/cubit/print_cubit.dart';
import 'presentation/profile/cubit/profile_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDependencies();
  await HiveService().init();
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
          create: (context) => AuthCubit.create(),
        ),
        BlocProvider<InputCubit>(
          create: (context) => InputCubit.create(),
        ),
        BlocProvider<PrintCubit>(
          create: (context) => PrintCubit()..initBluetooth(),
        ),
      ];
}
