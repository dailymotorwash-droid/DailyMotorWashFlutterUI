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

  // ADD THIS:
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Brand && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}