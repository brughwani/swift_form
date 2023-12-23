import 'config.dart';

// config_prod.dart
class DevConfig extends Config {
  DevConfig() : super(apiUrl: 'http://127.0.0.1:3000', isDebug: true);
}
