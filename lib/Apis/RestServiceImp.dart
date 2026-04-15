
import 'dart:convert';

import 'package:dio/dio.dart' hide Response;
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

import '../ApiResponse/LoginResponse.dart';
import '../ApiResponse/Response.dart';
import '../ApiResponse/add_vehicle_and_address_response.dart';
import 'ApiClient.dart';
import 'Constraints.dart';

class RestServiceImp {

  static Future<Response> otpSend(String phoneNumber) async {
    final dio = ApiClient().dio;

    final response = await dio.post(SlugUrl.sendOtp,
        data: jsonEncode({'phone': phoneNumber}));
    if (response.statusCode == 200) {
      return Response.fromJson(
          (response.data) as Map<String, dynamic>);
    }

    throw Exception('Failed to LogIn');
  }

  static Future<LogInResponse> auth(String phoneNumber,String otp,String? code) async {
    final dio = ApiClient().dio;

    final response = await dio.post(SlugUrl.login,
        data: jsonEncode({'phone': phoneNumber,'otp':otp,"referralCode":code}));

    if (response.statusCode == 200) {
      return LogInResponse.fromJson(
          (response.data) as Map<String, dynamic>);
    }

    throw Exception('Failed to LogIn');
  }
  static Future<UserProfileResponse> getProfile() async {
    final dio = ApiClient().dio;
    var storage = await LocalStorage.getInstance();
    final response = await dio.get(
      SlugUrl.profile,
      options: Options(
        headers: {
          'Authorization': storage.getToken(),
        },
      ),
    );

    if (response.statusCode == 200) {
      return UserProfileResponse.fromJson(response.data as Map<String, dynamic>);
    }
    throw Exception('Failed to LogIn');
  }


  //////User Vehicles
  static Future<VehicleResponse> getUserVehicles(String? token,String vehicleType) async {
    debugPrint(token);
    // Prepare headers
    final dio = ApiClient().dio;

      final response = await dio.get(
        SlugUrl.getVehicles.replaceAll("{vehicleType}", vehicleType),
        options: Options(
          headers: {
            'Authorization': token,
          },
        ),
      );
      if (response.statusCode == 200) {
          return VehicleResponse.fromJson(
              (response.data) as Map<String, dynamic>);
        // Handle response if needed
      }
        throw Exception('Failed to Fetch Vehicles');

  }

  //////User Services
  static Future<PlanResponse> getUserServices(String? token,String vehicleType,String vehicleSize,int addressId) async {
    debugPrint(token);
    // Prepare headers
    Map<String, String> headers = {
      'Authorization': '$token', // Adding Authorization Token
    };
    final dio = ApiClient().dio;

    final response = await dio.get(
      '${SlugUrl.getServices.replaceAll("{vehicleType}", vehicleType).replaceAll("{addressId}", '$addressId')}?vehicleSize=$vehicleSize',
      options: Options(
        headers: headers
      )
    );

    if (response.statusCode == 200) {
      return PlanResponse.fromJson(
          (response.data) as Map<String, dynamic>);
      // Handle response if needed
    }
    throw Exception('Failed to Fetch Vehicles');

  }

  ////Get Address
  static Future<AddressResponse> getUserAddresses() async {
    var storage = await LocalStorage.getInstance();
    // Prepare headers
    Map<String, String> headers = {
      'Authorization': '${storage.getToken()}', // Adding Authorization Token
    };
    final dio = ApiClient().dio;
    final response = await dio.get(
      SlugUrl.getAddresses,
      options: Options(
        headers: headers
      )
    );
    if (response.statusCode == 200) {
      return AddressResponse.fromJson(
          (response.data) as Map<String, dynamic>);
      // Handle response if needed
    }
    throw Exception('Failed to Fetch Vehicles');

  }

  ////Get Brands
  static Future<BrandResponse> getBrands(String? token,bool isCar) async {
    // Prepare headers
    Map<String, String> headers = {
      'Authorization': '$token', // Adding Authorization Token
    };
    final dio = ApiClient().dio;
    final response = await dio.get(
      '${SlugUrl.getBrands}?isCar=$isCar',
      options: Options(
        headers: headers
      )
    );
    if (response.statusCode == 200) {
      return BrandResponse.fromJson(
          (response.data) as Map<String, dynamic>);
      // Handle response if needed
    }
    throw Exception('Failed to Fetch Vehicles');

  }

