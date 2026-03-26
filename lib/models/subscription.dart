class Subscription {
  final String? id;
  final String vehicleId;
  final int rateId;
  final double rate;
  final double discount;
  final String paymentMethod;
  final bool? isPointsAvail;
  final int? referredBy;
  final String? addressId;
  final DateTime? startDate;
  late String? paymentId;

  Subscription({
    this.id,
    this.isPointsAvail,
    this.referredBy,
    required this.vehicleId,
    required this.rateId,
    required this.rate,
    required this.discount,
    required this.paymentMethod,
    this.addressId,
    this.startDate,
    this.paymentId
  });

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      id: json['id'],
      vehicleId: json['vehicleId'],
      rateId: json['rateId'],
      discount: json['discount'],
      paymentMethod: json['paymentMethod']??'',
      rate: json['rate'],
    );
  }

  Map<String,dynamic> toJson(){
    return {
      "id":id,
      "vehicleId":vehicleId,
      "rateId":rateId,
      "discount":discount,
      "paymentMethod":paymentMethod,
      "rate":rate,
      "referredBy":referredBy,
      "isPointsAvail":isPointsAvail,
      "addressId":addressId,
      "startDate":startDate?.toIso8601String(),
      "razorpayPaymentId":paymentId,
    };
  }
}
