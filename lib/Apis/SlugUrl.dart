class SlugUrl {
  static String sendOtp = "user/sendOtp";
  static String login = "user/login";
  static String profile = "user/profile";
  static String getVehicles = "vehicle/{vehicleType}/get";
  static String getServices = "service/{vehicleType}/{addressId}/get";
  static String getAddresses = "address/get";
  static String getAddressesByVehicleId = "address/{VehicleId}/get";
  static String getBrands = "master/brands/get";
  static String getModels = "master/models/{brandId}/get";
  static String getColors= "master/colors/{modelId}/get";
  static String searchAddress= "master/address";
  static String addVehicle= "vehicle/add";
  static String addVehicleAndAddress= "vehicle/address/add";
  static String subscribe= "subscription/add";
  static String subscriptionWithVehicle= "subscription/vehicle";
  static String getTransactions= "subscription/transactions";
  static String updateUser= "user/update";
  static String getReferral= "user/referral";
  static String getAllVehicles= "vehicle/getAll";
  static String updateVehicle= "vehicle/update";
  static String deleteVehicle= "vehicle/{id}/delete";
  static String getBrandByName= "master/brand/{brand}/get";
  static String getModelByName= "master/model/get";
  static String getColorByName= "master/color/get";
  static String addAddress= "address/add";
  static String updateAddress= "address/update";
  static String createRazorpayOrder= "razorpay/create-order";
  static String verifyRazorpayOrder= "razorpay/verify-payment";
  static String checkFirstOrExpireSubscription= "subscription/{addressId}/{vehicleId}/checkActiveOrExpire";

}
