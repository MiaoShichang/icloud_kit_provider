# icloud_kit_provider
 ---
A simple flutter plugin for interactions with Apple Cloud Kit API on iOS devices.




# Usage
```dart
// create a instance of IcloudKitProvider
final provider = IcloudKitProvider();
```

```dart
// get status of the user account 
provider.getAccountStatus()
```

```dart
// save one record;
provider.saveRecord()
```
```dart
// get one record 
provider.getRecord()
```

```dart
// get record list
provider.getRecord()
```

```dart
// delete record
provider.deleteRecord()
```

```dart
// find records 
provider.findRecords()
```

# setup
---
See [Enabling CloudKit in Your App](https://developer.apple.com/documentation/cloudkit/managing_icloud_containers_with_the_cloudkit_database_app/inspecting_and_editing_an_icloud_container_s_schema#3404860).

Basically, before you start using the plugin, you need to:

- Add the iCloud Capability to Your Xcode Project;
- Create a container you're going to use in Xcode;
- Select the CloudKit checkbox;
- Check the box next to the container name;
- Also, in order to be able to retrieve records by type, you will need to add some indexes to the CloudKit database.

See [Enable Querying for Your Record Type](https://developer.apple.com/documentation/cloudkit/managing_icloud_containers_with_the_cloudkit_database_app/inspecting_and_editing_an_icloud_container_s_schema#3404860).

### For every new record type you'll need to do the following:
1. Create the first record of this type;
2. Go to the CloudKit Console;
3. Select your database;
4. Go to the Indexes;
5. Select your record type;
6. Click Add Basic Index and create two indexes:
   - FIELD: recordName and Index Type: QUERYABLE (needed to fetch records);
   - FIELD: createdTimestamp and Index Type: SORTABLE (needed to sort them by creation time).
7. Click Save Changes





