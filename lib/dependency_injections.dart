import 'package:blutut_clasic/core/services/hive_service.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/services/shared_preferences_service.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/remote/remote_auth_provider.dart';
import 'data/remote/remote_receipt_provider.dart';
import 'data/repositories/receipt_repository_impl.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/repositories/receipt_repository.dart';
import 'domain/usecases/auth_usecases.dart';
import 'domain/usecases/receipt_fetch_usecase.dart';
import 'presentation/auth/cubit/auth_cubit.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependency() async {
  final sharedPreferences = await SharedPreferences.getInstance();

  serviceLocator
    ..registerLazySingleton(() => Dio())
    ..registerLazySingleton(() => SharedPreferencesService(sharedPreferences))
    ..registerLazySingleton<RemoteAuthProvider>(
      () => RemoteAuthProvider(dio: serviceLocator<Dio>()),
    )
    ..registerLazySingleton<RemoteReceiptProvider>(
      () => RemoteReceiptProvider(dio: serviceLocator<Dio>()),
    )
    ..registerLazySingleton(() => AuthCubit(
        serviceLocator<SharedPreferencesService>(),
        serviceLocator<LoginUsecase>()))
    ..registerLazySingleton(() => HiveService());

  serviceLocator
    ..registerFactory<AuthRepository>(() => AuthRepositoryImpl(
        remoteAuthProvider: serviceLocator<RemoteAuthProvider>()))
    ..registerFactory<ReceiptRepository>(() => ReceiptRepositoryImpl(
        remoteReceiptProvider: serviceLocator<RemoteReceiptProvider>()))
    ..registerFactory<ReceiptFetchUsecase>(
        () => ReceiptFetchUsecase(receiptRepository: serviceLocator()))
    ..registerFactory(() => LoginUsecase(serviceLocator<AuthRepository>()));
  // ..registerFactory<UserFetchdataUsecase>(() => UserFetchdataUsecase(userRepository: serviceLocator()))
}
