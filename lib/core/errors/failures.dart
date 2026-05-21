abstract class Failure {
  final String message;
  const Failure(this.message);
}

// Maps to HTTP 400, 422, or general bad validation payloads
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

// Maps to HTTP 401 or 403 unauthorized tokens
class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

// Maps to SocketException or complete loss of internet
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No Internet connection. Please try again.']);
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}