  ///Get Models
  static Future<VehicleModelResponse> getModels(String? token,int brandId,String vehicleType) async {
    debugPrint(token);
    // Prepare headers
    Map<String, String> headers = {
      'Authorization': '$token', // Adding Authorization Token
    };
    final dio = ApiClient().dio;

    final response = await dio.get(
      '${SlugUrl.getModels.replaceAll("{brandId}", '$brandId')}?vehicleType=$vehicleType',
      options: Options(
        headers: headers
      )
    );

    if (response.statusCode == 200) {
      return VehicleModelResponse.fromJson(
          (response.data) as Map<String, dynamic>);
      // Handle response if needed
    }
    throw Exception('Failed to Fetch Vehicles');

  }

  ///Get Colors
  static Future<VehicleColorResponse> getColors(String? token,int modelId) async {
    debugPrint(token);
    // Prepare headers
    Map<String, String> headers = {
      'Authorization': '$token', // Adding Authorization Token
    };
    final dio = ApiClient().dio;

    final response = await dio.get(
      SlugUrl.getColors.replaceAll("{modelId}", '$modelId'),
      options: Options(
        headers: headers
      ),
    );

    if (response.statusCode == 200) {
      return VehicleColorResponse.fromJson(
          (response.data) as Map<String, dynamic>);
      // Handle response if needed
    }
    throw Exception('Failed to Fetch Vehicles');

  }

  ///Search Address
  static Future<SearchAddressResponse> searchAddress(String? token,String q) async {
    debugPrint(token);
    Map<String, String> headers = {
      'Authorization': '$token', // Adding Authorization Token
    };
    final dio = ApiClient().dio;
    final response = await dio.get(
      '${SlugUrl.searchAddress}?q=$q',
      options: Options(
        headers: headers
      ),
    );


    if (response.statusCode == 200) {
      return SearchAddressResponse.fromJson(
          (response.data) as Map<String, dynamic>);
      // Handle response if needed
    }
    throw Exception('Failed to Fetch Vehicles');

  }
  // Add Vehicle
  static Future<VehicleResponse> addVehicle(
      Vehicle vehicle) async {
    var storage = await LocalStorage.getInstance();
    final dio = ApiClient().dio;

    final response = await dio.post(SlugUrl.addVehicle,
        options: Options(
          headers: {'Authorization': {storage.getToken()}}
        ),

        data: jsonEncode(vehicle.toJson()));


    if (response.statusCode == 200) {
      return VehicleResponse.fromJson(
          (response.data) as Map<String, dynamic>);
    }
    throw Exception('Failed to LogIn');
  }

  // Add Vehicle and address
  static Future<AddVehicleAndAddressResponse> addVehicleAndAddress(
      VehicleAndAddress vehicle) async {
    var storage = await LocalStorage.getInstance();
    String url = '${Constraints.baseUrl}${SlugUrl.addVehicleAndAddress}';
    final dio = ApiClient().dio;

    final response = await dio.post(SlugUrl.addVehicleAndAddress,
        options: Options(
          headers: {
            'Authorization': storage.getToken()
          }
        ),
        data: jsonEncode(vehicle.toJson()));
    if (kDebugMode) {
      print("OTPVerification : $response");
      print("statusCode: ${response.statusCode}");
      print("Url: $url");
    }

    if (response.statusCode == 200) {
      return AddVehicleAndAddressResponse.fromJson(
          (response.data) as Map<String, dynamic>);
    }
    throw Exception('Failed to LogIn');
  }

