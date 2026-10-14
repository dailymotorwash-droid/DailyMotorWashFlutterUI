class Service {
  final int id;
  final String serviceName;
  final String description;
  final String image;
  const Service({
    required this.id,
    required this.serviceName,
    required this.description,
    required this.image

  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'],
      serviceName: json['serviceName'],
      description: json['description'],
      image: json['image'],
    );
  }
}