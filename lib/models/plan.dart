
class Plan {
  final int id;
  final String vehicleType;
  final double baseRate;
  final String cycle;
  final double discount;
  final double rate;
  final int serviceId;
  final String serviceName;
  final String serviceType;
  final String vehicleSize;

  const Plan({
    required this.id,
    required this.vehicleType,
    required this.baseRate,
    required this.cycle,
    required this.discount,
    required this.rate,
    required this.serviceId,
    required this.serviceName,
    required this.serviceType,
    required this.vehicleSize,
  });

  factory Plan.fromJson(Map<String, dynamic> json) {
    return Plan(
      id: json['id'],
      vehicleType: json['vehicleType'],
      baseRate: json['baseRate'],
      cycle: json['cycle'],
      discount:json['discount'],
      rate:json['rate'],
      serviceId:json['serviceId'],
      serviceName:json['serviceName'],
      serviceType:json['serviceType'],
      vehicleSize:json['vehicleSize'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "vehicleType": vehicleType,
      "baseRate": baseRate,
      "cycle": cycle,
      "discount": discount,
      "rate": rate,
      "serviceId": serviceId,
      "serviceName": serviceName,
      "serviceType": serviceType,
      "vehicleSize": vehicleSize,
    };
  }
}