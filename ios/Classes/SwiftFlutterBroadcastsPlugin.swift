import Flutter
import UIKit

public class SwiftFlutterBroadcastsPlugin: NSObject, FlutterPlugin {
  private var channel: FlutterMethodChannel?
  // receiverId -> array of observer tokens
  private var observers: [Int: [NSObjectProtocol]] = [:]

  public static func register(with registrar: FlutterPluginRegistrar) {
    let instance = SwiftFlutterBroadcastsPlugin()
    instance.channel = FlutterMethodChannel(name: "de.kevlatus.flutter_broadcasts", binaryMessenger: registrar.messenger())
    registrar.addMethodCallDelegate(instance, channel: instance.channel!)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "startReceiver":
      startReceiver(call, result: result)
    case "stopReceiver":
      stopReceiver(call, result: result)
    case "sendBroadcast":
      sendBroadcast(call, result: result)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func startReceiver(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard let args = call.arguments as? [String: Any], let id = args["id"] as? Int, let names = args["names"] as? [String] else {
      result("invalid arguments")
      return
    }
    if observers[id] != nil {
      // Already started, just succeed
      result(nil)
      return
    }
    var created: [NSObjectProtocol] = []
    let center = NotificationCenter.default
    for name in names {
      let token = center.addObserver(forName: Notification.Name(name), object: nil, queue: OperationQueue.main) { [weak self] notification in
        guard let self = self else { return }
        var data: [String: Any]? = nil
        if let userInfo = notification.userInfo {
          data = self.normalize(userInfo)
        }
        let payload: [String: Any?] = [
          "receiverId": id,
          "name": notification.name.rawValue,
          "data": data
        ]
        self.channel?.invokeMethod("receiveBroadcast", arguments: payload)
      }
      created.append(token)
    }
    observers[id] = created
    result(nil)
  }

  private func stopReceiver(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard let args = call.arguments as? [String: Any], let id = args["id"] as? Int else {
      result("invalid arguments")
      return
    }
    if let tokens = observers[id] {
      let center = NotificationCenter.default
      tokens.forEach { center.removeObserver($0) }
      observers.removeValue(forKey: id)
    }
    result(nil)
  }

  private func sendBroadcast(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard let args = call.arguments as? [String: Any], let name = args["name"] as? String else {
      result("invalid arguments")
      return
    }
    let rawData = args["data"] as? [String: Any]
    NotificationCenter.default.post(name: Notification.Name(name), object: nil, userInfo: rawData)
    result(nil)
  }

  private func normalize(_ dict: [AnyHashable: Any]) -> [String: Any] {
    var out: [String: Any] = [:]
    for (k, v) in dict {
      let key = String(describing: k)
      out[key] = normalizeValue(v)
    }
    return out
  }

  private func normalizeValue(_ value: Any) -> Any {
    switch value {
    case is NSNull, is String, is Int, is Int32, is Int64, is UInt, is UInt32, is UInt64, is Double, is Float, is Bool, is [UInt8]:
      return value
    case let d as Data:
      return [UInt8](d)
    case let arr as [Any]:
      return arr.map { normalizeValue($0) }
    case let dict as [AnyHashable: Any]:
      return normalize(dict)
    default:
      return String(describing: value)
    }
  }

  deinit {
    let center = NotificationCenter.default
    observers.values.flatMap { $0 }.forEach { center.removeObserver($0) }
    observers.removeAll()
  }
}
