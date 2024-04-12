import 'package:dio/dio.dart';
import 'package:lightify/core/data/server/request_executor/response/server_response.dart';
import 'package:dartz/dartz.dart';
import 'package:lightify/core/domain/failures/server_failure.dart';

abstract class RequestExecutor {
  // Future<Either<ServerFailure, ServerResponse>> post({required String url, required dynamic body, Map<String, dynamic>? headers});

  Future<Either<ServerFailure, ServerResponse>> get({required String url, Map<String, dynamic>? queryParameters, ResponseType? responseType});

  // Future<Either<ServerFailure, ServerResponse>> put({required String url, Map<String, dynamic>? body});

  // Future<Either<ServerFailure, ServerResponse>> delete({required String url, required dynamic body, Map<String, dynamic>? headers});
}
