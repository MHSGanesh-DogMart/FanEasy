/// ─────────────────────────────────────────────────────────
///  Api — Environment-aware base URL configuration
/// ─────────────────────────────────────────────────────────
class Api {
  Api._();

  // ── REST ──
  static String baseUrl = devUrl;
  static String devUrl = 'http://65.0.23.129:3000';
  static String prodUrl = 'http://65.0.23.129:3000';

  // ── Socket.IO ──
  static String socketUrl = socketDevUrl;
  static String socketDevUrl = 'http://65.0.23.129:3000';
  static String socketProdUrl = 'http://65.0.23.129:3000';

  // ── Google Maps ──
  // static const String googleMapsApiKey =
  //     'AIzaSyCsgUozRj3yuRs5kCX1-M77AoTFsbumHbA';
}

enum Environment { dev, prod }

void setEnvironment({required Environment env}) {
  switch (env) {
    case Environment.dev:
      Api.baseUrl = Api.devUrl;
      Api.socketUrl = Api.socketDevUrl;
      break;
    case Environment.prod:
      Api.baseUrl = Api.prodUrl;
      Api.socketUrl = Api.socketProdUrl;
      break;
  }
}
