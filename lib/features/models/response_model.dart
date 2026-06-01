// lib/features/models/response_model.dart

class ResponseModel<T> {
  final bool success;
  final String message;
  final T? data;

  ResponseModel({
    required this.success,
    required this.message,
    this.data,
  });

  /// Generic factory to parse standard backend API wrapper definitions
  /// [fromJsonT] maps the inner 'data' payload block to a specific target model.
  factory ResponseModel.fromJson(
      Map<String, dynamic> json,
      T Function(dynamic json)? fromJsonT,
      ) {
    return ResponseModel<T>(
      success: json['success'] as bool? ?? false,
      message: json['message']?.toString() ?? '',
      data: json['data'] != null && fromJsonT != null
          ? fromJsonT(json['data'])
          : null,
    );
  }

  /// Helper factory explicitly built for parsing lists/arrays of entities
  factory ResponseModel.fromJsonList(
      Map<String, dynamic> json,
      T Function(Map<String, dynamic> json) fromJsonModel,
      ) {
    final rawData = json['data'];
    T? listData;

    if (rawData is List) {
      listData = rawData.map((item) => fromJsonModel(item as Map<String, dynamic>)).toList() as T;
    }

    return ResponseModel<T>(
      success: json['success'] as bool? ?? false,
      message: json['message']?.toString() ?? '',
      data: listData,
    );
  }

  Map<String, dynamic> toJson(Map<String, dynamic> Function(T? data)? toJsonT) {
    return {
      'success': success,
      'message': message,
      'data': data != null && toJsonT != null ? toJsonT(data) : data,
    };
  }
}