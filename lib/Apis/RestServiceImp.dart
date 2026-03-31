// import 'dart:convert';
//
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:v2kart_flutter/ApiResponse/CartResponse.dart';
// import 'package:v2kart_flutter/ApiResponse/CmsResponse.dart';
// import 'package:v2kart_flutter/ApiResponse/CompleteOrder.dart';
// import 'package:v2kart_flutter/ApiResponse/Dashboard/AddressResponse.dart';
// import 'package:v2kart_flutter/ApiResponse/Dashboard/EditProfileResponse.dart';
// import 'package:v2kart_flutter/ApiResponse/Dashboard/PinCodeResponse.dart';
// import 'package:v2kart_flutter/ApiResponse/Dashboard/ProfileInfoResponse.dart';
// import 'package:v2kart_flutter/ApiResponse/Dashboard/WishListResponse.dart';
// import 'package:v2kart_flutter/ApiResponse/LoginResponse.dart';
// import 'package:v2kart_flutter/ApiResponse/OrderConfirmedResponse.dart';
// import 'package:v2kart_flutter/ApiResponse/ProductDetails/ProductColorResponse.dart';
// import 'package:v2kart_flutter/ApiResponse/ProductDetails/ProductDetailResponse.dart';
// import 'package:v2kart_flutter/ApiResponse/ProductDetails/ProductInformationResponse.dart';
// import 'package:v2kart_flutter/ApiResponse/ProductDetails/ProductSizeResponse.dart';
// import 'package:v2kart_flutter/ApiResponse/Response.dart';
// import 'package:v2kart_flutter/ApiResponse/ShippinPriceResponse.dart';
// import 'package:v2kart_flutter/ApiResponse/VerifyOTPResponse.dart';
// import 'package:v2kart_flutter/ApiResponse/pincodeResponse.dart';
// import 'package:v2kart_flutter/CommanWidget/PopUp.dart';
// import 'package:v2kart_flutter/Models/Cart.dart';
// import 'package:v2kart_flutter/Models/Category.dart' as cat;
// import 'package:v2kart_flutter/Models/Dashboard/Address.dart';
//
// import '../ApiResponse/CategoryResponse.dart';
// import '../ApiResponse/CategoryTreeResponse.dart';
// import '../ApiResponse/ProductListResponse.dart' as p;
// import 'Constraints.dart';
// import 'SlugUrl.dart';
//
// class RestServiceImp {
//   // static Future<List<cat.Category>> getMainCategories() async {
//   //   List<cat.Category> result = [];
//   //   String url = "${Constraints.baseUrl}${SlugUrl.mainCategories}";
//   //   final response = await http.get(
//   //     Uri.parse(url),
//   //   );
//   //   print("----------------------->>>>>>>>>>>${response.body}");
//   //   if (kDebugMode) {
//   //     print("getMainCategories : ${response.body}");
//   //     print("statusCode: ${response.statusCode}");
//   //     print("Url: $url");
//   //   }
//   //   if (response.statusCode == 200) {
//   //     // If the server did return a 201 CREATED response,
//   //     // then parse the JSON.
//   //     for (var i = 0; i < jsonDecode(response.body)["data"].length; i++) {
//   //       result.add(cat.Category.fromJson(jsonDecode(response.body)["data"][i]));
//   //     }
//   //     //   return CategoryResponse.fromJson(
//   //     //       jsonDecode(response.body) as Map<String, dynamic>);
//   //   }
//   //   // If the server did not return a 201 CREATED response,
//   //   // then throw an exception.
//   //   throw Exception('Failed to create album.');
//   // }
//   static Future<List<cat.Category>> getMainCategories() async {
//     List<cat.Category> result = [];
//     String url = "${Constraints.baseUrl}${SlugUrl.mainCategories}";
//
//     try {
//       final response = await http.get(Uri.parse(url));
//
//       // Debugging prints
//       if (kDebugMode) {
//         print("getMainCategories Response: ${response.body}");
//         print("statusCode: ${response.statusCode}");
//         print("Url: $url");
//       }
//
//       // Check if the response was successful (status code 200)
//       if (response.statusCode == 200) {
//         // Decode the JSON response once
//         final responseData = jsonDecode(response.body);
//
//         // Ensure that the "data" field exists and is a list
//         if (responseData["data"] != null && responseData["data"] is List) {
//           final data = responseData["data"];
//
//           // Loop through the categories and create Category objects
//           for (var categoryJson in data) {
//             result.add(cat.Category.fromJson(categoryJson));
//           }
//         } else {
//           // Handle the case when "data" is missing or not a list
//           throw Exception(
//               'Invalid data structure: "data" is missing or not a list');
//         }
//       } else {
//         // Handle HTTP errors (non-200 status codes)
//         throw Exception(
//             'Failed to load categories. Status code: ${response.statusCode}');
//       }
//     } catch (e) {
//       // Handle any other exceptions (network issues, etc.)
//       print("Error fetching categories: $e");
//       throw Exception('Error fetching categories: $e');
//     }
//
//     return result;
//   }
//
//   static Future<CategoryTreeResponse> getCategoryTree(String urlKey) async {
//     String url = "${Constraints.baseUrl}${SlugUrl.categoryTree}/$urlKey/tree";
//     final response = await http.get(
//       Uri.parse(url),
//     );
//     print("getCategoryTree : ${response.body}");
//     if (kDebugMode) {
//       print("getCategoryTree : ${response.body}");
//       print("statusCode: ${response.statusCode}");
//       print("Url: $url");
//     }
//     if (response.statusCode == 200) {
//       // If the server did return a 201 CREATED response,
//       // then parse the JSON.
//       return CategoryTreeResponse.fromJson(
//           jsonDecode(response.body) as Map<String, dynamic>);
//     }
//     // If the server did not return a 201 CREATED response,
//     // then throw an exception.
//     throw Exception('Failed to create album.');
//   }
//
//   static Future<p.ProductListResponse> getProductList(
//       String urlKey, int rows, int start) async {
//     print(
//         "---------------------------------------------->>>>>>>>>>>>>>>>>Inside the getProductList");
//     //
//     String url =
//         "${Constraints.baseUrl}${SlugUrl.productList}$urlKey&rows=$rows&start=$start&is_color_variant=true";
//
//     // String url ='https://ecomm.dotvik.com/v2kart/service/solr/search?q=*&categoryUrlKeys=women-western-topwear-sandos&rows=20&start=0&is_color_variant=true';
//     final response = await http.get(
//       Uri.parse(url),
//     );
//     if (kDebugMode) {
//       print("getProductList : ${response.body}");
//       print("statusCode: ${response.statusCode}");
//       print("Url: $url");
//     }
//     if (response.statusCode == 200) {
//       // If the server did return a 201 CREATED response,
//       // then parse the JSON.
//       return p.ProductListResponse.fromJson(
//           jsonDecode(response.body) as Map<String, dynamic>);
//     }
//     // If the server did not return a 201 CREATED response,
//     // then throw an exception.
//     throw Exception('Failed to create album.');
//   }
//
//   static Future<Map<String, dynamic>> getProductListFilters(
//       String urlKey) async {
//     String url = "${Constraints.baseUrl}${SlugUrl.productListFilters}$urlKey";
//     final response = await http.get(
//       Uri.parse(url),
//     );
//     if (kDebugMode) {
//       print("getProductListFilters : ${response.body}");
//       print("statusCode: ${response.statusCode}");
//       print("Url: $url");
//     }
//     if (response.statusCode == 200) {
//       // If the server did return a 201 CREATED response,
//       // then parse the JSON.
//       return jsonDecode(response.body) as Map<String, dynamic>;
//     }
//     // If the server did not return a 201 CREATED response,
//     // then throw an exception.
//     throw Exception('Failed to create album.');
//   }
//
//   // static Future<CmsResponse> getHomeData(String page) async {
//   //   String url = "${Constraints.baseUrl}${SlugUrl.cms}$page";
//   //   final response = await http.get(
//   //     Uri.parse(url),
//   //   );
//   //   if (kDebugMode) {
//   //     print("getHomeData : ${response.body}");
//   //     print("statusCode: ${response.statusCode}");
//   //     print("Url: $url");
//   //   }
//   //   if (response.statusCode == 200) {
//   //
//   //     return CmsResponse.fromJson(
//   //         jsonDecode(response.body) as Map<String, dynamic>);
//   //   }
//   //   // If the server did not return a 201 CREATED response,
//   //   // then throw an exception.
//   //   throw Exception('Failed to create album.');
//   // }
//   // static void printLargeJson(String json) {
//   //   final maxLength = 1000;  // Adjust this limit based on your needs
//   //   for (int i = 0; i < json.length; i += maxLength) {
//   //     final chunk = json.substring(i, i + maxLength > json.length ? json.length : i + maxLength);
//   //     print(chunk);
//   //   }
//   // }
//   static Future<CmsResponse> getHomeData(String page) async {
//     String url = "${Constraints.baseUrl}${SlugUrl.cms}$page";
//     final response = await http.get(
//       Uri.parse(url),
//     );
//
//     if (kDebugMode) {
//       print("getHomeData : ${response.body}");
//       print("statusCode: ${response.statusCode}");
//       print("Url: $url");
//     }
//
//     if (response.statusCode == 200) {
//       // Decode the response body
//       var data = jsonDecode(response.body) as Map<String, dynamic>;
//
//       // Access and sort the sections based on the 'position' field
//       var sections = data['data']['sections'] as List<dynamic>;
//       sections.sort((a, b) => a['position'].compareTo(b['position']));
//
//       // Update the original data with the sorted sections
//       data['data']['sections'] = sections;
//
//       // String sortedSectionsJson = const JsonEncoder.withIndent('  ').convert(data['data']['sections']);
//       // printLargeJson(sortedSectionsJson);
//
//       // Return CmsResponse using the fromJsonactory constructor
//       return CmsResponse.fromJson(data);
//     }
//
//     // If the server did not return a 200 response, throw an exception
//     throw Exception('Failed to load home data.');
//   }
//
//   ////Get Product Detail
//
//   static Future<ProductDetailResponse> getProductDetails(String sku) async {
//     String url = '${Constraints.baseUrl}${SlugUrl.productDetails}$sku';
//     final response = await http.get(
//       Uri.parse(url),
//     );
//     if (kDebugMode) {
//       print("getProductDetails : ${response.body}");
//       print("statusCode: ${response.statusCode}");
//       print("Url: $url");
//     }
//     if (response.statusCode == 200) {
//       return ProductDetailResponse.fromJson(
//           jsonDecode(response.body) as Map<String, dynamic>);
//     }
//
//     throw Exception('Failed to create album.');
//   }
//
//   /////Get Products size/////
//
//   static Future<ProductSizeResponse> getProductSize(String sku) async {
//     String url =
//         '${Constraints.baseUrl}${SlugUrl.productDetails}availableSizes/by/$sku';
//     final response = await http.get(
//       Uri.parse(url),
//     );
//     if (kDebugMode) {
//       print("getProductSize : ${response.body}");
//       print("statusCode: ${response.statusCode}");
//       print("Url: $url");
//     }
//     if (response.statusCode == 200) {
//       return ProductSizeResponse.fromJson(
//           jsonDecode(response.body) as Map<String, dynamic>);
//     }
//
//     throw Exception('Failed to create album.');
//   }
//
//   //////Get product Information
//
//   static Future<ProductInformationResponse> getProductInformation(
//       String sku) async {
//     String url =
//         '${Constraints.baseUrl}${SlugUrl.productDetails}attributes/by/$sku';
//     final response = await http.get(
//       Uri.parse(url),
//     );
//     if (kDebugMode) {
//       print("getProductInformation : ${response.body}");
//       print("statusCode: ${response.statusCode}");
//       print("Url: $url");
//     }
//     if (response.statusCode == 200) {
//       return ProductInformationResponse.fromJson(
//           jsonDecode(response.body) as Map<String, dynamic>);
//     }
//
//     throw Exception('Failed to create album.');
//   }
//
//   //Get Product Color
//
//   static Future<ProductColorResponse> getProductColor(String sku) async {
//     String url = '${Constraints.baseUrl}products/related/variant/by/$sku';
//     final response = await http.get(
//       Uri.parse(url),
//     );
//     if (kDebugMode) {
//       print("getProductColor : ${response.body}");
//       print("statusCode: ${response.statusCode}");
//       print("Url: $url");
//     }
//     if (response.statusCode == 200) {
//       return ProductColorResponse.fromJson(
//           jsonDecode(response.body) as Map<String, dynamic>);
//     }
//
//     throw Exception('Failed to create album.');
//   }
//
//   static Future<LogInResponse> auth(String phoneNumber) async {
//     String url = '${Constraints.baseUrl}api/auth/loginWithPhone';
//     final response = await http.post(Uri.parse(url),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({'phoneNumber': phoneNumber}));
//     if (kDebugMode) {
//       print("auth : ${response.body}");
//       print("statusCode: ${response.statusCode}");
//       print("Url: $url");
//     }
//
//     if (response.statusCode == 200) {
//       return LogInResponse.fromJson(
//           jsonDecode(response.body) as Map<String, dynamic>);
//     }
//
//     throw Exception('Failed to LogIn');
//   }
//
//   ////Verify OTP
//
//   // ignore: non_constant_identifier_names
//   static Future<VerifyOTPResponse> verifyOtp(
//       String phoneNumber, int Otp) async {
//     String url = '${Constraints.baseUrl}api/auth/verifyOtp';
//     final response = await http.post(Uri.parse(url),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode(
//             <String, dynamic>{'phoneNumber': phoneNumber, 'otp': Otp}));
//     if (kDebugMode) {
//       print("OTPVerification : ${response.body}");
//       print("statusCode: ${response.statusCode}");
//       print("Url: $url");
//     }
//
//     if (response.statusCode == 200) {
//       return VerifyOTPResponse.fromjson(
//           jsonDecode(response.body) as Map<String, dynamic>);
//     }
//     throw Exception('Failed to LogIn');
//   }
//
//   static Future<VerifyOTPResponse> getProfile(String authToken) async {
//     String url = '${Constraints.baseUrl}api/auth/verifyOtp';
//     final response = await http.get(
//       Uri.parse(url),
//       headers: {'Content-Type': 'application/json'},
//     );
//     if (kDebugMode) {
//       print("getProfile : ${response.body}");
//       print("statusCode: ${response.statusCode}");
//       print("Url: $url");
//     }
//
//     if (response.statusCode == 200) {
//       return VerifyOTPResponse.fromjson(
//           jsonDecode(response.body) as Map<String, dynamic>);
//     }
//     throw Exception('Failed to LogIn');
//   }
//
//   static Future<Response> addToCart(
//     BuildContext context,
//     int quantity,
//     String sku,
//     String token,
//   ) async {
//     String url = '${Constraints.baseUrl}${SlugUrl.addToCart}';
//     final response = await http.post(Uri.parse(url),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': '$token'
//         },
//         body: jsonEncode(<String, dynamic>{'quantity': quantity, 'sku': sku}));
//     if (kDebugMode) {
//       print("Add to cart : ${response.body}");
//       print("statusCode: ${response.statusCode}");
//       print("Url: $url");
//     }
//
//     if (response.statusCode == 200) {
//       return Response.fromJson(
//           jsonDecode(response.body) as Map<String, dynamic>);
//     } else if (response.statusCode == 403) {
//       // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>PopUp(str: "Please logIn to see your wishlist")));
//       showDialog(
//           context: context,
//           builder: (context) => PopUp(
//                 str: "Please logIn to add item to the cart",
//                 sku: '',
//                 urlKey: '',
//                 pageKey: '',
//               ));
//     }
//
//     throw Exception('Failed to LogIn');
//   }
//
//   ///Get Cart Data
//
//   static Future<CartResponse> getCartItem(String token) async {
//     String url = '${Constraints.baseUrl}${SlugUrl.getCartItem}';
//
//     final response = await http.get(
//       Uri.parse(url),
//       headers: {'Content-Type': 'application/json', 'Authorization': '$token'},
//     );
//
//     if (kDebugMode) {
//       print("getCartItem : ${response.body}");
//       print("statusCode: ${response.statusCode}");
//       print("Url: $url");
//     }
//     if (response.statusCode == 200) {
//       return CartResponse.fromJson(
//           jsonDecode(response.body) as Map<String, dynamic>);
//     } else if (response.statusCode == 403) {}
//
//     throw Exception('Failed to load Cart Item.');
//   }
//
//   ////remove item from cart
//
//   static Future<CartResponse> removeCartItem(
//       BuildContext context, String token, int sku) async
//   {
//     String url = '${Constraints.baseUrl}${SlugUrl.removeCartItem}';
//
//     final response = await http.post(Uri.parse(url),
//         headers: {'Content-Type': 'application/json', 'Authorization': token},
//         body: jsonEncode({'sku': sku}));
//
//     if (kDebugMode) {
//       print("removeCartItem : ${response.body}");
//       print("statusCode: ${response.statusCode}");
//       print("Url: $url");
//     }
//     if (response.statusCode == 200) {
//       return CartResponse.fromJson(
//           jsonDecode(response.body) as Map<String, dynamic>);
//     } else if (response.statusCode == 403) {
//       showDialog(
//           context: context,
//           builder: (context) => PopUp(
//                 str: "Please logIn to remove item from the cart",
//                 sku: '',
//                 urlKey: '',
//                 pageKey: '',
//               ));
//     }
//
//     throw Exception('Failed to load Cart Item.');
//   }
//
//   //////delete cart  item
//
//   static Future<CartResponse> deleteCartItem(
//       BuildContext context, String token, int sku) async {
//     String url = '${Constraints.baseUrl}${SlugUrl.deleteCartIte}';
//
//     final response = await http.post(Uri.parse(url),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': '$token'
//         },
//         body: jsonEncode({'sku': sku}));
//
//     if (kDebugMode) {
//       print("deleteCartItem : ${response.body}");
//       print("statusCode: ${response.statusCode}");
//       print("Url: $url");
//     }
//     if (response.statusCode == 200) {
//       return CartResponse.fromJson(
//           jsonDecode(response.body) as Map<String, dynamic>);
//     } else if (response.statusCode == 403) {
//       showDialog(
//           context: context,
//           builder: (context) => PopUp(
//                 str: "Please logIn to delete  item in the cart",
//                 sku: '',
//                 urlKey: '',
//                 pageKey: '',
//               ));
//     }
//
//     throw Exception('Failed to load Cart Item.');
//   }
//
//   //////  pincode
//
//   static Future<PinCodeResponse> PinCode(int pincode) async {
//     String url = Constraints.pincodeUrl;
//
//     final response = await http.post(Uri.parse(url),
//         headers: {
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode({'pinCode': pincode}));
//
//     if (kDebugMode) {
//       print("Pincode : ${response.body}");
//       print("statusCode: ${response.statusCode}");
//       print("Url: $url");
//     }
//     if (response.statusCode == 200) {
//       return PinCodeResponse.fromJson(
//           jsonDecode(response.body) as Map<String, dynamic>);
//     }
//
//     throw Exception('Failed to load pin code.');
//   }
//
//   //////edit Profile
//
//   static Future<EditProfileResponse> EditProfile(
//       String DOB,
//       String email,
//       String firstName,
//       String lastName,
//       String gender,
//       String income,
//       String phoneNumber,
//       String token) async {
//     String url = '${Constraints.baseUrl}${SlugUrl.auth}update/me';
//     print("dob-->>>>>>>>>>>>>>$DOB>>");
//     final response = await http.put(Uri.parse(url),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': '$token'
//         },
//         body: jsonEncode({
//           "dateOfBirth": DOB,
//           "email": email,
//           "firstName": firstName,
//           "gender": gender,
//           "incomeGroup": income,
//           "lastName": lastName,
//           "phoneNumber": phoneNumber
//         }));
//
//     if (kDebugMode) {
//       print("EditProfile : ${response.body}");
//       print("statusCode: ${response.statusCode}");
//       print("Url: $url");
//     }
//     if (response.statusCode == 200) {
//       return EditProfileResponse.fromJson(
//           jsonDecode(response.body) as Map<String, dynamic>);
//     }
//     throw Exception('Failed to edit profile.');
//   }
//
//   ////////get Profile Information
//
//   static Future<ProfileInfoResponse> getProfileInfo(String token) async {
//     String url = '${Constraints.baseUrl}${SlugUrl.auth}me';
//
//     print(
//         "-------------------------------->>>>Inside the getProfileInfo<<<<<<<<<<-----------------------");
//     final response = await http.get(
//       Uri.parse(url),
//       headers: {'Content-Type': 'application/json', 'Authorization': '$token'},
//     );
//
//     if (kDebugMode) {
//       print("getProfileInfo : ${response.body}");
//       print("statusCode: ${response.statusCode}");
//       print("Url: $url");
//       print('Token :$token');
//     }
//     if (response.statusCode == 200) {
//       return ProfileInfoResponse.fromJson(
//           jsonDecode(response.body) as Map<String, dynamic>);
//     }
//
//     throw Exception('Failed to get profile.');
//   }
//   /////Add Address////
//
//   static Future<AddressResponse> AddAddressService(
//       String area,
//       String city,
//       String firstName,
//       String email,
//       String lastName,
//       String landmark,
//       String phoneNumber,
//       String token,
//       String pinCode,
//       String state,
//       String streetAddress,
//       String type) async {
//     String url = '${Constraints.baseUrl}address/add';
//
//     final response = await http.post(Uri.parse(url),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': '$token'
//         },
//         body: jsonEncode({
//           "area": area,
//           "city": city,
//           "dialCode": "+91",
//           "email": email,
//           "firstName": firstName,
//           "landmark": landmark,
//           "lastName": lastName,
//           "phoneNumber": phoneNumber,
//           "pinCode": pinCode,
//           "state": state,
//           "streetAddress": streetAddress,
//           "type": type
//         }));
//
//     if (kDebugMode) {
//       print("Add Address : ${response.body}");
//       print("statusCode: ${response.statusCode}");
//       print("Url: $url");
//     }
//     if (response.statusCode == 200) {
//       return AddressResponse.fromJson(
//           jsonDecode(response.body) as Map<String, dynamic>);
//     }
//     throw Exception('Failed to add address');
//   }
//
//   ///////pinCode Address
//   static Future<PincodeAddressResponse> getPinCodeAddress(
//       String pincode) async {
//     // String url = "${Constraints.baseUrl}${SlugUrl.cms}$page";
//     String url = "${Constraints.url}/v2kart/oms/api/getPinCode/$pincode";
//     final response = await http.get(
//       Uri.parse(url),
//     );
//     if (kDebugMode) {
//       print("PinCodeResponse : ${response.body}");
//       print("statusCode: ${response.statusCode}");
//       print("Url: $url");
//     }
//     if (response.statusCode == 200) {
//       // If the server did return a 201 CREATED response,
//       // then parse the JSON.
//       return PincodeAddressResponse.fromJson(
//           jsonDecode(response.body) as Map<String, dynamic>);
//     }
//     // If the server did not return a 201 CREATED response,
//     // then throw an exception.
//     throw Exception('Failed to load pincode Response ');
//   }
//
//   ////delete Address
//   static Future<Response> deleteAddress(String id, String token) async {
//     // String url = "${Constraints.baseUrl}${SlugUrl.cms}$page";
//     String url = "https://ecomm.dotvik.com/v2kart/service/address/$id/delete";
//     final response = await http.delete(
//       headers: {'Content-Type': 'application/json', 'Authorization': '$token'},
//       Uri.parse(url),
//     );
//
//     if (kDebugMode) {
//       print(" delete Address  : ${response.body}");
//       print("statusCode: ${response.statusCode}");
//       print("Url: $url");
//     }
//     if (response.statusCode == 200) {
//       // If the server did return a 201 CREATED response,
//       // then parse the JSON.
//       return Response.fromJson(
//           jsonDecode(response.body) as Map<String, dynamic>);
//     }
//     // If the server did not return a 201 CREATED response,
//     // then throw an exception.
//     throw Exception('Failed to delete address ');
//   }
//
//   ////Add Item to wishList
//
//   static Future<WishListResponse> addToWishList(
//       String token, String sku) async {
//     String url = '${Constraints.baseUrl}${SlugUrl.wishList}/add';
//
//     final response = await http.post(Uri.parse(url),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': '$token'
//         },
//         body: jsonEncode({"sku": sku}));
//
//     if (kDebugMode) {
//       print("Add to WishList : ${response.body}");
//       print("statusCode: ${response.statusCode}");
//       print("Url: $url");
//     }
//     if (response.statusCode == 200) {
//       return WishListResponse.fromJson(
//           jsonDecode(response.body) as Map<String, dynamic>);
//     } else if (response.statusCode == 403) {}
//
//     throw Exception('Filed to add WishList');
//   }
//
//   ///////remove wishlist Item//////
//
//   static Future<Response> removeWishListItem(String token, String sku) async {
//     String url = 'https://ecomm.dotvik.com/v2kart/service/api/wishlist/remove';
//
//     final response = await http.delete(Uri.parse(url),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': '$token'
//         },
//         body: jsonEncode({"sku": sku}));
//
//     if (kDebugMode) {
//       print("deleteWishListItem : ${response.body}");
//       print("statusCode: ${response.statusCode}");
//       print("Url: $url");
//     }
//     if (response.statusCode == 200) {
//       return Response.fromJson(
//           jsonDecode(response.body) as Map<String, dynamic>);
//     } else if (response.statusCode == 403) {}
//
//     throw Exception('Failed to delete wishList item');
//   }
//
//   //////////Get Wish List item///////
//
//   static Future<WishListResponse> getWishListItem(String token) async {
//     String url = '${Constraints.baseUrl}${SlugUrl.wishList}';
//
//     final response = await http.get(
//       Uri.parse(url),
//       headers: {'Content-Type': 'application/json', 'Authorization': '$token'},
//     );
//
//     if (kDebugMode) {
//       print("getwishList : ${response.body}");
//       print("statusCode: ${response.statusCode}");
//       print("Url: $url");
//       print("Token${token}");
//     }
//     if (response.statusCode == 200) {
//       return WishListResponse.fromJson(
//           jsonDecode(response.body) as Map<String, dynamic>);
//     }
//
//     throw Exception('Failed to get wishListItem.');
//   }
//
//   ////shipping Charges
//
//   static Future<ShippingPriceResponse> shippingPrice(int total) async {
//     String url = "${Constraints.url}${SlugUrl.shippingPrice}";
//     final response = await http.post(Uri.parse(url),
//         headers: {
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode({"totalPrice": total}));
//     if (kDebugMode) {
//       print("Shipping Price  : ${response.body}");
//       print("statusCode: ${response.statusCode}");
//       print("Url: $url");
//     }
//     if (response.statusCode == 200) {
//       return ShippingPriceResponse.fromJson(
//           jsonDecode(response.body) as Map<String, dynamic>);
//     } else if (response.statusCode == 403) {}
//
//     throw Exception('Filed to  load Shipping Price ');
//   }
//
//   /////// Coupon Validation/////
//
//   static Future<Response> couponCodeValidation(
//       String couponcode, String token) async {
//     String url = "${Constraints.baseUrl}${SlugUrl.couponCode}";
//     final response = await http.post(Uri.parse(url),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': '$token'
//         },
//         body: jsonEncode({"couponCode": couponcode}));
//     if (kDebugMode) {
//       print("Shipping Price  : ${response.body}");
//       print("statusCode: ${response.statusCode}");
//       print("Url: $url");
//     }
//     if (response.statusCode == 200) {
//       return Response.fromJson(
//           jsonDecode(response.body) as Map<String, dynamic>);
//     } else if (response.statusCode == 403) {}
//
//     throw Exception('Filed to  load Shipping Price ');
//   }
//
//   ////Complete Order ///////
//
//   static Future<CompleteOrderResponse> CompleteOrder(
//     List<CartData> data,
//     AddressData customerDeliveryAddress,
//     String paymentMethod,
//     String paymentMode,
//     String paymentTransactionId,
//     int customerId,
//     // String cartId,
//
//     String token,
//   ) async {
//     String url = "${Constraints.url}${SlugUrl.generateOrder}";
//     final response = await http.post(Uri.parse(url),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': '$token'
//         },
//         body: jsonEncode({
//           ///
//           "data": data.map((cart) => cart.toJson()).toList(),
//           "customerDeliveryAddress": customerDeliveryAddress.toJson(),
//           "paymentMethod": paymentMethod,
//           "paymentMode": paymentMode,
//           "paymentTransactionId": paymentTransactionId,
//           "customerId": customerId,
//           // "cartId":cartId
//         }));
//     if (kDebugMode) {
//       print("Complete Order  : ${response.body}");
//       print("statusCode: ${response.statusCode}");
//       print("Url: $url");
//     }
//     if (response.statusCode == 200) {
//       return CompleteOrderResponse.fromJson(
//           jsonDecode(response.body) as Map<String, dynamic>);
//     } else if (response.statusCode == 403) {}
//
//     throw Exception('Filed to  load Complete Order');
//   }
//
//   /////cart Item Validation  ///////
//
//   static Future<Response> cartItemValidation(String token) async {
//     String url =
//         "https://ecomm.dotvik.com/v2kart/oms/api/validateCartItemsAvailability";
//     final response = await http.post(Uri.parse(url),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': '$token'
//         },
//         body: jsonEncode({}));
//     if (kDebugMode) {
//       print("validateCartItem  : ${response.body}");
//       print("statusCode: ${response.statusCode}");
//       print("Url: $url");
//     }
//     if (response.statusCode == 200) {
//       return Response.fromJson(
//           jsonDecode(response.body) as Map<String, dynamic>);
//     } else if (response.statusCode == 403) {}
//
//     throw Exception('Filed to  validate cart Item ');
//   }
//   //////OrderConfirmed Api   //////
//
//   static Future<OrderConfirmedResponse> OrderConfirmed(
//       String id, String token) async {
//     String url = "${Constraints.url}/v2kart/oms/api/order/$id";
//     final response = await http.get(
//       headers: {'Content-Type': 'application/json', 'Authorization': '$token'},
//       Uri.parse(url),
//     );
//     if (kDebugMode) {
//       print("OrderConfirmed : ${response.body}");
//       print("statusCode: ${response.statusCode}");
//       print("Url: $url");
//     }
//     if (response.statusCode == 200) {
//       // If the server did return a 201 CREATED response,
//       // then parse the JSON.
//       return OrderConfirmedResponse.fromJson(
//           jsonDecode(response.body) as Map<String, dynamic>);
//     }
//     // If the server did not return a 201 CREATED response,
//     // then throw an exception.
//     throw Exception('Failed to load Confirm Order Response ');
//   }
// }
import 'dart:convert';

