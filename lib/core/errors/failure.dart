// lib/core/errors/failure.dart

abstract class Failure {
  final String message;
  final int? statusCode;

  const Failure(this.message, {this.statusCode});

  @override
  String toString() => 'Failure(message: $message, statusCode: $statusCode)';
}

/// Returned when network configurations fail or servers drop connections
class ServerFailure extends Failure {
  const ServerFailure(super.message, {super.statusCode});
}

/// Returned when local persistent caches (like security tokens) fail to read/write
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

/// Returned when business logic rules are broken (e.g., trying to shut an already closed valve)
class BusinessRuleFailure extends Failure {
  const BusinessRuleFailure(super.message);
}