import 'package:freezed_annotation/freezed_annotation.dart';

part 'server_failure.freezed.dart';

@freezed
abstract class ServerFailure with _$ServerFailure {
  const ServerFailure._();
  const factory ServerFailure.connection() = _Connection;
  const factory ServerFailure.authentication() = _Authentication;
  const factory ServerFailure.notFound() = _NotFound;
  const factory ServerFailure.serverIssue() = _ServerIssue;
  const factory ServerFailure.unexpected({int? statusCode, dynamic data}) = _Unexpected;

  String get errorMessage {
    return when(
      connection: () => 'Connection error occured! Please check your connection and try again.',
      authentication: () => 'You do not have access to this source.',
      notFound: () => 'Unnable to find source. Please try again later.',
      serverIssue: () => 'Server error occured!',
      unexpected: (statusCode, data) {
        var result = 'Unexpected error occured!';
        if (statusCode != null) {
          result += ' Status code: $statusCode.';
        }
        if (data != null) {
          result += ' Response data: $data.';
        }
        return result;
      },
    );
  }
}
