import 'package:dio/dio.dart';
import 'package:dmw/ApiResponse/user_profile_response.dart';
import 'package:dmw/Apis/RestServiceImp.dart';
import 'package:dmw/models/user.dart';
import 'package:dmw/utils/local_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../utils/AuthHandler.dart';
import 'Constraints.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;

  late Dio dio;

  ApiClient._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: Constraints.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          "Content-Type": "application/json",
        },
      ),
    );
    _addInterceptors();
  }

  void _addInterceptors() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler){
          if (kDebugMode) {
            print("➡️ REQUEST:");
            print("URL: ${options.baseUrl}${options.path}");
            print("Method: ${options.method}");
            print("Headers: ${options.headers}");
            print("Body: ${options.data}");
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          if (kDebugMode) {
            print("✅ RESPONSE:");
            print("URL: ${response.requestOptions.baseUrl}${response.requestOptions.path}");
            print("Status: ${response.statusCode}");
            print("Data: ${response.data}");
          }

          return handler.next(response);
        },
        onError: (error, handler) async {
          if (kDebugMode) {
            print("❌ ERROR:");
            print("URL: ${error.requestOptions.baseUrl}${error.requestOptions.path}");
            print("Status: ${error.response?.statusCode}");
            print("Message: ${error.message}");
          }
          // 🚫 Prevent infinite loop
          if (error.requestOptions.path.contains("/auth/refresh")||error.response?.statusCode==null) {
            AuthHandler.onLogout?.call();
            return handler.next(error);
          }
          final statusCode = error.response?.statusCode;
          if (statusCode == 401 || statusCode == 403) {

            try {
              UserProfileResponse newToken =
              await RestServiceImp.refreshToken();

              if (newToken.isSuccess) {
                // ✅ Update token
                print(newToken.data.token);
                error.requestOptions.headers['Authorization'] = newToken.data.token;

                LocalStorage.setToken(newToken.data.token!);
                LocalStorage.setFirstName(newToken.data.firstName!);
                LocalStorage.setLastName(newToken.data.lastName!);
                LocalStorage.setUserId(newToken.data.id!);
                LocalStorage.setPhone(newToken.data.phone);
                LocalStorage.setStatus(newToken.data.status!);

                // 🔁 Retry original request
                final response = await dio.request(
                  error.requestOptions.path,
                  options: Options(
                    method: error.requestOptions.method,
                    headers: error.requestOptions.headers,
                  ),
                  data: error.requestOptions.data,
                  queryParameters: error.requestOptions.queryParameters,
                );

                return handler.resolve(response);

              } else {
                // 🔥 Logout
                AuthHandler.onLogout?.call();
              }

            } catch (e) {
              // 🔥 Logout if refresh fails
              AuthHandler.onLogout?.call();
            }
          }

          return handler.next(error);
        },
      ),
    );
  }
}