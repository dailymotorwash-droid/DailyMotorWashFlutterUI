class Brand{
  final int id;
  final String name;

  const Brand({
    required this.id,
    required this.name
});

  factory Brand.fromJson(Map<String,dynamic> json){
    return Brand(id: json['id'], name: json['name']);
  }
}