import 'package:flutter/material.dart';
import 'package:flutter_git_graph/data/data_export.dart';
import 'package:flutter_git_graph/utils/utils_export.dart';

class TransactionTooltip extends StatelessWidget {
  final DayData? dayData; // Nullable DayData
  final _scrollController = ScrollController();

  TransactionTooltip({super.key, required this.dayData});

  String _buildTransactionSummary(DayData? data, TransactionType type, String label) {
    // Handle null data case
    if (data == null) {
      return '$label: \$0.00';
    }

    // Handle empty transactions case
    if (data.transactions.isEmpty) {
      return '$label: \$0.00';
    }

    // Get filtered transactions of specified type
    final filteredTransactions = data.transactions
        .where((t) => t.transactionType == type)
        .toList();

    // Handle no transactions of specified type
    if (filteredTransactions.isEmpty) {
      return '$label: \$0.00';
    }

    final total = filteredTransactions.fold<double>(
        0.0,
            (sum, t) => sum + t.amount
    );

    return '$label: \$${total.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    // Check if DayData is null or if transactions list is empty
    final hasTransactions = dayData?.transactions.isNotEmpty ?? false;

    return Container(
      width: MediaQuery.of(context).size.width *  0.4,
      decoration: BoxDecoration(
        color: ColorUtil.tooltipBackgroundColor, // Using AppColors
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: ColorUtil.tooltipShadowColor,
            offset: Offset(0, 4),
            blurRadius: 4,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              dayData != null ? 'Transactions for ${dayData!.date}' : 'No Data Available',
              style: AppTextStyles.headingTextStyle, // Text style for the heading
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _buildTransactionSummary(
                    dayData,
                    TransactionType.credit,
                    'Credits',
                  ),
                  style: AppTextStyles.subtitleTextStyle.copyWith(
                    color: ColorUtil.colorCreditGreen,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _buildTransactionSummary(
                    dayData,
                    TransactionType.debit,
                    'Debits',
                  ),
                  style: AppTextStyles.subtitleTextStyle.copyWith(
                    color: ColorUtil.colorDebitRed,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
          // Display empty state message if no transactions exist
          if (dayData == null || !hasTransactions)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'No transactions available.',
                style: AppTextStyles.subtitleTextStyle.copyWith(
                  color: ColorUtil.textColorSecondary, // Text color for empty state
                ),
              ),
            )
          else
          // Wrap ListView.builder in a Container to limit the width
            Scrollbar(
              controller: _scrollController,
              child: ListView.builder(
                controller: _scrollController,
                itemCount: dayData!.transactions.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final transaction = dayData!.transactions[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              transaction.transactionType == TransactionType.credit
                                ? Icons.arrow_upward
                                : Icons.arrow_downward,
                              color: transaction.transactionType == TransactionType.credit
                                ? ColorUtil.colorCreditGreen
                                : ColorUtil.colorDebitRed,
                              size: 16
                            ),
                            SizedBox(width: 8),
                            Text(
                              '\$${transaction.amount.toStringAsFixed(2)}',
                              style: AppTextStyles.transactionTextStyle.copyWith(
                                color: transaction.transactionType == TransactionType.credit
                                ? ColorUtil.colorCreditGreen
                                : ColorUtil.colorDebitRed,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 24.0),
                          child: Text(
                            transaction.recipient,
                            style: AppTextStyles.subtitleTextStyle.copyWith(
                              fontSize: 12,
                              color: ColorUtil.textColorSecondary
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
