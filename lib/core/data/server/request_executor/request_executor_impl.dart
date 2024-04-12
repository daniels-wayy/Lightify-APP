import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lightify/core/data/server/request_executor/request_executor.dart';
import 'package:lightify/core/data/server/request_executor/response/server_response.dart';
import 'package:lightify/core/domain/failures/server_failure.dart';

class RequestExecutorImpl implements RequestExecutor {
  // static const API_CAPTCHA_KEY = 'recaptcha-token';

  // final String basicAuth;
  final Dio dio;
  // final AccessTokenRepo accessTokenRepo;
  // final DeviceInfo deviceInfo;

  RequestExecutorImpl({
    required this.dio,
    // required this.accessTokenRepo,
    // required this.basicAuth,
    // required this.deviceInfo,
  });

  // String get _salt => 'aequ5Eekshei5Lu8iujae7Oipais1ahBeiyai1ZaevohS7eiItoh2ahTAeloox5p';

  // String get _reCaptcha {
  //   final String value = _salt + DateFormat('yyyy-MM-dd').format(DateTime.now().toUtc());
  //   final String hash = md5.convert(utf8.encode(value)).toString();
  //   debugPrint('value="$value"; hash="$hash"');
  //   return hash;
  // }

  // Future<ServerResponse> _post(
  //     {required String url, required dynamic body, Map<String, dynamic>? headers, String? recaptcha}) async {
  //   await _addAuthHeaders();
  //   debugPrint('Dio post: ${dio.options.baseUrl}$url');
  //   try {
  //     final optionsWithAdditionalHeaders = Map<String, dynamic>.of(dio.options.headers)
  //       ..addAll(headers ?? <String, dynamic>{});
  //     final Response<Object> response = recaptcha != null
  //         ? await dio.post<Object>(url,
  //             data: body,
  //             options: Options(headers: optionsWithAdditionalHeaders),
  //             queryParameters: <String, String>{'$API_CAPTCHA_KEY': recaptcha})
  //         : await dio.post<Object>(url, data: body, options: Options(headers: optionsWithAdditionalHeaders));
  //     List<String>? cookies;
  //     final cookiesRaw = response.headers['set-cookie'];
  //     cookies = cookiesRaw?.first.split(';');
  //     return ServerResponse(statusCode: response.statusCode, data: response.data, cookies: cookies);
  //   } on /*DioError*/ DioException catch (error) {
  //     debugPrint('Dio post error: ${error.toString()}');
  //     return _parseDioError(error);
  //   }
  // }

  // @override
  // Future<ServerResponse> post({required String url, required dynamic body, Map<String, dynamic>? headers}) async {
  //   ServerResponse response = await _post(url: url, body: body, headers: headers);
  //   if (response.statusCode == 400) {
  //     final ErrorsResponse errorsResponse = ErrorsResponse.fromJson(response.data as Map<String, dynamic>);
  //     debugPrint('-=+ Dio ServerResponse: ${errorsResponse.getMessage()}');
  //     if (errorsResponse.isCaptchaRequired) {
  //       response = await _post(url: url, body: body, headers: headers, recaptcha: _reCaptcha);
  //     }
  //   }
  //   return response;
  // }

  // @override
  // Future<ServerResponse> delete({required String url, required dynamic body, Map<String, dynamic>? headers}) async {
  //   await _addAuthHeaders();
  //   debugPrint('Dio delete: ${dio.options.baseUrl}$url');
  //   try {
  //     final optionsWithAdditionalHeaders = Map<String, dynamic>.of(dio.options.headers)
  //       ..addAll(headers ?? <String, dynamic>{});
  //     final Response<Object> response =
  //         await dio.delete<Object>(url, data: body, options: Options(headers: optionsWithAdditionalHeaders));
  //     List<String>? cookies;
  //     final cookiesRaw = response.headers['set-cookie'];
  //     cookies = cookiesRaw?.first.split(';');
  //     return ServerResponse(statusCode: response.statusCode, data: response.data, cookies: cookies);
  //   } on /*DioError*/ DioException catch (error) {
  //     debugPrint('Dio post error: ${error.toString()}');
  //     return _parseDioError(error);
  //   }
  // }

