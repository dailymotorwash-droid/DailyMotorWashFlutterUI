class Transaction {
  final String? id;
  final double? amountPaid;
  final DateTime? paymentDate;
  final String? paymentMethod;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? registrationNumber;

  const Transaction(
      {this.id,
      this.amountPaid,
      this.paymentDate,
      this.paymentMethod,
      this.startDate,
      this.endDate,
        this.registrationNumber
      });

  factory Transaction.fromJson(Map<String,dynamic> json){

    return Transaction(

      id: json['id'],
      amountPaid: json['amountPaid'],
      registrationNumber: json['registrationNumber'],
      paymentDate: DateTime.parse(json['paymentDate']),
      paymentMethod: json['paymentMethod'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
    );

  }
}


