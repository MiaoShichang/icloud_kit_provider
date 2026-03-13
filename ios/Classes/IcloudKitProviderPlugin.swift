import Flutter
import UIKit

public class IcloudKitProviderPlugin: NSObject, FlutterPlugin {
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "icloud_kit_provider", binaryMessenger: registrar.messenger())
        let instance = IcloudKitProviderPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "handler":
            if let params = call.arguments as? [String:Any] {
                IKPCaller.handle(params:params, callback:  result);
            }else {
                result(IKPUtils.errorResponse(code: 10000, msg: "params is nil"))
            }
        default:
            result(IKPUtils.errorResponse(code: 10001, msg: "method[\(call.method)] not implemented"))
        }
    }
}