  Future<Either<ServerFailure, ServerResponse>> _get({
    required String url,
    Map<String, dynamic>? queryParameters,
    ResponseType? responseType,
    String? recaptcha,
  }) async {
    // await _addAuthHeaders();
    try {
      var paramsEncoded = '';
      if (queryParameters != null || recaptcha != null) {
        // if (recaptcha != null) {
        //   final Map<String, dynamic> queryParametersCaptcha = <String, dynamic>{'$API_CAPTCHA_KEY': recaptcha};
        //   if (queryParameters != null) {
        //     queryParametersCaptcha.addAll(queryParameters);
        //   }
        //   paramsEncoded = Uri(queryParameters: queryParametersCaptcha).toString();
        // } else {
        paramsEncoded = Uri(queryParameters: queryParameters).toString();
        // }
      }
      debugPrint('Dio get: ${dio.options.baseUrl}$url$paramsEncoded');
      final Response<Object> response =
          await dio.get<Object>(url + paramsEncoded, options: Options(responseType: responseType));
      if (responseType == ResponseType.bytes) {
        debugPrint('HEADERSL ${response.headers}');
      }
      final data = ServerResponse(statusCode: response.statusCode, data: response.data);
      return right(data);
    } on DioException catch (error) {
      debugPrint('Dio get error:  ${error.toString()}');
      return _parseDioError(error);
    }
  }

  @override
  Future<Either<ServerFailure, ServerResponse>> get(
      {required String url, Map<String, dynamic>? queryParameters, ResponseType? responseType}) async {
    final response = await _get(url: url, queryParameters: queryParameters, responseType: responseType);
    // if (response.statusCode == 400 && responseType != ResponseType.bytes) {
    //   final ErrorsResponse errorsResponse = ErrorsResponse.fromJson(response.data as Map<String, dynamic>);
    //   debugPrint('-=+ Dio ServerResponse: ${errorsResponse.getMessage()}');
    //   if (errorsResponse.isCaptchaRequired) {
    //     response =
    //         await _get(url: url, queryParameters: queryParameters, responseType: responseType, recaptcha: _reCaptcha);
    //   }
    // }
    return response;
  }

  // Future<ServerResponse> _put({required String url, Map<String, dynamic>? body, String? recaptcha}) async {
  //   await _addAuthHeaders();
  //   debugPrint('Dio put: ${dio.options.baseUrl}$url');
  //   try {
  //     final Response<Object> response = recaptcha != null
  //         ? await dio.put<Object>(url, data: body, queryParameters: <String, String>{'$API_CAPTCHA_KEY': recaptcha})
  //         : await dio.put<Object>(url, data: body);
  //     return ServerResponse(statusCode: response.statusCode, data: response.data);
  //   } on /*DioError*/ DioException catch (error) {
  //     debugPrint('Dio get error:  ${error.toString()}');
  //     return _parseDioError(error);
  //   }
  // }

  // @override
  // Future<ServerResponse> put({required String url, Map<String, dynamic>? body}) async {
  //   ServerResponse response = await _put(url: url, body: body);
  //   if (response.statusCode == 400) {
  //     final ErrorsResponse errorsResponse = ErrorsResponse.fromJson(response.data as Map<String, dynamic>);
  //     debugPrint('-=+ Dio ServerResponse: ${errorsResponse.getMessage()}');
  //     if (errorsResponse.isCaptchaRequired) {
  //       response = await _put(url: url, body: body, recaptcha: _reCaptcha);
  //     }
  //   }
  //   return response;
  // }

