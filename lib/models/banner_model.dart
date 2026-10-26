class BannerModel {
  final int id;
  final String imageUrl;
  final String? title;
  final String? redirectLink;
  final bool isActive;
  final String? createdAt;

  BannerModel({
    required this.id,
    required this.imageUrl,
    this.title,
    this.redirectLink,
    required this.isActive,
    this.createdAt,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'] is int ? json['id'] : int.tryParse('${json['id']}') ?? 0,
      imageUrl: json['imageUrl']?.toString() ?? '',
      title: json['title']?.toString(),
      redirectLink: json['redirectLink']?.toString(),
      isActive: json['isActive'] == true,
      createdAt: json['createdAt']?.toString(),
    );
  }
}