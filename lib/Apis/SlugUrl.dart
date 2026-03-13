class SlugUrl {
  static String sendOtp = "user/sendOtp";
  static String login = "user/login";
  static String profile = "user/profile";
  static String getVehicles = "vehicle/{vehicleType}/get";
  static String getServices = "service/{vehicleType}/get";
  static String getAddresses = "address/get";
  static String getBrands = "master/brands/get";
  static String getModels = "master/models/{brandId}/get";
  static String getColors= "master/colors/{modelId}/get";
  static String searchAddress= "master/address";
  static String addVehicle= "vehicle/add";
  static String addVehicleAndAddress= "vehicle/address/add";
  static String subscribe= "subscription/add";

}
