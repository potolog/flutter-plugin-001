
import 'dart:async';

import 'package:flutter/services.dart';

class Plugin001 {
  static const MethodChannel _channel = MethodChannel('plugin_001');

  // Platform 버전 확인
  static Future<String?> get platformVersion async {
    // Method channel에 등록되어 있는 getPlatformVersion 이라는 메소드를 call 해서 platform version을 받아온다.
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  // BMCLAB 버전 확인
  static Future<String?> get bmclabVersion async {
    // Method channel에 등록되어 있는 getBmclabVersion 이라는 메소드를 call 해서 platform version을 받아온다.
    final String? version = await _channel.invokeMethod('getBmclabVersion');
    return version;
  }

  // 상태 확인
  static Future<String?> get status async {
    // Method channel에 등록되어 있는 getBmclabVersion 이라는 메소드를 call 해서 platform version을 받아온다.
    final String? status = await _channel.invokeMethod('getStatus');
    return status;
  }

  // Start
  static Future<int> start() async {
    int status = await _channel.invokeMethod('start');
    return status;

    Completer completer = Completer<int>();
    _channel.invokeMethod('start').then((value) {
      completer.complete(value);
    }).catchError((error) {
      String message = 'Unknown error';
      if (error.details != null) {
        message = error.details;
      }
      completer.completeError(message);
    });
    return completer.future as Future<int>;
  }

  // Stop
  static Future<int> stop([String? taskId]) async {
    int status = await _channel.invokeMethod('stop', taskId);
    return status;
  }

}
