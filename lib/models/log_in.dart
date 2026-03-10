class LogInData{
  late String? phoneNumber;
  late String ?profileStatus;
  late String? signupType;
   late bool ?active;

  
    

   LogInData.fromJson(Map<String,dynamic>json){
    phoneNumber=json['phoneNumber'];
    profileStatus=json['profileStatus'];
    signupType=json['signupType'];
    active=json['active'];
   }


     Map<String, dynamic>  toJson(String phoneNumber)     {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phoneNumber'] = phoneNumber;
    data['profileStatus'] = this.profileStatus;
    data['signupType'] = this.signupType;
    data['active'] = this.active;
    return data;
  }
}