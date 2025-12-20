class Summary {
  final double totalIncome;
  final double expenses;
  final double balance;

  Summary({
    required this.totalIncome,
    required this.expenses,
    required this.balance,
  });

  factory Summary.fromJson(Map<String, dynamic> json) {
    return Summary(
      totalIncome: (json['totalIncome'] ?? 0).toDouble(),
      expenses: (json['expenses'] ?? 0).toDouble(),
      balance: (json['balance'] ?? 0).toDouble(),
    );
  }
}