import 'package:dmw/ApiResponse/address_response.dart';
import 'package:dmw/ApiResponse/brand_response.dart';
import 'package:dmw/ApiResponse/plan_response.dart';
import 'package:dmw/ApiResponse/razorpay_response.dart';
import 'package:dmw/ApiResponse/referral_code_response.dart';
import 'package:dmw/ApiResponse/search_address_response.dart';
import 'package:dmw/ApiResponse/subscription_response.dart';
import 'package:dmw/ApiResponse/subscription_vehicle_response.dart';
import 'package:dmw/ApiResponse/transactions_response.dart';
import 'package:dmw/ApiResponse/user_profile_response.dart';
import 'package:dmw/ApiResponse/vehicle_color_response.dart';
import 'package:dmw/ApiResponse/vehicle_model_response.dart';
import 'package:dmw/ApiResponse/vehicle_response.dart';
import 'package:dmw/Apis/SlugUrl.dart';
import 'package:dmw/models/address.dart';
import 'package:dmw/models/subscription.dart';
import 'package:dmw/models/user.dart';
import 'package:dmw/models/vehicle.dart';
import 'package:dmw/models/vehicle_and_address.dart';
import 'package:dmw/utils/local_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../ApiResponse/LoginResponse.dart';
import '../ApiResponse/Response.dart';
import '../ApiResponse/VerifyOTPResponse.dart';
import '../ApiResponse/add_vehicle_and_address_response.dart';
import 'Constraints.dart';