  // Add Vehicle and address
  static Future<SubscriptionResponse> subscribe(
      Subscription subscription) async {
    var storage = await LocalStorage.getInstance();
    String url = '${Constraints.baseUrl}${SlugUrl.subscribe}';
    final dio = ApiClient().dio;

    final response = await dio.post(SlugUrl.subscribe,

        options: Options(
          headers: {
            'Authorization': storage.getToken()
          }
        ),
        data: jsonEncode(subscription.toJson()));
    if (kDebugMode) {
      print("OTPVerification : $response");
      print("statusCode: ${response.statusCode}");
      print("Url: $url");
    }

    if (response.statusCode == 200) {
      return SubscriptionResponse.fromJson(
          (response.data) as Map<String, dynamic>);
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
      'Authorization': '${storage.getToken()}', // Adding Authorization Token
    };
    final dio = ApiClient().dio;

    final response = await dio.get(
      SlugUrl.subscriptionWithVehicle,
      options: Options(
        headers: headers
      )
    );

    if (kDebugMode) {
      print("auth : $response");
      print("statusCode: ${response.statusCode}");
      print("Url: $apiUrl");
    }
    if (response.statusCode == 200) {
      return SubscriptionVehicleResponse.fromJson(
          (response.data) as Map<String, dynamic>);
      // Handle response if needed
    }
    throw Exception('Failed to Fetch Vehicles');

  }
static Future<UserProfileResponse> editProfile(User user) async {
    var storage = await LocalStorage.getInstance();
    final dio = ApiClient().dio;

    final response = await dio.put(SlugUrl.updateUser,
        options: Options(
          headers: {
            'Authorization': '${storage.getToken()}'
          },
        ),

        data: jsonEncode(user.toJson()));

    if (response.statusCode == 200) {
      return UserProfileResponse.fromJson(
          (response.data) as Map<String, dynamic>);
    }
    throw Exception('Failed to edit profile.');
  }


  ///Get All Vehicles
  static Future<VehicleResponse> getAllVehicles() async {
    var storage = await LocalStorage.getInstance();
    debugPrint(storage.getToken());
    // Prepare headers
    Map<String, String> headers = {
      'Authorization': '${storage.getToken()}', // Adding Authorization Token
    };
    final dio = ApiClient().dio;

    final response = await dio.get(
      SlugUrl.getAllVehicles,
      options: Options(
        headers: headers,

      ),
    );

    if (response.statusCode == 200) {
      return VehicleResponse.fromJson(
          (response.data) as Map<String, dynamic>);
      // Handle response if needed
    }
    throw Exception('Failed to Fetch Vehicles');

  }

  ///Update Vehicle
  static Future<VehicleResponse> updateVehicle(Vehicle vehicle) async {
    var storage = await LocalStorage.getInstance();
    debugPrint(storage.getToken());
    // Prepare headers
    Map<String, String> headers = {
      'Authorization': '${storage.getToken()}', // Adding Authorization Token
    };
    final dio = ApiClient().dio;

    final response = await dio.put(
        SlugUrl.updateVehicle,
      options: Options(
        headers: headers,

      ), data: jsonEncode(vehicle.toJson())

    );

    if (response.statusCode == 200) {
      return VehicleResponse.fromJson(
          (response.data) as Map<String, dynamic>);
      // Handle response if needed
    }
    throw Exception('Failed to Fetch Vehicles');

  }


  ///Get Brand By Name
  static Future<BrandResponse> getBrandByName(String name) async {
    var storage = await LocalStorage.getInstance();
    debugPrint(storage.getToken());
    // Prepare headers
    Map<String, String> headers = {
      'Authorization': '${storage.getToken()}', // Adding Authorization Token
    };
    final dio = ApiClient().dio;

    final response = await dio.get(
      SlugUrl.getBrandByName.replaceAll("{brand}", name),
      options: Options(
        headers: headers,

      ),
    );

    if (response.statusCode == 200) {
      return BrandResponse.fromJson(
          (response.data) as Map<String, dynamic>);
      // Handle response if needed
    }
    throw Exception('Failed to Fetch Vehicles');

  }

  ///Get Model By Name
  static Future<VehicleModelResponse> getModelByName(String name) async {
    var storage = await LocalStorage.getInstance();
    debugPrint(storage.getToken());
    // Prepare headers
    Map<String, String> headers = {
      'Authorization': '${storage.getToken()}', // Adding Authorization Token
    };
    final dio = ApiClient().dio;
    final response = await dio.get(
      '${SlugUrl.getModelByName}?model=$name',
      options: Options(
        headers: headers,

      ),
    );

    if (response.statusCode == 200) {
      return VehicleModelResponse.fromJson(
          (response.data) as Map<String, dynamic>);
      // Handle response if needed
    }
    throw Exception('Failed to Fetch Vehicles');

  }

