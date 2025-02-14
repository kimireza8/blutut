import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/router/app_router.dart';
import 'core/services/hive_service.dart';
import 'core/services/shared_preferences_service.dart';
import 'dependency_injections.dart';
import 'domain/usecases/auth_usecases.dart';
import 'domain/usecases/user_fetchdata_usecase.dart'; // Import UserFetchDataUsecase
import 'presentation/auth/cubit/auth_cubit.dart';
import 'presentation/home/bloc/receipt_bloc.dart';
import 'presentation/profile/cubit/profile_cubit.dart'; // Import ProfileCubit

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependency();
  await HiveService().init();
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
            serviceLocator<AuthUsecase>(),
          ),
        ),
        BlocProvider(
          create: (context) =>
              ReceiptBloc(receiptFetchUsecase: serviceLocator()),
        ),
        BlocProvider<ProfileCubit>( // Add ProfileCubit Provider
          create: (context) => ProfileCubit(
            userFetchDataUsecase: serviceLocator<UserFetchDataUsecase>(),
          ),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: _appRouter.config(),
      ),
    );
  }
}
