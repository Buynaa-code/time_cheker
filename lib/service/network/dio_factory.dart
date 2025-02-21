import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:time_cheker/service/app/app.dart';

const String applicationJson = "application/json";
const String contentType = "content-type";
const String accept = "accept";
const String authorization = "authorization";
const String defaultLanguage = "language";

class DioFactory {
  Dio dio = Dio();
  String token = '';

  DioFactory(this.token);

  void setToken(String newToken) {
    token = newToken;
  }

  Future<Dio> getDio() async {
    Map<String, String> headers = {
      contentType: applicationJson,
      accept: applicationJson,
      defaultLanguage: "en"
    };

    dio.options = BaseOptions(baseUrl: MyApp.url, headers: headers);

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        if (token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
    ));

    if (!kReleaseMode) {
      dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
      ));
    }

    // if (!kReleaseMode) {
    //   dio.interceptors.add(dioLoggerInterceptor);
    // }

    return dio;
  }
}
