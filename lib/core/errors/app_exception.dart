// lib/core/errors/app_exception.dart

class AppException implements Exception {
  final String message;
  final String? prefix;
  final int? code;

  const AppException({
    required this.message,
    this.prefix,
    this.code,
  });

  @override
  String toString() => '${prefix ?? "AppException"}${code != null ? " [$code]" : ""}: $message';
}