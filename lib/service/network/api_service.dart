import 'package:dio/dio.dart';
import 'package:time_cheker/service/app/app.dart';

class ApiService {
  final Dio _dio;

  ApiService(this._dio);

  Future<Response> get(
      {required String endPoint,
      dynamic data,
      Map<String, dynamic>? params,
      Map<String, String>? queryParameters}) async {
    var response = await _dio.get('${MyApp.url}$endPoint',
        data: data, queryParameters: queryParameters ?? params);
    return response;
  }

  Future<Response> post(
      {required String endPoint, dynamic data, dynamic params}) async {
    var response = await _dio.post('${MyApp.url}$endPoint',
        data: data, queryParameters: params);
    return response;
  }

  Future<Response> put({required String endPoint, dynamic data}) async {
    var response = await _dio.put('${MyApp.url}$endPoint', data: data);
    return response;
  }

  Future<Response> delete({required String endPoint, dynamic params}) async {
    var response =
        await _dio.delete('${MyApp.url}$endPoint', queryParameters: params);
    return response;
  }
}
