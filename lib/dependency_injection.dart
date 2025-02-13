import 'package:blutut_clasic/core/services/shared_preferences_service.dart';
import 'package:blutut_clasic/data/repositories/auth_repository_impl.dart';
import 'package:blutut_clasic/domain/repositories/auth_repository.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependency() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  serviceLocator
    ..registerLazySingleton(Dio.new)
    ..registerLazySingleton(() => SharedPreferencesService(sharedPreferences))
    ..registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());
}
