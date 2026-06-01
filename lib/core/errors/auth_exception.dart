// lib/core/errors/auth_exception.dart

import 'app_exception.dart';

class AuthException extends AppException {
  const AuthException({
    required String message,
    int? code,
  }) : super(
    message: message,
    prefix: 'Authentication Security Fault',
    code: code,
  );
}

class SessionExpiredException extends AuthException {
  const SessionExpiredException()
      : super(
    message: 'Your system security token has expired. Please authenticate again.',
    code: 401,
  );
}