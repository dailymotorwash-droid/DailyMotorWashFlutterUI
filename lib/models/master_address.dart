class MasterAddress{
  final int id;
  final String societyName;
  final String  societyLine1;
  final String  societyLine2;
  final String  societyLine3;
  final String city;
  final String state;
  final String pinCode;
  final String district;

  const MasterAddress({
    required this.id,
    required this.societyName,
    required this.societyLine1,
    required this.societyLine2,
    required this.societyLine3,
    required this.city,
    required this.state,
    required this.pinCode,
    required this.district
});

  factory MasterAddress.fromJson(Map<String,dynamic> json){

    return MasterAddress(
        id: json['id'],
        societyName: json['societyName'],
        societyLine1: json['societyLine1'],
        societyLine2: json['societyLine2'],
        societyLine3: json['societyLine3']??'',
        city: json['city']??'',
        state: json['state'],
        pinCode: json['pinCode'],
        district: json['district']);

  }
}