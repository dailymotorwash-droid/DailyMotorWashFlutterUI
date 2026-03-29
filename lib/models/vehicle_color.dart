class VehicleColor{

  final int id;
  final String name;


  const VehicleColor({

    required this.id,
    required this.name,
  });


  factory VehicleColor.fromJson(Map<String,dynamic> json){

    return VehicleColor(id: json['id'], name: json['name']);
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is VehicleColor &&
              runtimeType == other.runtimeType &&
              id == other.id;

  @override
  int get hashCode => id.hashCode;
}