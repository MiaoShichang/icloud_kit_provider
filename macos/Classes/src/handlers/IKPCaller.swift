import Flutter

public class IKPCaller {
    
    static func handle(params:[String:Any], callback: @escaping FlutterResult) {
        guard let method = params[IKPConstants.method] as? String, !method.isEmpty else{
            return callback(IKPUtils.errorResponse(code: 300, msg: "method is nil"))
        }
        
        switch method {
        case IKPConstants.getAccountStatus:
            IKPAccountHandler(data: params).getAccountStatus(callback:callback);
        case IKPConstants.saveRecord:
            IKPSaveHandler(data: params).saveRecord(callback: callback);
        case IKPConstants.getRecord:
            IKPGetHandler(data: params).getRecord(callback: callback);
        case IKPConstants.getRecords:
            IKPGetHandler(data: params).getRecords(callback: callback);
        case IKPConstants.deleteRecord:
            IKPDeleteHandler(data: params).deleteRecord(callback: callback);
        case IKPConstants.findRecords:
            IKPFindHandler(data: params).findRecords(callback:callback);
        case IKPConstants.test:
            callback(IKPUtils.successResponse(data: params));
        default:
            callback(IKPUtils.errorResponse(code: 301, msg: "method do not find"))
        }
    }
}
