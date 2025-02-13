import 'package:blutut_clasic/presentation/home/bloc/receipt_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/router/app_router.dart';
import 'injection.dart';
import 'presentation/auth/cubit/auth_cubit.dart';
import 'core/services/shared_preferences_service.dart';
import 'domain/usecases/auth_usecases.dart';

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
        BlocProvider<AuthCubit>(
          create: (context) => AuthCubit(
            serviceLocator<SharedPreferencesService>(),
            serviceLocator<LoginUsecase>(),
          ),
        ),
        BlocProvider(
          create: (context) =>
              ReceiptBloc(receiptFetchUsecase: serviceLocator()),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: _appRouter.config(),
      ),
    );
  }
}
