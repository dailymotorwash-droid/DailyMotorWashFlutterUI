import 'package:car_wash/models/transaction.dart';
import 'package:flutter/material.dart';

import '../utils/custom_colors.dart';
import '../utils/custom_text_styles.dart';

class TransactionItemWidget extends StatefulWidget {
  final Transaction transaction;

  const TransactionItemWidget({
    super.key,
    required this.transaction,
  });

  @override
  State<TransactionItemWidget> createState() => _TransactionItemWidget();
}

class _TransactionItemWidget extends State<TransactionItemWidget> {
  late Transaction _transaction;

  @override
  void initState() {
    // TODO: implement initState
    _transaction = widget.transaction;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Txn ID: ${_transaction.id}",
            style: AppTextStyles.whiteFont12Regular,
          ),

          const SizedBox(height: 6),

          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // This pushes items to the edges
              children: [

            // Vehicle Register Number
            Text(" ${_transaction.registrationNumber}",
                style: AppTextStyles.whiteFont16Bold),


            /// Amount
            Text("₹ ${_transaction.amountPaid?.toStringAsFixed(2)}",
                style: AppTextStyles.whiteFont16Bold),
          ]),

          const SizedBox(height: 12),

          /// Dates Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _dateColumn("Start Date", _transaction.startDate!),
              _dateColumn("End Date", _transaction.endDate!),
            ],
          ),
        ],
      ),
    );
  }

  Widget _dateColumn(String title, DateTime date) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.whiteFont12Regular,
        ),
        Text(
          _formatDate(date),
          style: AppTextStyles.whiteFont16Bold,
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }
}
