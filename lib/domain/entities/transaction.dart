class Transaction {
  final String transactionId;
  final double amount;
  final String type;
  final String status;
  final DateTime createdAt;

  const Transaction({
    required this.transactionId,
    required this.amount,
    required this.type,
    required this.status,
    required this.createdAt,
  });
}