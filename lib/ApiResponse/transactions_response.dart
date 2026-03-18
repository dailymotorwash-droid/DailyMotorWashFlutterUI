import 'package:car_wash/ApiResponse/Response.dart';
import 'package:car_wash/models/transaction.dart';

class TransactionsResponse extends Response{

  late List<Transaction> data;

  TransactionsResponse.fromJson(Map<String,dynamic> json) : super.fromJson(json){
    if(json['data']!=null && json['data'] is List){
      data = (json['data'] as List)
          .map((e) => Transaction.fromJson(e))
          .toList();
    }

  }

}