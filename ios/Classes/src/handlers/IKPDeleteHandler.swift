import Flutter
import CloudKit

public class IKPDeleteHandler : IKPHandler {
    
    func deleteRecord(callback: @escaping FlutterResult) -> Void {
        guard let database = kit.database else {
            callback(IKPUtils.errorResponse(code: 200, msg:"Cannot create a database for the provided scope"))
            return
        }
        
        let recordId: CKRecord.ID;
        let recordName: String
        if let rName = params[IKPConstants.recordName] as? String {
            recordId = CKRecord.ID(recordName: rName)
            recordName = rName
        } else {
            callback(IKPUtils.errorResponse(code: 201, msg:"Cannot parse record id"));
            return
        }
        
        database.delete(withRecordID: recordId) { (rId, error) in
            if (error != nil) {
                callback(IKPUtils.errorResponse(code: 202, msg: error!.localizedDescription));
                return
            }
            if (rId == nil) {
                callback(IKPUtils.errorResponse(code: 203, msg: "Record was not found",data: recordName));
            } else {
                callback(IKPUtils.successResponse(data: rId!.recordName));
            }
        }
    }
}
