// lib/core/errors/validation_exception.dart

import 'app_exception.dart';

class ValidationException extends AppException {
  final Map<String, List<String>> errors;

  ValidationException({
    required String message,
    this.errors = const {},
  }) : super(
    message: message,
    prefix: 'Form Validation Matrix Error',
    code: 422,
  );

  @override
  String toString() => '$prefix: $message | Matrix: $errors';
}