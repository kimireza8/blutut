import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/services/auth_interceptor.dart';
import 'core/services/hive_service.dart';
import 'core/services/shared_preferences_service.dart';
import 'data/remote/remote_auth_provider.dart';
import 'data/remote/remote_receipt_provider.dart';
import 'data/remote/remote_user_provider.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/receipt_repository_impl.dart';
import 'data/repositories/user_repository_impl.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/repositories/receipt_repository.dart';
import 'domain/repositories/user_repository.dart';
import 'domain/usecases/auth_usecases.dart';
import 'domain/usecases/receipt_fetch_usecase.dart';
import 'domain/usecases/user_fetchdata_usecase.dart';
import 'presentation/auth/cubit/auth_cubit.dart';
import 'presentation/home/bloc/receipt_bloc.dart';
import 'presentation/profile/cubit/profile_cubit.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependency() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  _registerServices(sharedPreferences);
  _registerRemoteProviders();
  _registerRepositories();
  _registerUseCases();
  _registerCubits();
}

void _registerServices(SharedPreferences sharedPreferences) {
  serviceLocator
    ..registerLazySingleton(() => SharedPreferencesService(sharedPreferences))
    ..registerLazySingleton(HiveService.new)
    ..registerLazySingleton(AuthInterceptor.new)
    ..registerLazySingleton(
      () => Dio()..interceptors.add(serviceLocator<AuthInterceptor>()),
    );
}

void _registerRemoteProviders() {
  serviceLocator
    ..registerLazySingleton<RemoteAuthProvider>(
      () => RemoteAuthProvider(
        dio: serviceLocator<Dio>(),
        sharedPreferencesService: serviceLocator<SharedPreferencesService>(),
      ),
    )
    ..registerLazySingleton<RemoteReceiptProvider>(
      () => RemoteReceiptProvider(dio: serviceLocator<Dio>()),
    )
    ..registerLazySingleton<RemoteUserProvider>(
      () => RemoteUserProvider(
        dio: serviceLocator<Dio>(),
        sharedPreferencesService: serviceLocator<SharedPreferencesService>(),
      ),
    );
}

void _registerRepositories() {
  serviceLocator
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(
        remoteAuthProvider: serviceLocator<RemoteAuthProvider>(),
      ),
    )
    ..registerFactory<ReceiptRepository>(
      () => ReceiptRepositoryImpl(
        remoteReceiptProvider: serviceLocator<RemoteReceiptProvider>(),
      ),
    )
    ..registerFactory<UserRepository>(
      () => UserRepositoryImpl(
        remoteUserProvider: serviceLocator<RemoteUserProvider>(),
      ),
    );
}

void _registerUseCases() {
  serviceLocator
    ..registerFactory<AuthUsecase>(
      () => AuthUsecase(serviceLocator<AuthRepository>()),
    )
    ..registerFactory<ReceiptFetchUsecase>(
      () => ReceiptFetchUsecase(
        receiptRepository: serviceLocator<ReceiptRepository>(),
      ),
    )
    ..registerFactory<UserFetchDataUsecase>(
      () => UserFetchDataUsecase(serviceLocator<UserRepository>()),
    );
}

void _registerCubits() {
  serviceLocator
    ..registerFactory(
      () => AuthCubit(
        serviceLocator<SharedPreferencesService>(),
        serviceLocator<AuthUsecase>(),
      ),
    )
    ..registerLazySingleton(
      () => ReceiptBloc(
        receiptFetchUsecase: serviceLocator<ReceiptFetchUsecase>(),
        hiveService: serviceLocator<HiveService>(),
      ),
    )
    ..registerFactory(
      () => ProfileCubit(
        userFetchDataUsecase: serviceLocator<UserFetchDataUsecase>(),
      ),
    );
}
