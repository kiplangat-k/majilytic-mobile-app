// lib/features/dashboard/dashboard_repository.dart

// 🟢 FIXED: Updated import path from '../../core/errors/errors_handler.dart'
// to '../../core/utils/errors_handler.dart' to target our newly fixed combined class
import '../../core/utils/errors_handler.dart';
import '../../core/errors/failure.dart';
import '../../core/errors/network_exception.dart';
import 'dashboard_metrics.dart';

class DashboardRepository {
  /// Fetches system metrics using a structured record return type containing either data or failure flags
  Future<({DashboardMetrics? data, Failure? failure})> getRemoteDashboardMetrics(String token) async {
    try {
      // 1. Core API call mapping (simulated with a ConnectionTimeoutException for runtime handling checks)
      throw const ConnectionTimeoutException();
    } catch (exception) {
      // 🟢 FIXED: Now that the repository imports the correct file, this method maps flawlessly!
      final presentationFailure = ErrorsHandler.handle(exception);

      return (
      data: null,
      failure: presentationFailure,
      );
    }
  }
}