// lib/core/config/app_initializer.dart

import 'package:flutter/material.dart';
import 'dependency_injection.dart';

class AppInitializer {
  /// Blocks framework presentation rendering until underlying native connections are open
  static Future<void> runPreAppBindings() async {
    try {
      // 🟢 Ensures Flutter Engine primitives are bound securely before asynchronous calls
      WidgetsFlutterBinding.ensureInitialized();

      // 🟢 Execute Service Locator initialization
      await DependencyInjection.initializeDependencies();

    } catch (e) {
      // Catch framework assembly exceptions during bootstrap execution
      debugPrint('Critical Application Lifecycle Bootstrap Failure: $e');
      rethrow;
    }
  }
}