class RestServiceImp {

  static Future<Response> otpSend(String phoneNumber) async {
    String url = '${Constraints.baseUrl}${SlugUrl.sendOtp}';
    final response = await http.post(Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phone': phoneNumber}));
    if (kDebugMode) {
      print("auth : ${response.body}");
      print("statusCode: ${response.statusCode}");
      print("Url: $url");
    }

    if (response.statusCode == 200) {
      return Response.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    }

    throw Exception('Failed to LogIn');
  }

  static Future<LogInResponse> auth(String phoneNumber,String otp,String? code) async {
    String url = '${Constraints.baseUrl}${SlugUrl.login}';
    final response = await http.post(Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phone': phoneNumber,'otp':otp,"referralCode":code}));
    if (kDebugMode) {
      print("auth : ${response.body}");
      print("statusCode: ${response.statusCode}");
      print("Url: $url");
    }

    if (response.statusCode == 200) {
      return LogInResponse.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    }

    throw Exception('Failed to LogIn');
  }

  ////Verify OTP

  // ignore: non_constant_identifier_names
  static Future<VerifyOTPResponse> verifyOtp(
      String phoneNumber, int Otp) async {
    String url = '${Constraints.baseUrl}api/auth/verifyOtp';
    final response = await http.post(Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(
            <String, dynamic>{'phoneNumber': phoneNumber, 'otp': Otp}));
    if (kDebugMode) {
      print("OTPVerification : ${response.body}");
      print("statusCode: ${response.statusCode}");
      print("Url: $url");
    }

    if (response.statusCode == 200) {
      return VerifyOTPResponse.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    }
    throw Exception('Failed to LogIn');
  }

  static Future<UserProfileResponse> getProfile() async {
    String url = '${Constraints.baseUrl}${SlugUrl.profile}';
    var storage = await LocalStorage.getInstance();
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': '${storage.getToken()}'
      });
    if (kDebugMode) {
      print("getProfile : ${response.body}");
      print("statusCode: ${response.statusCode}");
      print("Url: $url");
    }

    if (response.statusCode == 200) {
      return UserProfileResponse.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    }
    throw Exception('Failed to LogIn');
  }





