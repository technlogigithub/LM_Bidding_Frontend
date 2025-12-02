class TransactionData {
  final String name;
  final String date;
  final double amount;
  final bool isDeposit;

  TransactionData({
    required this.name,
    required this.date,
    required this.amount,
    required this.isDeposit,
  });
}