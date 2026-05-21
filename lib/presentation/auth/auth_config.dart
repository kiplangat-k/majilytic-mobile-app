import 'package:http/http.dart' as http;
import '../../core/network/api_client.dart';

// Single shared network client wrapper instance
final ApiClient apiClient = ApiClient(http.Client());

// Shared tracking cache memory data references
Map<String, dynamic>? currentUserSession;