  //////edit Profile
  static Future<void> updateAddress(
      String addressId, Map<String, dynamic> addressInfo, String token) async {
    final String apiUrl =
        'https://ecomm.dotvik.com/v2kart/service/address/update/$addressId';

    // Prepare headers
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token', // Adding Authorization Token
    };

    // Convert addressInfo Map to JSON String
    String jsonBody = jsonEncode(addressInfo);

    // Make the PUT request
    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonBody,
      );

      if (response.statusCode == 200) {
        print('Address updated successfully');
        if (kDebugMode) {
          print("updateAddress : ${response.body}");
          print("statusCode: ${response.statusCode}");
          print("Url: $apiUrl");
        }

        // Handle response if needed
      } else {
        print('Failed to update address: ${response.body}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  //////User Vehicles
  static Future<VehicleResponse> getUserVehicles(String? token,String vehicleType) async {
    final String apiUrl ='${Constraints.baseUrl}${SlugUrl.getVehicles.replaceAll("{vehicleType}", vehicleType)}';
    debugPrint(token);
    // Prepare headers
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': '$token', // Adding Authorization Token
    };

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: headers,
      );

    if (kDebugMode) {
      print("auth : ${response.body}");
      print("statusCode: ${response.statusCode}");
      print("Url: $apiUrl");
    }
      if (response.statusCode == 200) {
          return VehicleResponse.fromJson(
              jsonDecode(response.body) as Map<String, dynamic>);
        // Handle response if needed
      }
        throw Exception('Failed to Fetch Vehicles');

  }

  //////User Services
  static Future<PlanResponse> getUserServices(String? token,String vehicleType,String vehicleSize,int addressId) async {
    final String apiUrl ='${Constraints.baseUrl}${SlugUrl.getServices.replaceAll("{vehicleType}", vehicleType).replaceAll("{addressId}", '$addressId')}?vehicleSize=$vehicleSize';
    debugPrint(token);
    // Prepare headers
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': '$token', // Adding Authorization Token
    };

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: headers,
    );

    if (kDebugMode) {
      print("auth : ${response.body}");
      print("statusCode: ${response.statusCode}");
      print("Url: $apiUrl");
    }
    if (response.statusCode == 200) {
      return PlanResponse.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
      // Handle response if needed
    }
    throw Exception('Failed to Fetch Vehicles');

  }

  ////Get Address
  static Future<AddressResponse> getUserAddresses() async {
    var storage = await LocalStorage.getInstance();
    final String apiUrl ='${Constraints.baseUrl}${SlugUrl.getAddresses}';
    // Prepare headers
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': '${storage.getToken()}', // Adding Authorization Token
    };

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: headers,
    );

    if (kDebugMode) {
      print("auth : ${response.body}");
      print("statusCode: ${response.statusCode}");
      print("Url: $apiUrl");
    }
    if (response.statusCode == 200) {
      return AddressResponse.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
      // Handle response if needed
    }
    throw Exception('Failed to Fetch Vehicles');

  }

  ////Get Brands
  static Future<BrandResponse> getBrands(String? token,bool isCar) async {
    final String apiUrl ='${Constraints.baseUrl}${SlugUrl.getBrands}?isCar=$isCar';
    // Prepare headers
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': '$token', // Adding Authorization Token
    };

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: headers,
    );

    if (kDebugMode) {
      print("auth : ${response.body}");
      print("statusCode: ${response.statusCode}");
      print("Url: $apiUrl");
    }
    if (response.statusCode == 200) {
      return BrandResponse.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
      // Handle response if needed
    }
    throw Exception('Failed to Fetch Vehicles');

  }

  ///Get Models
  static Future<VehicleModelResponse> getModels(String? token,int brandId,String vehicleType) async {
    final String apiUrl ='${Constraints.baseUrl}${SlugUrl.getModels.replaceAll("{brandId}", '$brandId')}?vehicleType=$vehicleType';
    debugPrint(token);
    // Prepare headers
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': '$token', // Adding Authorization Token
    };

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: headers,
    );

    if (kDebugMode) {
      print("auth : ${response.body}");
      print("statusCode: ${response.statusCode}");
      print("Url: $apiUrl");
    }
    if (response.statusCode == 200) {
      return VehicleModelResponse.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
      // Handle response if needed
    }
    throw Exception('Failed to Fetch Vehicles');

  }

  ///Get Colors
  static Future<VehicleColorResponse> getColors(String? token,int modelId) async {
    final String apiUrl ='${Constraints.baseUrl}${SlugUrl.getColors.replaceAll("{modelId}", '$modelId')}';
    debugPrint(token);
    // Prepare headers
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': '$token', // Adding Authorization Token
    };

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: headers,
    );

    if (kDebugMode) {
      print("auth : ${response.body}");
      print("statusCode: ${response.statusCode}");
      print("Url: $apiUrl");
    }
    if (response.statusCode == 200) {
      return VehicleColorResponse.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
      // Handle response if needed
    }
    throw Exception('Failed to Fetch Vehicles');

  }

  ///Search Address
  static Future<SearchAddressResponse> searchAddress(String? token,String q) async {
    final String apiUrl ='${Constraints.baseUrl}${SlugUrl.searchAddress}?q=$q';
    debugPrint(token);
    // Prepare headers
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': '$token', // Adding Authorization Token
    };

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: headers,
    );

    if (kDebugMode) {
      print("auth : ${response.body}");
      print("statusCode: ${response.statusCode}");
      print("Url: $apiUrl");
    }
    if (response.statusCode == 200) {
      return SearchAddressResponse.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
      // Handle response if needed
    }
    throw Exception('Failed to Fetch Vehicles');

  }
  // Add Vehicle
  static Future<VehicleResponse> addVehicle(
      Vehicle vehicle) async {
    var storage = await LocalStorage.getInstance();
    String url = '${Constraints.baseUrl}${SlugUrl.addVehicle}';
    final response = await http.post(Uri.parse(url),
        headers: {'Content-Type': 'application/json','Authorization': '${storage.getToken()}'
        },
        body: jsonEncode(vehicle.toJson()));
    if (kDebugMode) {
      print("OTPVerification : ${response.body}");
      print("statusCode: ${response.statusCode}");
      print("Url: $url");
    }

    if (response.statusCode == 200) {
      return VehicleResponse.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    }
    throw Exception('Failed to LogIn');
  }

  // Add Vehicle and address
  static Future<AddVehicleAndAddressResponse> addVehicleAndAddress(
      VehicleAndAddress vehicle) async {
    var storage = await LocalStorage.getInstance();
    String url = '${Constraints.baseUrl}${SlugUrl.addVehicleAndAddress}';
    final response = await http.post(Uri.parse(url),
        headers: {'Content-Type': 'application/json','Authorization': '${storage.getToken()}'
        },
        body: jsonEncode(vehicle.toJson()));
    if (kDebugMode) {
      print("OTPVerification : ${response.body}");
      print("statusCode: ${response.statusCode}");
      print("Url: $url");
    }

    if (response.statusCode == 200) {
      return AddVehicleAndAddressResponse.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    }
    throw Exception('Failed to LogIn');
  }

  // Add Vehicle and address
  static Future<SubscriptionResponse> subscribe(
      Subscription subscription) async {
    var storage = await LocalStorage.getInstance();
    String url = '${Constraints.baseUrl}${SlugUrl.subscribe}';
    final response = await http.post(Uri.parse(url),
        headers: {'Content-Type': 'application/json','Authorization': '${storage.getToken()}'
        },
        body: jsonEncode(subscription.toJson()));
    if (kDebugMode) {
      print("OTPVerification : ${response.body}");
      print("statusCode: ${response.statusCode}");
      print("Url: $url");
    }

    if (response.statusCode == 200) {
      return SubscriptionResponse.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    }
    throw Exception('Failed to LogIn');
  }

  ///Subscriptions
  static Future<SubscriptionVehicleResponse> getSubscriptionWithVehicles() async {
    var storage = await LocalStorage.getInstance();
    final String apiUrl ='${Constraints.baseUrl}${SlugUrl.subscriptionWithVehicle}';
    debugPrint(storage.getToken());
    // Prepare headers
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': '${storage.getToken()}', // Adding Authorization Token
    };

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: headers,
    );

    if (kDebugMode) {
      print("auth : ${response.body}");
      print("statusCode: ${response.statusCode}");
      print("Url: $apiUrl");
    }
    if (response.statusCode == 200) {
      return SubscriptionVehicleResponse.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
      // Handle response if needed
    }
    throw Exception('Failed to Fetch Vehicles');

  }
