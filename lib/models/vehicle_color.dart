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

}