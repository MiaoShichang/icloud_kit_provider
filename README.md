# icloud_kit_provider

A simple flutter plugin for interactions with Apple Cloud Kit Database API on iOS devices.

# Usage

```dart
/// create a instance of IcloudKitProvider
factory IcloudKitProvider({
   String? containerId,
   IkpDatabaseScope scope = IkpDatabaseScope.private,
});

/// create a instance 
final provider = IcloudKitProvider();

```

```dart
/// Gets the user's account status.
Future<IkpResponse> getAccountStatus();
```

```dart
/// Add or update a record.
///  recordName: The recordName of the iCloud Kit Database.
///  When recordName is empty, the saveRecord function adds new record with a unique value of recordName;
///  when recordName is not empty: 
///     if the value of recordName exists in the database, it updates the record; 
///     otherwise, it adds new record.
Future<IkpResponse<IkpRecord>> saveRecord({
  required String recordType,
  required Map<String, dynamic> fields,
  String? recordName,
});
```

```dart
/// Get a record
Future<IkpResponse<IkpRecord>> getRecord({
   required String recordName
});
```

```dart
/// Get a list of records
Future<IkpResponse<IkpListRecord>> getRecords({
  required String recordType,
  String cursor = "",
  int limit = 20,
  List<String>? fields,
});
```

```dart
/// Get all records
Future<IkpResponse<List<IkpRecord>>> getAll({
  required String recordType,
  List<String>? fields,
});
```


```dart
/// Delete a record
Future<IkpResponse<String>> deleteRecord({
   required String recordName
});
```

```dart
/// Clear all records
Future<IkpResponse<int>> clearRecord({
   required String recordType
});
```

```dart
/// Find records
Future<IkpResponse<IkpListRecord>> findRecords({
  required String recordType,
  List<IkpFilter>? filters,
  List<IkpSort>? sortFields,
  List<String>? fields,
  String? cursor,
  int limit = 20,
});

```

# **readme** 
**arguments** 
- containerId: The container ID of the iCloud Kit Database. Default is "".
- scope: The scope of the iCloud Kit Database. Default is `private`.
- recordType: The recordType of the iCloud Kit Database. 
- recordName: The recordName of the iCloud Kit Database. 
  - When recordName is empty, the saveRecord function adds new record; 
  - when recordName is not empty: 
    - if the value of recordName exists in the database, it updates the record; 
    - otherwise, it adds new record.
- filters:  Database conditions for finding records. Default is `null`.
- sortFields: The sortFields of the iCloud Kit Database. Default is `null`.
- fields: The fields of the iCloud Kit Database. if set to null, all fields are returned; if set to [], the values in the records are returned as empty. Default is `null`.

- limit: The limit of the iCloud Kit Database. Default is `20`.
- cursor: The cursor of the iCloud Kit Database. Use cursor in conjunction with limit. If there are more records, the cursor is not empty; if there are no more record, the cursor is "".Default is `""`.


**Configure Xcode**
See [Enabling CloudKit in Your App](https://developer.apple.com/documentation/cloudkit/managing_icloud_containers_with_the_cloudkit_database_app/inspecting_and_editing_an_icloud_container_s_schema#3404860).

Basically, before you start using the plugin, you need to:
- Add the iCloud Capability to Your Xcode Project;
- Create a container you're going to use in Xcode;
- Select the CloudKit checkbox;
- Check the box next to the container name;
- Also, in order to be able to retrieve records by type, you will need to add some indexes to the CloudKit database.

See [Enable Querying for Your Record Type](https://developer.apple.com/documentation/cloudkit/managing_icloud_containers_with_the_cloudkit_database_app/inspecting_and_editing_an_icloud_container_s_schema#3404860).

**For every new record type you'll need to do the following:**
1. Create the first record of this type;
2. Go to the CloudKit Console;
3. Select your database;
4. Go to the Indexes;
5. Select your record type;
6. Click Add Basic Index and create two indexes:
   - FIELD: recordName and Index Type: QUERYABLE (needed to fetch records);
   - FIELD: createdTimestamp and Index Type: SORTABLE (needed to sort them by creation time).
7. Click Save Changes





