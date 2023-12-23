import 'config.dart';

// config_prod.dart
class ProdConfig extends Config {
  ProdConfig() : super(apiUrl: 'api.swiftform.in', isDebug: false);
}
