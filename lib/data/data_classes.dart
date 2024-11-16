enum TransactionType {
  credit,
  debit
}

class Transaction {
  final String id;
  final DateTime timestamp;
  final double amount;
  final String recipient;
  final TransactionType transactionType;

  Transaction({
    required this.id,
    required this.timestamp,
    required this.amount,
    required this.recipient,
    required this.transactionType,
  });

  // Factory constructor to create a Transaction from JSON
  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      timestamp: DateTime.parse(json['timestamp']),
      amount: json['amount'].toDouble(),
      recipient: json['recipient'],
      transactionType: TransactionType.values.firstWhere(
        (e) => e.toString() == 'TransactionType.${json['transactionType']}'
      ),
    );
  }
}

class DayData {
  final String date;
  final List<Transaction> transactions;

  DayData({
    required this.date,
    required this.transactions,
  });

  // Factory constructor to create DayData from JSON
  factory DayData.fromJson(Map<String, dynamic> json) {
    return DayData(
      date: json['date'],
      transactions: (json['transactions'] as List<dynamic>)
          .map((transaction) => Transaction.fromJson(transaction))
          .toList(),
    );
  }

  static List<double?> transformToHeatmap(List<DayData> data) {
      return data.map((dayData) {
        // Sum up the amounts for all transactions of a given day
        double totalAmount = dayData.transactions.fold(0.0, (sum, transaction) {
          return sum + transaction.amount;
        });
        return totalAmount; // Return the sum as a numeric value
      }).toList();
  }

}

class HeatmapData {
  final List<DayData> days;

  HeatmapData({required this.days});

  // Factory constructor to create HeatmapData from JSON
  factory HeatmapData.fromJson(List<dynamic> json) {
    return HeatmapData(
      days: json.map((day) => DayData.fromJson(day)).toList(),
    );
  }
}
