import 'package:blutut_clasic/core/services/shared_preferences_service.dart';
import 'package:blutut_clasic/data/remote/remote_auth_provider.dart';
import 'package:blutut_clasic/data/remote/remote_receipt_provider.dart';
import 'package:blutut_clasic/data/repositories/receipt_repository_impl.dart';
import 'package:blutut_clasic/domain/usecase/receipt_fetch_usecase.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/repositories/user_repository_impl.dart';
import 'domain/repositories/user_repository.dart';
import 'domain/repositories/receipt_repository.dart';
import 'domain/usecase/user_fetchdata_usecase.dart';
import 'domain/usecase/user_login_usecase.dart';

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
    );
  serviceLocator
  ..registerFactory<UserRepository>(() => UserRepositoryImpl(remoteAuthProvider: serviceLocator<RemoteAuthProvider>()))
  ..registerFactory<ReceiptRepository>(() => ReceiptRepositoryImpl(remoteReceiptProvider: serviceLocator<RemoteReceiptProvider>()));

  serviceLocator
  ..registerFactory<UserLoginUsecase>(() => UserLoginUsecase(userRepository: serviceLocator()))
  ..registerFactory<UserFetchdataUsecase>(() => UserFetchdataUsecase(userRepository: serviceLocator()))
  ..registerFactory<ReceiptFetchUsecase>(() => ReceiptFetchUsecase(receiptRepository: serviceLocator()));


}
