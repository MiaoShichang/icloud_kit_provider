import Flutter
import CloudKit

public class IKPAccountHandler : IKPHandler {
    
    func getAccountStatus(callback: @escaping FlutterResult){
        if let container = kit.container {
            container.accountStatus { (accountStatus: CKAccountStatus, error: Error?) in
                if (error != nil) {
                    callback(IKPUtils.errorResponse(code: 100, msg: error!.localizedDescription))
                }else{
                    callback(IKPUtils.successResponse(data: accountStatus.rawValue));
                }
            }
        }else{
            callback(IKPUtils.errorResponse(code: 101, msg: "init container failed"))
        }
    }
    
}
