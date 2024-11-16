import 'dart:math';
import 'data_classes.dart';

class MockData {
  static final _random = Random();

  // Generate mock transactions for a single day
  static List<Transaction> _generateRandomTransactions(int count) {
    return List.generate(count, (index) {
      final amount = (_random.nextDouble() * 1000).toStringAsFixed(2);
      final recipients = ['John Doe', 'Electricity Bill', 'Cafe XYZ', 'Amazon', 'Netflix'];
      const transactionTypes = TransactionType.values;

      return Transaction(
        id: 'TXN${_random.nextInt(1000000000)}',
        timestamp: DateTime.now().subtract(Duration(hours: _random.nextInt(24))),
        amount: double.parse(amount),
        recipient: recipients[_random.nextInt(recipients.length)],
        transactionType: transactionTypes[_random.nextInt(transactionTypes.length)],
      );
    });
  }

  // Generate mock data for the past year until today
  static List<DayData> generateYearMockData() {
    final today = DateTime.now();
    final oneYearAgo = today.subtract(const Duration(days: 365));
    
    // Generate data from one year ago to today
    final List<DayData> yearData = [];
    
    // Start from one year ago and move forward
    DateTime currentDate = DateTime(
      oneYearAgo.year,
      oneYearAgo.month,
      oneYearAgo.day,
    );
    
    // Fill with data until today
    while (currentDate.isBefore(today) || 
           (currentDate.year == today.year && 
            currentDate.month == today.month && 
            currentDate.day == today.day)) {
      
      // Only add data for dates up to today
      if (currentDate.isBefore(today) || currentDate.isAtSameMomentAs(today)) {
        final transactionsCount = _random.nextInt(5);
        yearData.add(
          DayData(
            date: currentDate.toIso8601String().split('T').first,
            transactions: _generateRandomTransactions(transactionsCount),
          ),
        );
      }
      
      currentDate = currentDate.add(const Duration(days: 1));
    }

    // Sort the data to ensure correct order (oldest to newest)
    yearData.sort((a, b) => DateTime.parse(a.date).compareTo(DateTime.parse(b.date)));

    return yearData;
  }
}
