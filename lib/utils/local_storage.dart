import 'package:shared_preferences/shared_preferences.dart';


class LocalStorage{

  static late SharedPreferences _preferences;

  static Future<LocalStorage> getInstance() async {
    _preferences = await SharedPreferences.getInstance();
    return LocalStorage();
  }

  static Future<void> setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
  }

  static Future<void> setStatus(String status) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('status', status);
  }

  static Future<void> setReferralCode(String referralCode) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('referralCode', referralCode);
  }

  String?  getStatus() {
    // final prefs = await SharedPreferences.getInstance();
    return _preferences.getString('status');
  }

  String? getToken() {
    // final prefs = await SharedPreferences.getInstance();
    return _preferences.getString('token');
  }

  static Future<void> setFirstName(String firstName) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('firstName', firstName);
  }
  static Future<void> setUserId( int  id)async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('customerId', id);

  }

  int ? getUserId(){
    return _preferences.getInt('customerId');

  }

  static String? getFirstName() {
    // final prefs = await SharedPreferences.getInstance();
    return _preferences.getString('firstName');
  }

  static Future<void> setLastName(String lastName) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('lastName', lastName);
  }

  static Future<void> setDefaultAddress(int addressId)async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('defaultAddress', addressId);
  }
  getDefaultAddress(){
    // final prefs = await SharedPreferences.getInstance();
    return _preferences.getInt('defaultAddress');
  }


  String? getLastName() {
    // final prefs = await SharedPreferences.getInstance();

    return _preferences.getString('lastName');
  }

  static Future<void> setPhone(String phone) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('phone', phone);
  }

  String? getPhone() {
    // final prefs = await SharedPreferences.getInstance();
    return _preferences.getString('phone');
  }
  Future<void> clearSharedPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    print("All shared preferences cleared.");
  }

}
