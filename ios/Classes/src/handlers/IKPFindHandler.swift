import Flutter
import CloudKit


public class IKPFindHandler : IKPHandler {
    
    func findRecords(callback: @escaping FlutterResult) {
        guard let database = kit.database else {
            callback(IKPUtils.errorResponse(code: 200, msg:"Cannot create a database for the provided scope"))
            return
        }
        
        guard let recordType = params[IKPConstants.recordType] as? String, !recordType.isEmpty else {
            callback(IKPUtils.errorResponse(code: 201, msg: "Couldn't parse the required parameter 'recordType'"))
            return
        }
        
        //创建操作（支持游标）
        let operation: CKQueryOperation
        if let cursor = IKPUtils.parseCursor(cursorData: params[IKPConstants.cursor] as? String) {
            operation = CKQueryOperation(cursor: cursor)
        } else {
            let predicate = IKPUtils.createPredicate(from: params[IKPConstants.filters] as? [[String: Any]] ?? [])
            let query = CKQuery(recordType: recordType, predicate: predicate)
            
            // 添加排序
            if let sortFields = params[IKPConstants.sortFields] as? [[String: Any]] {
                query.sortDescriptors = IKPUtils.createSortDescriptors(from: sortFields)
            }
            operation = CKQueryOperation(query: query)
        }
        
        // 返回的字段
        if let fields = params[IKPConstants.fields] as? [String] {
            operation.desiredKeys = fields;
        }
        
        // 设置分页大小
        let limit = params[IKPConstants.limit] as? Int ?? 20
        operation.resultsLimit = limit
        
        // 收集结果和错误
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
