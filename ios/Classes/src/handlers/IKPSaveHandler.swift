import Flutter
import CloudKit

public class IKPSaveHandler  : IKPHandler {
    
    func saveRecord(callback: @escaping FlutterResult) -> Void {
        guard let database = kit.database else {
            callback(IKPUtils.errorResponse(code: 200, msg:"Cannot create a database for the provided scope"));
            return
        }
        
        guard let recordType = params[IKPConstants.recordType] as? String, !recordType.isEmpty else {
            callback(IKPUtils.errorResponse(code: 201, msg: "Couldn't parse the required parameter 'recordType'"))
            return
        }
        
        guard let recordValues = params[IKPConstants.recordValue] as? [String:Any], !recordValues.isEmpty else{
            callback(IKPUtils.errorResponse(code: 202, msg: "Couldn't parse the required parameter 'recordValue'"));
            return
        }
        
        let recordId: CKRecord.ID;
        if let recordName = params[IKPConstants.recordName] as? String {
            recordId = CKRecord.ID(recordName: recordName)
        } else {
            recordId = CKRecord.ID();
        }

        // 尝试获取现有记录
        database.fetch(withRecordID: recordId) { record, error in
            var  r : CKRecord
            if record == nil {
                r = CKRecord(recordType: recordType, recordID: recordId);
                r.setValuesForKeys(recordValues);
            }else{
                record!.setValuesForKeys(recordValues);
                r = record!
            }
            database.save(r) { (record, error) in
                if (error != nil) {
                    callback(IKPUtils.errorResponse(code: 203, msg:  error!.localizedDescription));
                    return
                }
                if (record == nil) {
                    callback(IKPUtils.errorResponse(code:204, msg: "Got nil while saving the record"));
                    return
                }
                callback(IKPUtils.successResponse(data: IKPUtils.record2Dict(record: record!)));
            }
        }
    }
}
