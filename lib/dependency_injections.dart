import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/services/auth_interceptor.dart';
import 'core/services/hive_service.dart';
import 'core/services/shared_preferences_service.dart';
import 'data/remote/remote_auth_provider.dart';
import 'data/remote/remote_city_provider.dart';
import 'data/remote/remote_oprroute_provider.dart';
import 'data/remote/remote_organization_provider.dart';
import 'data/remote/remote_receipt_provider.dart';
import 'data/remote/remote_relation_provider.dart';
import 'data/remote/remote_user_provider.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/data_repository_impl.dart';
import 'data/repositories/receipt_repository_impl.dart';
import 'data/repositories/user_repository_impl.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/repositories/data_repository.dart';
import 'domain/repositories/receipt_repository.dart';
import 'domain/repositories/user_repository.dart';
import 'domain/usecases/city_fetch_usecase.dart';
import 'domain/usecases/login_usecase.dart';
import 'domain/usecases/logout_usecase.dart';
import 'domain/usecases/oprroute_fetch_usecase.dart';
import 'domain/usecases/organization_fetch_usecase.dart';
import 'domain/usecases/receipt_detail_usecase.dart';
import 'domain/usecases/receipt_fetch_usecase.dart';
import 'domain/usecases/relation_fetch_usecase.dart';
import 'domain/usecases/user_fetch_usecase.dart';
import 'presentation/auth/cubit/auth_cubit.dart';
import 'presentation/data_list/bloc/receipt_bloc.dart';
import 'presentation/detail_data_list/cubit/detail_data_list_cubit.dart';
import 'presentation/home/print_cubit/print_cubit.dart';
import 'presentation/profile/cubit/profile_cubit.dart';
import 'presentation/receipt/bloc/cubit/data_provider_cubit.dart';

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
    )
    ..registerLazySingleton<RemoteRelationProvider>(
      () => RemoteRelationProvider(dio: serviceLocator<Dio>()),
    )
    ..registerLazySingleton<RemoteOprRouteProvider>(
      () => RemoteOprRouteProvider(dio: serviceLocator<Dio>()),
    )
    ..registerLazySingleton<RemoteCityProvider>(
      () => RemoteCityProvider(dio: serviceLocator<Dio>()),
    )
    ..registerLazySingleton<RemoteOrganizationProvider>(
      () => RemoteOrganizationProvider(dio: serviceLocator<Dio>()),
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
    )
    ..registerFactory<DataRepository>(
      () => DataRepositoryImpl(
        remoteRelationProvide: serviceLocator<RemoteRelationProvider>(),
        remoteRouteProvider: serviceLocator<RemoteOprRouteProvider>(),
        remoteOrganizationProvider:
            serviceLocator<RemoteOrganizationProvider>(),
        remoteCityProvider: serviceLocator<RemoteCityProvider>(),
      ),
    );
}

void _registerUseCases() {
  serviceLocator
    ..registerFactory<LoginUsecase>(
      () => LoginUsecase(serviceLocator<AuthRepository>()),
    )
    ..registerFactory<LogoutUsecase>(
      () => LogoutUsecase(serviceLocator<AuthRepository>()),
    )
    ..registerFactory<ReceiptFetchUsecase>(
      () => ReceiptFetchUsecase(
        receiptRepository: serviceLocator<ReceiptRepository>(),
      ),
    )
    ..registerFactory<ReceiptDetailUsecase>(
      () => ReceiptDetailUsecase(
        receiptRepository: serviceLocator<ReceiptRepository>(),
      ),
    )
    ..registerFactory<UserFetchUseCase>(
      () => UserFetchUseCase(serviceLocator<UserRepository>()),
    )
    ..registerFactory<OprrouteFetchUsecase>(
      () => OprrouteFetchUsecase(
        dataRepository: serviceLocator<DataRepository>(),
      ),
    )
    ..registerFactory<RelationFetchUsecase>(
      () => RelationFetchUsecase(
        dataRepository: serviceLocator<DataRepository>(),
      ),
    )
    ..registerFactory<CityFetchUsecase>(
      () => CityFetchUsecase(
        dataRepository: serviceLocator<DataRepository>(),
      ),
    )
    ..registerFactory<OrganizationFetchUsecase>(
      () => OrganizationFetchUsecase(
        dataRepository: serviceLocator<DataRepository>(),
      ),
    );
}

void _registerCubits() {
  serviceLocator
    ..registerFactory(
      () => AuthCubit(
        serviceLocator<SharedPreferencesService>(),
        serviceLocator<LoginUsecase>(),
        serviceLocator<LogoutUsecase>(),
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
        userFetchDataUsecase: serviceLocator<UserFetchUseCase>(),
      ),
    )
    ..registerFactory(
      () => DetailDataListCubit(
        serviceLocator<ReceiptDetailUsecase>(),
        serviceLocator<SharedPreferencesService>(),
      ),
    )
    ..registerFactory(PrintCubit.new)
    ..registerFactory(
      () => DataProviderCubit(
        relationFetchUsecase: serviceLocator<RelationFetchUsecase>(),
        oprrouteFetchUsecase: serviceLocator<OprrouteFetchUsecase>(),
        organizationFetchUsecase: serviceLocator<OrganizationFetchUsecase>(),
        cityFetchUsecase: serviceLocator<CityFetchUsecase>(),
      ),
    );
}
