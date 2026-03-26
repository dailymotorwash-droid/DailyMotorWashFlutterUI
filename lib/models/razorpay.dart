class Razorpay{

  final int amount;
  final DateTime? createdAt;
  final int amountDue;
  final String currency;
  final String receipt;
  final String id;
  final String status;

  const Razorpay( {
    required this.id,
    this.createdAt,
    required this.amountDue,
    required this.currency,
    required this.receipt,
    required this.status,
    required this.amount,
});

  factory Razorpay.fromJson(Map<String,dynamic> data){
    return Razorpay(
      id: data['id'],
      amount: data['amount'],
      // createdAt: DateTime.parse(data['created_at']),
      amountDue: data['amount_due'],
      currency: data['currency'],
      receipt: data['receipt'],
      status: data['status'],

    );
  }
}