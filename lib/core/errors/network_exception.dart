// lib/core/errors/network_exception.dart

import 'app_exception.dart';

class NetworkException extends AppException {
  const NetworkException({
    required String message,
    int? code,
  }) : super(
    message: message,
    prefix: 'Network Gateway Exception',
    code: code,
  );
}

class ConnectionTimeoutException extends NetworkException {
  const ConnectionTimeoutException()
      : super(
    message: 'The connection to the water utility server timed out. Check your internet connectivity.',
    code: 408,
  );
}

class FetchDataException extends NetworkException {
  const FetchDataException({required String details})
      : super(
    message: 'Error communicating with remote endpoint cluster: $details',
    code: 500,
  );
}