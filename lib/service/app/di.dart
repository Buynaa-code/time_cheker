import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

// ignore: depend_on_referenced_packages
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_cheker/components/constant.dart';
import 'package:time_cheker/service/network/api_service.dart';
import 'package:time_cheker/service/network/dio_factory.dart';
import 'package:time_cheker/service/network/netword_info.dart';
import 'package:time_cheker/service/repository/auth_repository.dart';
import 'package:time_cheker/service/repository/repository.dart';

import 'app_prefs.dart';

final instance = GetIt.instance;

Future<void> initAppModule() async {
  // SharedPreferences instance
  final sharedPreferences = await SharedPreferences.getInstance();
  instance.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // AppPreferences instance
  instance
      .registerLazySingleton<AppPreferences>(() => AppPreferences(instance()));

  //NetworkInfo instance
  instance.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(InternetConnectionChecker.createInstance()));
  // FlutterSecureStorage instance бүртгэх
  instance.registerLazySingleton<FlutterSecureStorage>(
      () => const FlutterSecureStorage(aOptions: Constants.androidOptions));

  // FlutterSecureStorage-ээс токен унших
  final FlutterSecureStorage storage = instance<FlutterSecureStorage>();
  final token =
      await storage.read(key: 'token', aOptions: Constants.androidOptions);

  // DioFactory instance
  instance.registerLazySingleton<DioFactory>(() => DioFactory(token ?? ''));

  final dio = await instance<DioFactory>().getDio();

  // AppServiceClient instance
  instance.registerLazySingleton(() => ApiService(dio));

  // Repository бүртгэх
  instance.registerFactory<Repository>(
      () => RepositoryImpl(instance(), instance()));
}
