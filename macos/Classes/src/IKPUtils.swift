
import CloudKit

public class IKPUtils {

    static func successResponse(data:Any?) -> Any{
        return ["code":0,"msg":"success","data":data]
    }
    
    static func errorResponse(code:Int,msg:String,data:Any? = nil) -> Any{
        return ["code":code,"msg":msg,"data":data]
    }
    
    static  func convertCkRecordType(value: __CKRecordObjCValue) -> Any? {
        if let str = value as? NSString {
            return str as String;
        } else if let num = value as? NSNumber {
            return num;
        } else if let data = value as? NSData {
            return data.base64EncodedString();
        } else if let date = value as? NSDate {
            return date.timeIntervalSince1970;
        } else if let reference = value as? CKRecord.Reference {
            return reference.recordID.recordName;
        } else if let asset = value as? CKAsset {
            return asset.fileURL?.absoluteString;
        } else  {
            // not supported
            return nil;
        }
    }
    
    static func record2Dict(record: CKRecord) -> [String: Any?] {
        var dict: [String: Any?] = [
            IKPConstants.recordName:record.recordID.recordName,
            IKPConstants.recordType: record.recordType
        ];
        
        var recordValue: [String: Any?] = [:];
        for key in record.allKeys() {
            if let value = record[key] {
                recordValue[key] = convertCkRecordType(value: value);
            }
        }
        dict[IKPConstants.recordValue] = recordValue;
        return dict;
    }
    
    
    static func parseCursor(cursorData:String?) ->CKQueryOperation.Cursor?{
        if cursorData == nil {
            return nil
        }
        
        let cursorDataObj = Data(base64Encoded: cursorData!)
        if cursorDataObj == nil {
            return nil
        }
        
        let cursor = try? NSKeyedUnarchiver.unarchivedObject(ofClass: CKQueryOperation.Cursor.self, from: cursorDataObj!)
        return cursor;
    }
    
    static func wrapCursor(cursor: CKQueryOperation.Cursor?) ->String?{
        if let cursor = cursor {
            if let cursorData = try? NSKeyedArchiver.archivedData(withRootObject: cursor, requiringSecureCoding: true) {
                let cursorResult = cursorData.base64EncodedString();
                return cursorResult;
            }
        }
        return nil
    }
    
    static func createPredicate(from filters: [[String: Any]]) -> NSPredicate {
        if filters.isEmpty {
            return NSPredicate(value: true)
        }
        
        var subpredicates: [NSPredicate] = []
        for filter in filters {
            guard let fieldName = filter["field"] as? String,
                  let operatorString = filter["operator"] as? String,
                  let value = filter["value"] else {
                continue
            }
            
            let predicate: NSPredicate?
            
            switch operatorString {
            case "equals":
                predicate = NSPredicate(format: "%K == %@", fieldName, value as! CVarArg)
            case "notEquals":
                predicate = NSPredicate(format: "%K != %@", fieldName, value as! CVarArg)
            case "lessThan":
                predicate = NSPredicate(format: "%K < %@", fieldName, value as! CVarArg)
            case "lessThanOrEquals":
                predicate = NSPredicate(format: "%K <= %@", fieldName, value as! CVarArg)
            case "greaterThan":
                predicate = NSPredicate(format: "%K > %@", fieldName, value as! CVarArg)
            case "greaterThanOrEquals":
                predicate = NSPredicate(format: "%K >= %@", fieldName, value as! CVarArg)
            case "contains":
                predicate = NSPredicate(format: "%K CONTAINS %@", fieldName, value as! CVarArg)
            case "beginsWith":
                predicate = NSPredicate(format: "%K BEGINSWITH %@", fieldName, value as! CVarArg)
            case "endsWith":
                predicate = NSPredicate(format: "%K ENDSWITH %@", fieldName, value as! CVarArg)
            case "inList":
                predicate = NSPredicate(format: "%K IN %@", fieldName, value as! [CVarArg])
            default:
                predicate = nil
            }
            
            if let predicate = predicate {
                subpredicates.append(predicate)
            }
        }
        
        return NSCompoundPredicate(andPredicateWithSubpredicates: subpredicates)
    }
    
    static func createSortDescriptors(from descriptors: [[String: Any]]) -> [NSSortDescriptor] {
        return descriptors.compactMap { descriptor in
            guard let fieldName = descriptor["field"] as? String,
                  let direction = descriptor["direction"] as? String else {
                return nil
            }
            
            return NSSortDescriptor(
                key: fieldName,
                ascending: direction == "asc"
            )
        }
    }
    
    
}
