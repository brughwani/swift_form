import 'dart:io';
class Config {
  final String apiUrl;
  final bool isDebug;

  Config({required this.apiUrl, required this.isDebug});

  static const  bool _configIsProd = bool.fromEnvironment('dart.vm.product');
  static String prodEndpoint  = 'https://api.swiftform.in';
  static String devEndpoint  = Platform.isAndroid ? 'http://10.0.2.2:3000' : 'http://127.0.0.1:3000';

  static String get getBaseUrl {
    return _configIsProd ? prodEndpoint : devEndpoint;
  }
}