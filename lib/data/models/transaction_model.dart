class TransactionModel {
  final String transactionId;
  final double amount;
  final String type; // e.g., "DEPOSIT", "PAYMENT"
  final String status; // e.g., "COMPLETED", "FAILED"
  final DateTime createdAt;

  TransactionModel({
    required this.transactionId,
    required this.amount,
    required this.type,
    required this.status,
    required this.createdAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      transactionId: json['transaction_id'] as String? ?? '',
      amount: double.parse((json['amount'] ?? 0.0).toString()),
      type: json['type'] as String? ?? 'DEPOSIT',
      status: json['status'] as String? ?? 'PENDING',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }
}