  ///Get Color By Name
  static Future<VehicleColorResponse> getColorByName(String name) async {
    var storage = await LocalStorage.getInstance();
    debugPrint(storage.getToken());
    // Prepare headers
    Map<String, String> headers = {
      'Authorization': '${storage.getToken()}', // Adding Authorization Token
    };
    final dio = ApiClient().dio;

    final response = await dio.get(
      '${SlugUrl.getColorByName}?color=$name',
      options: Options(
        headers: headers,

      ),
    );

    if (response.statusCode == 200) {
      return VehicleColorResponse.fromJson(
          (response.data) as Map<String, dynamic>);
      // Handle response if needed
    }
    throw Exception('Failed to Fetch Vehicles');

  }

  static Future<AddressResponse> getUserAddressesByVehicleId(String vehicleId) async {
    var storage = await LocalStorage.getInstance();
    // Prepare headers
    Map<String, String> headers = {
      'Authorization': '${storage.getToken()}', // Adding Authorization Token
    };
    final dio = ApiClient().dio;

    final response = await dio.get(
      SlugUrl.getAddressesByVehicleId.replaceAll("{VehicleId}", vehicleId),
      options: Options(
        headers: headers,

      ),
    );
    if (response.statusCode == 200) {
      return AddressResponse.fromJson(
          (response.data) as Map<String, dynamic>);
      // Handle response if needed
    }
    throw Exception('Failed to Fetch Vehicles');
  }

  static Future<AddressResponse> addUserAddress(Address add) async {

    var storage = await LocalStorage.getInstance();
    final dio = ApiClient().dio;

    final response = await dio.post(SlugUrl.addAddress,

        options: Options(
          headers: {
            'Authorization': '${storage.getToken()}'
          },
        ),
        data: jsonEncode(add.toJson()));

    if (response.statusCode == 200) {
      return AddressResponse.fromJson(
          (response.data) as Map<String, dynamic>);
    }
    throw Exception('Failed to edit profile.');

  }

  static Future<AddressResponse> updateUserAddress(Address add) async {

    var storage = await LocalStorage.getInstance();
    final dio = ApiClient().dio;

    final response = await dio.put(SlugUrl.updateAddress,

        options: Options(
          headers: {
            'Authorization': '${storage.getToken()}'
          },
        ),
        data: jsonEncode(add.toJson()));

    if (response.statusCode == 200) {
      return AddressResponse.fromJson(
          (response.data) as Map<String, dynamic>);
    }
    throw Exception('Failed to edit profile.');

  }

  ///Transactions
  static Future<TransactionsResponse> getTransactions() async {
    var storage = await LocalStorage.getInstance();
    debugPrint(storage.getToken());
    // Prepare headers
    Map<String, String> headers = {
      'Authorization': '${storage.getToken()}', // Adding Authorization Token
    };
    final dio = ApiClient().dio;

    final response = await dio.get(
      SlugUrl.getTransactions,
      options: Options(
        headers: headers,

      )
    );

    // if (kDebugMode) {
    //   print("auth : ${response}");
    //   print("statusCode: ${response.statusCode}");
    //   print("Url: $apiUrl");
    // }
    if (response.statusCode == 200) {
      return TransactionsResponse.fromJson(
          (response.data) as Map<String, dynamic>);
      // Handle response if needed
    }
    throw Exception('Failed to Fetch Vehicles');

  }


  static Future<SubscriptionResponse> checkFirstOrExpireSubscription(String addressId,String vehicleId) async {
    var storage = await LocalStorage.getInstance();
    // Prepare headers
    Map<String, String> headers = {
      'Authorization': '${storage.getToken()}', // Adding Authorization Token
    };
    final dio = ApiClient().dio;

    final response = await dio.get(
      SlugUrl.checkFirstOrExpireSubscription.replaceAll("{addressId}", addressId).replaceAll("{vehicleId}", vehicleId),
      options: Options(
        headers: headers,

      )
    );

    if (response.statusCode == 200) {
      return SubscriptionResponse.fromJson(
          (response.data) as Map<String, dynamic>);
      // Handle response if needed
    }
    throw Exception('Failed to Fetch Vehicles');
  }


  static Future<RazorpayResponse> createRazorpayOrder(Map<String,dynamic> data) async {

    var storage = await LocalStorage.getInstance();
    final dio = ApiClient().dio;
    final response = await dio.post(SlugUrl.createRazorpayOrder,
        options: Options(
          headers: {
            'Authorization': '${storage.getToken()}'
          },
        ),

        data: jsonEncode(data));
    if (response.statusCode == 200) {
      return RazorpayResponse.fromJson(
          jsonDecode(response.data) as Map<String, dynamic>);
    }
    throw Exception('Failed to edit profile.');

  }

