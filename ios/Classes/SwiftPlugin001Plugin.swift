import Flutter
import UIKit

public class SwiftPlugin001Plugin: NSObject, FlutterPlugin {
  // register 메소드가 내부적으로 호출되며 해당 plugin class를 flutter와 연결한다.
  public static func register(with registrar: FlutterPluginRegistrar) {
    // 메소드 채널 생성
    let channel = FlutterMethodChannel(name: "plugin_001", binaryMessenger: registrar.messenger())
    let instance = SwiftPlugin001Plugin()
    // 메소드 채널에서 call 되어 오는 메시지를 받기 위해 현재 plugin을 등록한다.
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.messenger {
      case "getPlatformVersion":
        // 원래는 call.method 에서 getPlatformVersion이 오면 result로 systemVersion을 넘겨줘야하는데
        // 생성되는 예제에서는 handle 메소드가 불리면 바로 넘겨주고 있다.
        result("iOS " + UIDevice.current.systemVersion)
      case "bmclab":
        result("iOS : bmclab")
      default:
        result(FlutterMethodNotImplemented)
    }
  }
}
