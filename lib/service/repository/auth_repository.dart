import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:time_cheker/components/constant.dart';
import 'package:time_cheker/service/model/arrive_check.dart';
import 'package:time_cheker/service/model/date_info.dart';
import 'package:time_cheker/service/model/member_model.dart';
import 'package:time_cheker/service/network/api_service.dart';
import 'package:time_cheker/service/network/netword_info.dart';
import 'package:time_cheker/service/repository/repository.dart';

class RepositoryImpl extends Repository {
  final ApiService _apiService;
  final NetworkInfo _networkInfo;

  RepositoryImpl(
    this._apiService,
    this._networkInfo,
  );

  @override
  Future<List<Member>> getMemberService() async {
    try {
      final response = await _apiService.get(
        endPoint: '/mobile-jagsaalt',
        queryParameters: {'key': 'value'},
        data: {'ognoo': '05/01 НЯ'},
      );

      loggerPretty.e('Full Response Data: ${jsonEncode(response.data)}');

      // JSON өгөгдөл нь List эсэхийг шалгах
      if (response.data is List) {
        return (response.data as List).map((e) => Member.fromJson(e)).toList();
      } else if (response.data is Map && response.data['data'] is List) {
        return (response.data['data'] as List)
            .map((e) => Member.fromJson(e))
            .toList();
      } else {
        throw Exception(
            "Invalid data format: Expected a List but got ${response.data.runtimeType}");
      }
    } catch (error) {
      loggerPretty.e('get members error: $error');
      if (error is DioException) {
        loggerPretty.e('Response Data: ${jsonEncode(error.response?.data)}');
        loggerPretty.e('Status Code: ${error.response?.statusCode}');
      }
      rethrow;
    }
  }

  @override
  Future<String> login(String username, String password) async {
    try {
      dynamic data = {
        'username': username,
        'password': password,
      };
      final response = await _apiService.post(
        endPoint: '/applogin',
        data: data,
      );
      loggerPrettyNoStack.i("This is token $response");
      if (response.data == 'DeviceNotFound') return response.data as String;
      // Assuming the API returns a token field
      final token = response.data['token'] as String;
      loggerPrettyNoStack.i("This is token $token");
      return token;
    } catch (error) {
      loggerPretty.e('Login failed: $error');
      if (error is DioException && error.response?.statusCode == 401) {
        // Handle unauthorized error - extract the message from response if available
        final errorData = error.response?.data;
        if (errorData != null &&
            errorData is Map &&
            errorData.containsKey('message')) {
          // Return 'InvalidCredentials' for correct error handling in UI
          return 'InvalidCredentials';
        }
      }
      rethrow;
    }
  }

  @override
  Future<List<DateInfo>> fetchDateInfo() async {
    try {
      final response = await _apiService.get(
        endPoint: '/ognoo',
        queryParameters: {'ognoo': '2023-01-01'},
      );

      // JSON өгөгдлийг бүхэлд нь хэвлэх
      loggerPretty.e('Response Data: ${response.data}');

      // Handle if response.data is a Map instead of a List
      if (response.data is Map) {
        final Map<String, dynamic> dataMap = response.data;
        String kharuulakhValue = '';

        if (dataMap.containsKey('kharuulakh')) {
          kharuulakhValue = dataMap['kharuulakh'] as String;
        }

        if (dataMap.containsKey('udruud') && dataMap['udruud'] is List) {
          final List<DateInfo> dateList = (dataMap['udruud'] as List).map((e) {
            try {
              DateInfo dateInfo = DateInfo.fromString(e);
              // Set kharuulakh value for all dates
              dateInfo.kharuulakh = kharuulakhValue;
              return dateInfo;
            } catch (error) {
              loggerPretty.e('Error parsing dateInfo: $error | Data: $e');
              rethrow;
            }
          }).toList();

          return dateList;
        } else {
          throw Exception(
              "Required 'udruud' key not found in the response data");
        }
      }
      // Original code for handling a List response
      else if (response.data is List) {
        return (response.data as List).map((e) {
          try {
            return DateInfo.fromString(e); // fromJson биш fromString ашиглана
          } catch (error) {
            loggerPretty.e('Error parsing dateInfo: $error | Data: $e');
            rethrow;
          }
        }).toList();
      } else {
        throw Exception(
            "Invalid data format: Expected a List or Map but got ${response.data.runtimeType}");
      }
    } catch (error) {
      loggerPretty.e('fetch date info error: $error');
      if (error is DioException) {
        loggerPretty.e('Status Code: ${error.response?.statusCode}');
        loggerPretty.e('Response Data: ${error.response?.data}');
      }
      rethrow;
    }
  }

  @override
  Future<void> sendArrival(ArriveCheck irsernIreegui) async {
    try {
      final response = await _apiService.post(
        endPoint: '/irsen-ireegui',
        data: irsernIreegui,
      );
      loggerPrettyNoStack.i("This is token $response");
    } catch (error) {
      loggerPretty.e('Login failed: $error');
      rethrow;
    }
  }
}
