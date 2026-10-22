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
          final path = error.requestOptions.path;
          final statusCode = error.response?.statusCode;

          if (kDebugMode) {
            print("❌ ERROR:");
            print("URL: ${error.requestOptions.baseUrl}${error.requestOptions.path}");
            print("Status: ${error.response?.statusCode}");
            print("Message: ${error.message}");
          }
          // 1. Never refresh recursively for the refresh API.
          if (path.contains("/auth/refresh")) {
            return handler.next(error);
          }

          // 2. Network errors, timeouts and connection failures
          // must not log out the user.
          if (statusCode == null) {
            return handler.next(error);
          }

          // 3. Refresh only for authentication errors.
          if (statusCode != 401 && statusCode != 403) {
            return handler.next(error);
          }

          // 4. Prevent retrying a request more than once.
          if (error.requestOptions.extra['retried'] == true) {
            return handler.next(error);
          }
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

                // 5. Retry the original request only once.
                final requestOptions = error.requestOptions;

                requestOptions.headers['Authorization'] = newToken;
                requestOptions.extra['retried'] = true;


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