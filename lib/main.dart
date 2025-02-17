import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/router/app_router.dart';
import 'core/services/hive_service.dart';
import 'core/services/shared_preferences_service.dart';
import 'dependency_injections.dart';
import 'domain/usecases/auth_usecases.dart';
import 'domain/usecases/user_fetchdata_usecase.dart';
import 'presentation/auth/cubit/auth_cubit.dart';
import 'presentation/home/bloc/receipt_bloc.dart';
import 'presentation/home/print_cubit/print_cubit.dart';
import 'presentation/profile/cubit/profile_cubit.dart';

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
  Widget build(BuildContext context) => MultiBlocProvider(
        providers: [
          BlocProvider<AuthCubit>(
            create: (context) => AuthCubit(
              serviceLocator<SharedPreferencesService>(),
              serviceLocator<AuthUsecase>(),
            ),
          ),
          BlocProvider(
            create: (context) => ReceiptBloc(
                receiptFetchUsecase: serviceLocator(),
                hiveService: serviceLocator<HiveService>()),
          ),
          BlocProvider<ProfileCubit>(
            create: (context) => ProfileCubit(
              userFetchDataUsecase: serviceLocator<UserFetchDataUsecase>(),
            ),
          ),
          BlocProvider<PrintCubit>(
            create: (context) => PrintCubit()..initBluetooth(),
          ),
        ],
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: _appRouter.config(),
        ),
      );
}