static Future<UserProfileResponse> editProfile(User user) async {
    String url = '${Constraints.baseUrl}${SlugUrl.updateUser}';
    var storage = await LocalStorage.getInstance();
    final response = await http.put(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '${storage.getToken()}'
        },
        body: jsonEncode(user.toJson()));

    if (kDebugMode) {
      print("EditProfile : ${response.body}");
      print("statusCode: ${response.statusCode}");
      print("Url: $url");
    }
    if (response.statusCode == 200) {
      return UserProfileResponse.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    }
    throw Exception('Failed to edit profile.');
  }


  ///Get All Vehicles
  static Future<VehicleResponse> getAllVehicles() async {
    var storage = await LocalStorage.getInstance();
    final String apiUrl ='${Constraints.baseUrl}${SlugUrl.getAllVehicles}';
    debugPrint(storage.getToken());
    // Prepare headers
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': '${storage.getToken()}', // Adding Authorization Token
    };

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: headers,
    );

    if (kDebugMode) {
      print("auth : ${response.body}");
      print("statusCode: ${response.statusCode}");
      print("Url: $apiUrl");
    }
    if (response.statusCode == 200) {
      return VehicleResponse.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
      // Handle response if needed
    }
    throw Exception('Failed to Fetch Vehicles');

  }

  ///Update Vehicle
  static Future<VehicleResponse> updateVehicle(Vehicle vehicle) async {
    var storage = await LocalStorage.getInstance();
    final String apiUrl ='${Constraints.baseUrl}${SlugUrl.updateVehicle}';
    debugPrint(storage.getToken());
    // Prepare headers
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': '${storage.getToken()}', // Adding Authorization Token
    };

    final response = await http.put(
      Uri.parse(apiUrl),
      headers: headers,
        body: jsonEncode(vehicle.toJson())

    );

    if (kDebugMode) {
      print("auth : ${response.body}");
      print("statusCode: ${response.statusCode}");
      print("Url: $apiUrl");
    }
    if (response.statusCode == 200) {
      return VehicleResponse.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
      // Handle response if needed
    }
    throw Exception('Failed to Fetch Vehicles');

  }


  ///Get Brand By Name
  static Future<BrandResponse> getBrandByName(String name) async {
    var storage = await LocalStorage.getInstance();
    final String apiUrl ='${Constraints.baseUrl}${SlugUrl.getBrandByName.replaceAll("{brand}", name)}';
    debugPrint(storage.getToken());
    // Prepare headers
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': '${storage.getToken()}', // Adding Authorization Token
    };

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: headers,
    );

    if (kDebugMode) {
      print("auth : ${response.body}");
      print("statusCode: ${response.statusCode}");
      print("Url: $apiUrl");
    }
    if (response.statusCode == 200) {
      return BrandResponse.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
      // Handle response if needed
    }
    throw Exception('Failed to Fetch Vehicles');

  }

  ///Get Model By Name
  static Future<VehicleModelResponse> getModelByName(String name) async {
    var storage = await LocalStorage.getInstance();
    final String apiUrl ='${Constraints.baseUrl}${SlugUrl.getModelByName}?model=$name';
    debugPrint(storage.getToken());
    // Prepare headers
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': '${storage.getToken()}', // Adding Authorization Token
    };

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: headers,
    );

    if (kDebugMode) {
      print("auth : ${response.body}");
      print("statusCode: ${response.statusCode}");
      print("Url: $apiUrl");
    }
    if (response.statusCode == 200) {
      return VehicleModelResponse.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
      // Handle response if needed
    }
    throw Exception('Failed to Fetch Vehicles');

  }

  ///Get Color By Name
  static Future<VehicleColorResponse> getColorByName(String name) async {
    var storage = await LocalStorage.getInstance();
    final String apiUrl ='${Constraints.baseUrl}${SlugUrl.getColorByName}?color=$name';
    debugPrint(storage.getToken());
    // Prepare headers
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': '${storage.getToken()}', // Adding Authorization Token
    };

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: headers,
    );

    if (kDebugMode) {
      print("auth : ${response.body}");
      print("statusCode: ${response.statusCode}");
      print("Url: $apiUrl");
    }
    if (response.statusCode == 200) {
      return VehicleColorResponse.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
      // Handle response if needed
    }
    throw Exception('Failed to Fetch Vehicles');

  }

  static Future<AddressResponse> getUserAddressesByVehicleId(String vehicleId) async {
    var storage = await LocalStorage.getInstance();
    final String apiUrl ='${Constraints.baseUrl}${SlugUrl.getAddressesByVehicleId.replaceAll("{VehicleId}", vehicleId)}';
    // Prepare headers
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': '${storage.getToken()}', // Adding Authorization Token
    };

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: headers,
    );

    if (kDebugMode) {
      print("auth : ${response.body}");
      print("statusCode: ${response.statusCode}");
      print("Url: $apiUrl");
    }
    if (response.statusCode == 200) {
      return AddressResponse.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
      // Handle response if needed
    }
    throw Exception('Failed to Fetch Vehicles');
  }

  static Future<AddressResponse> addUserAddress(Address add) async {

    String url = '${Constraints.baseUrl}${SlugUrl.addAddress}';
    var storage = await LocalStorage.getInstance();
    final response = await http.post(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '${storage.getToken()}'
        },
        body: jsonEncode(add.toJson()));

    if (kDebugMode) {
      print("Add Address : ${response.body}");
      print("statusCode: ${response.statusCode}");
      print("Url: $url");
    }
    if (response.statusCode == 200) {
      return AddressResponse.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    }
    throw Exception('Failed to edit profile.');

  }

  static Future<AddressResponse> updateUserAddress(Address add) async {

    String url = '${Constraints.baseUrl}${SlugUrl.updateAddress}';
    var storage = await LocalStorage.getInstance();
    final response = await http.put(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '${storage.getToken()}'
        },
        body: jsonEncode(add.toJson()));

    if (kDebugMode) {
      print("Add Address : ${response.body}");
      print("statusCode: ${response.statusCode}");
      print("Url: $url");
    }
    if (response.statusCode == 200) {
      return AddressResponse.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    }
    throw Exception('Failed to edit profile.');

  }

  ///Transactions
  static Future<TransactionsResponse> getTransactions() async {
    final String apiUrl ='${Constraints.baseUrl}${SlugUrl.getTransactions}';
    var storage = await LocalStorage.getInstance();
    debugPrint(storage.getToken());
    // Prepare headers
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': '${storage.getToken()}', // Adding Authorization Token
    };

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: headers,
    );

    if (kDebugMode) {
      print("auth : ${response.body}");
      print("statusCode: ${response.statusCode}");
      print("Url: $apiUrl");
    }
    if (response.statusCode == 200) {
      return TransactionsResponse.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
      // Handle response if needed
    }
    throw Exception('Failed to Fetch Vehicles');

  }


  static Future<SubscriptionResponse> checkFirstOrExpireSubscription(String addressId,String vehicleId) async {
    var storage = await LocalStorage.getInstance();
    final String apiUrl ='${Constraints.baseUrl}${SlugUrl.checkFirstOrExpireSubscription.replaceAll("{addressId}", addressId).replaceAll("{vehicleId}", vehicleId)}';
    // Prepare headers
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': '${storage.getToken()}', // Adding Authorization Token
    };

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: headers,
    );

    if (kDebugMode) {
      print("auth : ${response.body}");
      print("statusCode: ${response.statusCode}");
      print("Url: $apiUrl");
    }
    if (response.statusCode == 200) {
      return SubscriptionResponse.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
      // Handle response if needed
    }
    throw Exception('Failed to Fetch Vehicles');
  }


  static Future<RazorpayResponse> createRazorpayOrder(Map<String,dynamic> data) async {

    String url = '${Constraints.baseUrl}${SlugUrl.createRazorpayOrder}';
    var storage = await LocalStorage.getInstance();
    final response = await http.post(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '${storage.getToken()}'
        },
        body: jsonEncode(data));

    if (kDebugMode) {
      print("Add Address : ${response.body}");
      print("statusCode: ${response.statusCode}");
      print("Url: $url");
    }
    if (response.statusCode == 200) {
      return RazorpayResponse.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    }
    throw Exception('Failed to edit profile.');

  }

  static Future<Response> verifyPayment(Map<String, dynamic> data) async {

    String url = '${Constraints.baseUrl}${SlugUrl.verifyRazorpayOrder}';
    var storage = await LocalStorage.getInstance();
    final response = await http.post(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '${storage.getToken()}'
        },
        body: jsonEncode(data));

    if (kDebugMode) {
      print("Add Address : ${response.body}");
      print("statusCode: ${response.statusCode}");
      print("Url: $url");
    }
    if (response.statusCode == 200) {
      return Response.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    }
    throw Exception('Failed to edit profile.');
  }

  static Future<ReferralCodeResponse> getReferralLink() async {
    var storage = await LocalStorage.getInstance();
    final String apiUrl ='${Constraints.baseUrl}${SlugUrl.getReferral}';
    // Prepare headers
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': '${storage.getToken()}', // Adding Authorization Token
    };

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: headers,
    );

    if (kDebugMode) {
      print("auth : ${response.body}");
      print("statusCode: ${response.statusCode}");
      print("Url: $apiUrl");
    }
    if (response.statusCode == 200) {
      return ReferralCodeResponse.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
      // Handle response if needed
    }
    throw Exception('Failed to Fetch Vehicles');

  }
