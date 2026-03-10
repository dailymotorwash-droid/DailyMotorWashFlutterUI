

class Response{
   bool isSuccess=false;
   String message= '';

  Response.fromJson(Map<String,dynamic> json){
    isSuccess = json["isSuccess"] ?? false;  // Default to false if null
    message = json["message"] ?? '';  // Default to an empty string if null
  }

  

}