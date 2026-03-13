class Model{


  final int id;
  final String name;
  final String vehicleSize;
  final String vehicleType;


  const Model({
    required this.id,
    required this.name,
    required this.vehicleType,
    required this.vehicleSize,

  });


  factory Model.fromJson(Map<String,dynamic> json){

    return Model(id: json['id'], name: json['name'], vehicleType: json['vehicleType'], vehicleSize: json['vehicleSize']);
  }


}