import 'config.dart';
import 'dart:io';
// config_prod.dart
class DevConfig extends Config {
  DevConfig() : super(
    apiUrl:Platform.isAndroid ? 'http://10.0.2.2:3000' : 'http://127.0.0.1:3000', 
    isDebug: true);
}
