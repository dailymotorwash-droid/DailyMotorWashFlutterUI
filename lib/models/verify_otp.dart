class VerifyOTP{

  late int id;
  late String username;
  late String phoneNumber;
  late String profileStatus;
  late String token;
  late String role;
  late bool active;

  VerifyOTP.fromJson(Map<String , dynamic> json){
    id=json['id'];
    username=json['userName']??'';
    phoneNumber=json['phoneNumber']??'';
    profileStatus=json['profileStatus']??"";
    token=json['token']??'';
    role=json['role']??'';
     active=json['active']??'';





  }

}