  static Future<Response> verifyPayment(Map<String, dynamic> data) async {
    var storage = await LocalStorage.getInstance();
    final dio = ApiClient().dio;

    final response = await dio.post(SlugUrl.verifyRazorpayOrder,
        options: Options(
          headers: {
            'Authorization': '${storage.getToken()}'
          },
        ),

        data: jsonEncode(data));

    if (response.statusCode == 200) {
      return Response.fromJson(
          (response.data) as Map<String, dynamic>);
    }
    throw Exception('Failed to edit profile.');
  }

  static Future<ReferralCodeResponse> getReferralLink() async {
    var storage = await LocalStorage.getInstance();
    final String apiUrl ='${Constraints.baseUrl}${SlugUrl.getReferral}';
    // Prepare headers

    Map<String, String> headers = {
      'Authorization': '${storage.getToken()}', // Adding Authorization Token
    };
    final dio = ApiClient().dio;
    final response = await dio.get(
      SlugUrl.getReferral,
      options: Options(headers: headers),
    );

    if (kDebugMode) {
      print("auth : $response");
      print("statusCode: ${response.statusCode}");
      print("Url: $apiUrl");
    }
    if (response.statusCode == 200) {
      return ReferralCodeResponse.fromJson(
          (response.data) as Map<String, dynamic>);
      // Handle response if needed
    }
    throw Exception('Failed to Fetch Vehicles');

  }

  static Future<Response> deleteVehicle(String? id) async {
    var storage = await LocalStorage.getInstance();
    final String apiUrl ='${Constraints.baseUrl}${SlugUrl.deleteVehicle.replaceAll("{id}", id!)}';
    // Prepare headers
    Map<String, String> headers = {
      'Authorization': '${storage.getToken()}', // Adding Authorization Token
    };
    final dio = ApiClient().dio;

    final response = await dio.delete(
      SlugUrl.deleteVehicle.replaceAll("{id}", id),
      options: Options(
        headers: headers
      ),
    );

    if (kDebugMode) {
      print("auth : $response");
      print("statusCode: ${response.statusCode}");
      print("Url: $apiUrl");
    }
    if (response.statusCode == 200) {
      return Response.fromJson(
          (response.data) as Map<String, dynamic>);
      // Handle response if needed
    }
    throw Exception('Failed to Fetch Vehicles');

  }


  static Future<UserProfileResponse> checkReferralCode(String referralCode) async {
    var storage = await LocalStorage.getInstance();
    final String apiUrl ='${Constraints.baseUrl}${SlugUrl.checkReferral.replaceAll('{referralCode}', referralCode)}';
    // Prepare headers
    Map<String, String> headers = {
      'Authorization': '${storage.getToken()}', // Adding Authorization Token
    };
    final dio = ApiClient().dio;

    final response = await dio.get(
      SlugUrl.checkReferral.replaceAll('{referralCode}', referralCode),
      options: Options(
        headers: headers
      ),
    );

    if (kDebugMode) {
      print("auth : $response");
      print("statusCode: ${response.statusCode}");
      print("Url: $apiUrl");
    }
    if (response.statusCode == 200) {
      return UserProfileResponse.fromJson(
          (response.data) as Map<String, dynamic>);
      // Handle response if needed
    }
    throw Exception('Failed to Fetch Vehicles');

  }

  static Future<UserProfileResponse> refreshToken() async{
    String url = '${Constraints.baseUrl}${SlugUrl.authRefresh}';
    var storage = await LocalStorage.getInstance();
    User data  = User(phone: storage.getPhone()!,token: storage.getToken(),id: storage.getUserId());
    final dio = ApiClient().dio;
    final response = await dio.post(SlugUrl.authRefresh,
        data: jsonEncode(data));

    if (kDebugMode) {
      print("Add Address : $response");
      print("statusCode: ${response.statusCode}");
      print("Url: $url");
    }
    if (response.statusCode == 200) {
      return UserProfileResponse.fromJson(
          response.data as Map<String, dynamic>);
    }
    throw Exception('Failed to edit profile.');
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
