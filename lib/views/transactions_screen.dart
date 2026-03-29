import 'package:dmw/ApiResponse/transactions_response.dart';
import 'package:dmw/Apis/RestServiceImp.dart';
import 'package:dmw/models/transaction.dart';
import 'package:dmw/providers/transaction_provider.dart';
import 'package:dmw/widgets/transaction_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/common_utils.dart';
import '../utils/custom_colors.dart';
import '../utils/custom_text_styles.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}


class _TransactionsScreenState extends State<TransactionsScreen> {

  late TransactionProvider read,watch;


  @override
  void initState() {
    read = context.read<TransactionProvider>();

    Future.microtask((){
      read.setIsLoading(true);
      loadTransactions();
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    watch = context.watch<TransactionProvider>();

    return Scaffold(
        backgroundColor: AppColors.darkBackground,
        appBar: AppBar(
          backgroundColor: AppColors.darkBackground,
          foregroundColor: AppColors.white,
          centerTitle: true,
          title: const Text('Transaction',
              style: AppTextStyles.whiteFont20Regular),
        ),
        body: watch.isLoading
            ? CommonUtils.loader()
            : watch.transactions.isEmpty?const Center(child: Text("Please Add Subscription", style: TextStyle(
            color: AppColors.white
        ),)):SingleChildScrollView(
                padding: const EdgeInsets.all(16),
          child: transactions(watch.transactions)));
  }

  Widget transactions(List<Transaction> transaction){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 4),
        ...List.generate(2*transaction.length, (index) {
          if(index.isOdd) return const SizedBox(height: 16);
          return TransactionItemWidget(transaction: transaction[index~/2],);
        }),
      ],
    );
  }

  Future<void> loadTransactions()async{

    TransactionsResponse response = await RestServiceImp.getTransactions();
    if(response.isSuccess){
      read.setIsLoading(false);
      read.setTransactions(response.data);
    }

  }

}
