
import 'dart:async';

import 'package:flutter/services.dart';

class Plugin001 {
  static const MethodChannel _channel = MethodChannel('plugin_001');

  static Future<String?> get platformVersion async {
    // Method channel에 등록되어 있는 getPlatformVersion 이라는 메소드를 call 해서 platform version을 받아온다.
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