  // Future<void> _addAuthHeaders() async {
  //   const API_AUTHORIZATION_KEY = 'apiauthorization';
  //   const BASE_API_AUTHORIZATION_KEY = 'Authorization';
  //   const APP_LOG_KEY = 'app_log';

  //   final appLog = deviceInfo.toString();
  //   // debugPrint('$APP_LOG_KEY=$appLog');
  //   dio.options.headers[APP_LOG_KEY] = appLog;

  //   if (basicAuth.isNotEmpty) {
  //     dio.options.headers[BASE_API_AUTHORIZATION_KEY] = basicAuth;
  //   } else {
  //     dio.options.headers.remove(BASE_API_AUTHORIZATION_KEY);
  //   }

  //   var token = accessTokenRepo.getAccessToken();
  //   if (token != null) {
  //     final expiry = Jwt.getExpiryDate(token);
  //     if (DateTime.now().subtract(const Duration(minutes: 1)).isAfter(expiry!)) {
  //       token = await _performTokenRefresh();
  //     }
  //     dio.options.headers[API_AUTHORIZATION_KEY] = 'Bearer $token';
  //   } else {
  //     dio.options.headers.remove(API_AUTHORIZATION_KEY);
  //   }
  // }

  Either<ServerFailure, ServerResponse> _parseDioError(DioException error) {
    if (error.error is SocketException) {
      return left(const ServerFailure.connection());
    } else if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout) {
      return left(const ServerFailure.connection());
    } else if (error.response?.statusCode == 401) {
      return left(const ServerFailure.authentication());
    } else if (error.response?.statusCode == 404) {
      return left(const ServerFailure.notFound());
    } else if (error.response?.statusCode == 409) {
      return right(ServerResponse(
        statusCode: error.response?.statusCode,
        data: error.response?.data,
      ));
    } else if (error.response?.statusCode != null &&
        error.response!.statusCode! >= 500 &&
        error.response!.statusCode! <= 510) {
      return left(const ServerFailure.serverIssue());
    } else {
      return left(ServerFailure.unexpected(
        statusCode: error.response?.statusCode,
        data: error.response?.data,
      ));
    }
  }

  // Future<String?> _performTokenRefresh() async {
  //   late Response<Map<String, dynamic>> response;

  //   try {
  //     final dio = getIt<Dio>(instanceName: 'OSCP');
  //     const url = 'member/token';

  //     final refreshToken = accessTokenRepo.getRefreshToken();
  //     final allHeaders = <String, dynamic>{
  //       'accept': 'application/json',
  //       'Cookie': 'refreshToken=$refreshToken',
  //     };

  //     /*final*/ response = await dio.get<Map<String, dynamic>>(url, options: Options(headers: allHeaders));

  //     final responseBody = response.data!;
  //     final responseHeaders = response.headers.map;

  //     final newAccessToken = responseBody['token'] as String;
  //     final newRefreshToken = _parseRefreshToken(responseHeaders);
  //     await accessTokenRepo.setAccessToken(newAccessToken);
  //     await accessTokenRepo.setRefreshToken(newRefreshToken);

  //     return accessTokenRepo.getAccessToken();
  //   } on Object catch (e, st) {
  //     debugPrint('_performTokenRefresh Exception: ${e.toString()}');

  //     if (getIt<String>(instanceName: 'ENV') != Env.PROD) {
  //       LayoutUtil.showToast('_performTokenRefresh: statusCode:${response.statusCode} / error:${e.toString()}');
  //     }

  //     throw AuthorizationError();
  //     // throw ConnectionError();
  //   }
  // }

  // String _parseRefreshToken(Map<String, dynamic> headers) {
  //   final cookiesRaw = headers['set-cookie'] as List<String>;
  //   final cookies = cookiesRaw.first.split(';');
  //   final refreshTokenCookie = cookies.firstWhere((cookie) => cookie.contains('refreshToken'));
  //   return refreshTokenCookie.substring(refreshTokenCookie.indexOf('=') + 1);
  // }
}
