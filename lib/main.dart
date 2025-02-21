import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/router/app_router.dart';
import 'core/services/hive_service.dart';
import 'dependency_injections.dart';
import 'domain/usecases/city_fetch_usecase.dart';
import 'domain/usecases/oprroute_fetch_usecase.dart';
import 'domain/usecases/organization_fetch_usecase.dart';
import 'domain/usecases/relation_fetch_usecase.dart';
import 'presentation/auth/cubit/auth_cubit.dart';
import 'presentation/data_list/bloc/receipt_bloc.dart';
import 'presentation/detail_data_list/cubit/detail_data_list_cubit.dart';
import 'presentation/home/print_cubit/print_cubit.dart';
import 'presentation/profile/cubit/profile_cubit.dart';
import 'presentation/receipt/bloc/cubit/data_provider_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependency();
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
          create: (context) => serviceLocator<AuthCubit>(),
        ),
        BlocProvider<ReceiptBloc>(
          create: (context) => serviceLocator<ReceiptBloc>(),
        ),
        BlocProvider<ProfileCubit>(
          create: (context) => serviceLocator<ProfileCubit>(),
        ),
        BlocProvider<DetailDataListCubit>(
          create: (context) => serviceLocator<DetailDataListCubit>(),
        ),
        BlocProvider<PrintCubit>(
          create: (context) => PrintCubit()..initBluetooth(),
        ),
        BlocProvider<DataProviderCubit>(
          create: (context) => DataProviderCubit(
            relationFetchUsecase: serviceLocator<RelationFetchUsecase>(),
            oprrouteFetchUsecase: serviceLocator<OprrouteFetchUsecase>(),
            organizationFetchUsecase:
                serviceLocator<OrganizationFetchUsecase>(),
            cityFetchUsecase: serviceLocator<CityFetchUsecase>(),
          ),
        ),
      ];
}