/////Add Address////

  // static Future<AddressResponse> AddAddressService(
  //     String area,
  //     String city,
  //     String firstName,
  //     String email,
  //     String lastName,
  //     String landmark,
  //     String phoneNumber,
  //     String token,
  //     String pinCode,
  //     String state,
  //     String streetAddress,
  //     String type) async
  // {
  //   String url = '${Constraints.baseUrl}address/add';
  //
  //   final response = await http.post(Uri.parse(url),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': '$token'
  //       },
  //       body: jsonEncode({
  //         "area": area,
  //         "city": city,
  //         "dialCode": "+91",
  //         "email": email,
  //         "firstName": firstName,
  //         "landmark": landmark,
  //         "lastName": lastName,
  //         "phoneNumber": phoneNumber,
  //         "pinCode": pinCode,
  //         "state": state,
  //         "streetAddress": streetAddress,
  //         "type": type
  //       }));
  //
  //   if (kDebugMode) {
  //     print("Add Address : ${response.body}");
  //     print("statusCode: ${response.statusCode}");
  //     print("Url: $url");
  //   }
  //   if (response.statusCode == 200) {
  //     return AddressResponse.fromJson(
  //         jsonDecode(response.body) as Map<String, dynamic>);
  //   }
  //   throw Exception('Failed to add address');
  // }
  // static Future<AddressResponse> AddAddressService
  //     (
  //     // String area,
  //     // String city,
  //     // String firstName,
  //     // String email,
  //     // String lastName,
  //     // String landmark,
  //     // String phoneNumber,
  //     String token,
  //     // String pinCode,
  //     // String state,
  //     // String streetAddress,
  //     // String type,
  //     Map<String, dynamic> addressInfo) async
  // {
  //   String url = '${Constraints.baseUrl}address/add';
  //
  //   final response = await http.post(Uri.parse(url),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': '$token'
  //       },
  //       body: jsonEncode(
  //           //     {
  //           //   "area": area,
  //           //   "city": city,
  //           //   "dialCode": "+91",
  //           //   "email": email,
  //           //   "firstName": firstName,
  //           //   "landmark": landmark,
  //           //   "lastName": lastName,
  //           //   "phoneNumber": phoneNumber,
  //           //   "pinCode": pinCode,
  //           //   "state": state,
  //           //   "streetAddress": streetAddress,
  //           //   "type": type
  //           // }
  //           addressInfo));
  //
  //   if (kDebugMode) {
  //     print("Add Address : ${response.body}");
  //     print("statusCode: ${response.statusCode}");
  //     print("Url: $url");
  //   }
  //   if (response.statusCode == 200) {
  //     return AddressResponse.fromJson(
  //         jsonDecode(response.body) as Map<String, dynamic>);
  //   }
  //   throw Exception('Failed to add address');
  // }



}
