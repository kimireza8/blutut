import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/services/auth_interceptor.dart';
import 'core/services/hive_service.dart';
import 'core/services/shared_preferences_service.dart';
import 'data/remote/auth/remote_auth_provider.dart';
import 'data/remote/input_data/remote_city_provider.dart';
import 'data/remote/input_data/remote_service_type_provider.dart';
import 'data/remote/input_data/remote_oprroute_provider.dart';
import 'data/remote/input_data/remote_organization_provider.dart';
import 'data/remote/input_data/remote_relation_provider.dart';
import 'data/remote/receipt/remote_receipt_provider.dart';
import 'data/remote/user/remote_user_provider.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/input_data_repository_impl.dart';
import 'data/repositories/receipt_repository_impl.dart';
import 'data/repositories/user_repository_impl.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/repositories/input_data_repository.dart';
import 'domain/repositories/receipt_repository.dart';
import 'domain/repositories/user_repository.dart';
import 'domain/usecases/auth/login_usecase.dart';
import 'domain/usecases/auth/logout_usecase.dart';
import 'domain/usecases/input_data/city_fetch_usecase.dart';
import 'domain/usecases/input_data/service_type_fetch_usecase.dart';
import 'domain/usecases/input_data/organization_fetch_usecase.dart';
import 'domain/usecases/input_data/relation_fetch_usecase.dart';
import 'domain/usecases/input_data/route_fetch_usecase.dart';
import 'domain/usecases/receipt/receipt_create_usecase.dart';
import 'domain/usecases/receipt/receipt_detail_usecase.dart';
import 'domain/usecases/receipt/receipt_fetch_usecase.dart';
import 'domain/usecases/user/user_fetch_usecase.dart';

final serviceLocator = GetIt.instance;

const _apiTimeouts = (
  connect: Duration(milliseconds: 30000),
  receive: Duration(milliseconds: 30000),
);

Future<void> initializeDependencies() async {
  try {
    await _initializeNetwork();
    await _initializeStorage();
    _initializeProviders();
    _initializeRepositories();
    _initializeUsecases();
  } catch (e) {
    throw DependencyInitializationException(
      'Failed to initialize dependencies: $e',
    );
  }
}

Future<Dio> _configureApiClient() async => Dio(
      BaseOptions(
        connectTimeout: _apiTimeouts.connect,
        receiveTimeout: _apiTimeouts.receive,
      ),
    );

Future<void> _initializeNetwork() async {
  Dio dio = await _configureApiClient();
  var authInterceptor = AuthInterceptor();
  dio.interceptors.add(authInterceptor);

  serviceLocator
    ..registerLazySingleton(() => dio)
    ..registerLazySingleton(() => authInterceptor);
}

Future<void> _initializeStorage() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  serviceLocator
    ..registerLazySingleton(() => SharedPreferencesService(prefs))
    ..registerLazySingleton(HiveService.new);
}

void _initializeProviders() {
  serviceLocator
    ..registerFactory<RemoteAuthProvider>(
      () => RemoteAuthProvider(
        dio: serviceLocator<Dio>(),
        sharedPreferencesService: serviceLocator<SharedPreferencesService>(),
      ),
    )
    ..registerFactory<RemoteReceiptProvider>(
      () => RemoteReceiptProvider(dio: serviceLocator<Dio>()),
    )
    ..registerFactory<RemoteUserProvider>(
      () => RemoteUserProvider(
        dio: serviceLocator<Dio>(),
        sharedPreferencesService: serviceLocator<SharedPreferencesService>(),
      ),
    )
    ..registerFactory<RemoteRelationProvider>(
      () => RemoteRelationProvider(dio: serviceLocator<Dio>()),
    )
    ..registerFactory<RemoteOperationalRouteProvider>(
      () => RemoteOperationalRouteProvider(dio: serviceLocator<Dio>()),
    )
    ..registerFactory<RemoteCityProvider>(
      () => RemoteCityProvider(dio: serviceLocator<Dio>()),
    )
    ..registerFactory<RemoteOrganizationProvider>(
      () => RemoteOrganizationProvider(dio: serviceLocator<Dio>()),
    )
    ..registerFactory<RemoteServiceTypeProvider>(
      () => RemoteServiceTypeProvider(dio: serviceLocator<Dio>()),
    );
}

void _initializeRepositories() {
  serviceLocator
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(
        remoteAuthProvider: serviceLocator<RemoteAuthProvider>(),
      ),
    )
    ..registerLazySingleton<ReceiptRepository>(
      () => ReceiptRepositoryImpl(
        remoteReceiptProvider: serviceLocator<RemoteReceiptProvider>(),
      ),
    )
    ..registerLazySingleton<UserRepository>(
      () => UserRepositoryImpl(
        remoteUserProvider: serviceLocator<RemoteUserProvider>(),
      ),
    )
    ..registerLazySingleton<InputDataRepository>(
      () => InputDataRepositoryImpl(
        remoteRelationProvider: serviceLocator<RemoteRelationProvider>(),
        remoteRouteProvider: serviceLocator<RemoteOperationalRouteProvider>(),
        remoteOrganizationProvider:
            serviceLocator<RemoteOrganizationProvider>(),
        remoteCityProvider: serviceLocator<RemoteCityProvider>(),
        remoteServiceTypeProvider:
            serviceLocator<RemoteServiceTypeProvider>(),
      ),
    );
}

void _initializeUsecases() {
  serviceLocator
    ..registerLazySingleton<LoginUsecase>(
      () => LoginUsecase(
        serviceLocator<AuthRepository>(),
      ),
    )
    ..registerLazySingleton<LogoutUsecase>(
      () => LogoutUsecase(
        serviceLocator<AuthRepository>(),
      ),
    )
    ..registerLazySingleton<UserFetchUseCase>(
      () => UserFetchUseCase(
        serviceLocator<UserRepository>(),
      ),
    )
    ..registerLazySingleton<ReceiptDetailUsecase>(
      () => ReceiptDetailUsecase(
        serviceLocator<ReceiptRepository>(),
      ),
    )
    ..registerLazySingleton<ReceiptFetchUsecase>(
      () => ReceiptFetchUsecase(
        serviceLocator<ReceiptRepository>(),
      ),
    )
    ..registerLazySingleton(
      () => ReceiptCreateUsecase(
        serviceLocator<ReceiptRepository>(),
      ),
    )
    ..registerLazySingleton(
      () => CityFetchUsecase(
        serviceLocator<InputDataRepository>(),
      ),
    )
    ..registerLazySingleton(
      () => RelationFetchUsecase(
        serviceLocator<InputDataRepository>(),
      ),
    )
    ..registerLazySingleton(
      () => RouteFetchUsecase(
        serviceLocator<InputDataRepository>(),
      ),
    )
    ..registerLazySingleton(
      () => OrganizationFetchUsecase(
        serviceLocator<InputDataRepository>(),
      ),
    )
    ..registerLazySingleton(
      () => ServiceTypeFetchUsecase(
        serviceLocator<InputDataRepository>(),
      ),
    );
}

Future<void> resetDependencies() async {
  await serviceLocator.reset();
}

class DependencyInitializationException implements Exception {
  DependencyInitializationException(this.message);
  final String message;

  @override
  String toString() => message;
}
