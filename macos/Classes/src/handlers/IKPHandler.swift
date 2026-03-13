import Flutter
import CloudKit

public class IKPHandler {
    public var kit:(container:CKContainer?, database:CKDatabase?) = (nil, nil)
    public var params:[String:Any] = [:]
    
    public init(data:[String:Any]){
        initCloudKit(params: data)
        if let p = data[IKPConstants.params] as? [String:Any]{
            params = p
        }
    }
    
    func initCloudKit(params:[String:Any]){
        if let containerId = params[IKPConstants.containerID] as? String, !containerId.isEmpty {
            kit.container = CKContainer(identifier: containerId)
        } else {
            kit.container =  CKContainer.default()
        }
        
        if let scope = params[IKPConstants.scope] as? String {
            if scope == IKPConstants.scopePrivateValue {
                kit.database = kit.container!.privateCloudDatabase;
            }else if scope == IKPConstants.scopePublicValue {
                kit.database = kit.container!.publicCloudDatabase;
            }else if scope==IKPConstants.scopeSharedValue {
                kit.database = kit.container!.sharedCloudDatabase;
            }
        }
    }
    
    
}
