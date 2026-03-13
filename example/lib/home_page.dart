import 'dart:developer' as dev;
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icloud_kit_provider/icloud_kit_provider.dart';
import 'package:uuid/uuid.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // final provider = IcloudKitProvider(containerId: "iCloud.com.houyzx.iauthcode");
  final provider = IcloudKitProvider(containerId: "");
  String _result = 'Unknown';
  final Random _random = Random();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CupertinoNavigationBar(middle: Text("icloud kit plugin")),
      body: Padding(
        padding: EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 20,
              children: [
                ElevatedButton(
                  onPressed: _getAccountStatus,
                  child: Text("account status"),
                ),
                ElevatedButton(
                  onPressed: _saveRecord,
                  child: Text("save record"),
                ),
                ElevatedButton(
                  onPressed: _getRecordList,
                  child: Text("get record"),
                ),
                ElevatedButton(
                  onPressed: _getOneRecord,
                  child: Text("get one record"),
                ),
                ElevatedButton(
                  onPressed: _getAll,
                  child: Text("get all record"),
                ),
                ElevatedButton(onPressed: _del, child: Text("delete record")),
                ElevatedButton(onPressed: _clear, child: Text("clear record")),
                ElevatedButton(onPressed: _find, child: Text("find")),
              ],
            ),
            Text('result：'),
            Expanded(child: SingleChildScrollView(child: Text(_result))),
          ],
        ),
      ),
    );
  }

  Future<void> _getAccountStatus() async {
    var result = await provider.getAccountStatus();
    showResult(result);
  }

  Future<void> _getRecordList() async {
    var result = await provider.getRecords(recordType: "auth_item", limit: 3);
    showResult(result);
  }

  Future<void> _getOneRecord() async {
    var result = await provider.getRecord(
      recordName: "44be7dd2a09a4ea19ece0e258f8df93a",
    );
    showResult(result);
  }

  Future<void> _getAll() async {
    var result = await provider.getAll(recordType: "auth_item");
    if (result.isOK()) {
      setState(() {
        _result = "all count: ${result.data?.length}";
      });
    } else {
      setState(() {
        _result = result.msg;
      });
    }
  }

  Future<void> _del() async {
    var result = await provider.deleteRecord(
      recordName: "a8a673a57f81495db0b6c3bc82058c83",
    );
    setState(() {
      if (result.isOK()) {
        _result = "${result.data}";
      } else {
        _result = result.msg;
      }
    });
  }

  Future<void> _clear() async {
    var result = await provider.clearRecord(recordType: "auth_item");
    showResult(result);
  }

  void showResult(IkpResponse result) {
    if (result.isOK()) {
      setState(() {
        _result = "${result.data}";
      });
    } else {
      setState(() {
        _result = "$result";
      });
    }
  }

  Future<void> _find() async {
    var result = await provider.findRecords(
      recordType: "auth_item_test",
      filters: [
        IkpFilter(field: "index", operator: IkpOperator.lessThan, value: 50),
      ],
      fields: ["index", "name", "vip"],
      sortFields: [
        IkpSort(field: "index", direction: IkpSortDirection.ascending),
      ],
    );

    showResult(result);
  }

  Future<void> _saveRecord() async {
    for (var i = 0; i < 156; i++) {
      var values = makeValues(i);
      var r = await provider.saveRecord(
        recordType: "auth_item_test",
        values: values,
      );
      if (r.isOK()) {
        info("save record: ${r.data}");
      } else {
        info("save record error: ${r.msg}");
      }
    }

    setState(() {
      _result = "add records success";
    });
    // var result = await provider.saveRecord(
    //   recordType: "auth_item",
    //   values: {
    //     "name": "test",
    //     "code": "123456",
    //     "data": {"name": "test"}.toString(),
    //   },
    // );
    // showResult(result);
  }

  Map<String, dynamic> makeValues(int index) {
    Map<String, dynamic> values = {};
    values["id"] = Uuid().v4().replaceAll("-", "");
    values["name"] = Uuid().v4().replaceAll("-", "");

    values["code_int"] = _random.nextInt(1000000);
    values["money"] = _random.nextDouble() * 1000000;
    values["vip"] = _random.nextBool();
    values["index"] = index;
    values["createTime"] = DateTime.now().millisecondsSinceEpoch;
    values["updateTime"] = DateTime.now().toUtc().millisecondsSinceEpoch;
    values["deleteTime"] = DateTime.now().toLocal().millisecondsSinceEpoch;

    return values;
  }

  void info(String msg) {
    dev.log(msg);
  }
}

// {
//  recordType: auth_item_test,
//  recordName: 95A891EF-6780-4477-9424-68B386645385,
//  recordValue: {code: 123456, name: test}
// }
