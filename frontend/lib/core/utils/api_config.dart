import 'dart:io';

class ApiConfig {
  static String get baseUrl {
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:8080'; // Android emulator
    } else if (Platform.isIOS) {
      return 'http://127.0.0.1:8080'; // iOS simulator
    } else {
      return 'http://192.168.1.5:8080'; // physical device
    }
  }
}