import Flutter
import CloudKit

public class IKPGetHandler : IKPHandler {
    
    func getRecord(callback: @escaping FlutterResult){
        guard let database = kit.database else {
            callback(IKPUtils.errorResponse(code: 200, msg:"Cannot create a database for the provided scope"))
            return
        }
        
        let recordId: CKRecord.ID;
        if let recordName = params[IKPConstants.recordName] as? String {
            recordId = CKRecord.ID(recordName: recordName)
        } else {
            callback(IKPUtils.errorResponse(code: 201, msg: "Cannot parse record name(id)"));
            return
        }
        
        database.fetch(withRecordID: recordId) { (record, error) in
            if (error != nil) {
                return callback(IKPUtils.errorResponse(code: 202, msg: error!.localizedDescription));
            }
            if (record == nil) {
                return callback(IKPUtils.errorResponse(code: 203, msg: "Got nil when fetching the record"));
            } else {
                let dict = IKPUtils.record2Dict(record: record!);
                return callback(dict);
            }
        }
    }
    
    
    func getRecords(callback: @escaping FlutterResult) {
        guard let database = kit.database else {
            callback(IKPUtils.errorResponse(code: 200, msg:"Cannot create a database for the provided scope"))
            return
        }
        
        guard let recordType = params[IKPConstants.recordType] as? String, !recordType.isEmpty else {
            callback(IKPUtils.errorResponse(code: 201, msg: "Couldn't parse the required parameter 'recordType'"))
            return
        }
        
        
        // 3. 构建查询
        let predicate = NSPredicate(value: true)
        let sort = NSSortDescriptor(key: "createdTimestamp", ascending: true)
        let query = CKQuery(recordType: recordType, predicate: predicate)
        query.sortDescriptors = [sort]
        
        // 4. 创建操作（支持游标）
        let operation: CKQueryOperation
        if let cursor = IKPUtils.parseCursor(cursorData: params[IKPConstants.cursor] as? String) {
            operation = CKQueryOperation(cursor: cursor)
        } else {
            operation = CKQueryOperation(query: query)
        }
        
        // 5. 设置分页大小
        let limit = params[IKPConstants.limit] as? Int ?? 20
        operation.resultsLimit = limit
        
        //
        if let fields = params[IKPConstants.fields] as? [String] {
            operation.desiredKeys = fields
        }
        
        // 6. 收集结果和错误
        var list: [CKRecord] = []
        var fetchError: Error?  // 记录第一个错误
        
        operation.recordMatchedBlock = { recordID, result in
            switch result {
            case .success(let record):
                list.append(record)
            case .failure(let error):
                if fetchError == nil {
                    fetchError = error  // 只记录第一个错误
                }
                print("Error fetching record \(recordID): \(error)")
            }
        }
        
        // 7. 查询完成回调
        operation.queryResultBlock = { operationResult in
            switch operationResult {
            case .success(let cursor):
                var data: [String: Any] = [
                    IKPConstants.list: list.map { IKPUtils.record2Dict(record: $0) },
                    IKPConstants.limit: limit
                ]
                
                if let cursor = cursor {
                    data[IKPConstants.cursor] = IKPUtils.wrapCursor(cursor: cursor)
                }
                
                callback(IKPUtils.successResponse(data: data))
                
            case .failure(let error):
                callback(IKPUtils.errorResponse(code: 203, msg: error.localizedDescription))
            }
        }
        
        // 8. 执行操作
        database.add(operation)
    }
    
}
