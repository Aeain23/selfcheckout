import 'package:flutter/foundation.dart';

class CheckHeader {
  final String id;
  final int syskey;
  final int autokey;
  final String createddate;
  final String modifieddate;
  final String userid;
  final String username;
  final double territorycode;
  final double salescode;
  final double projectcode;
  double ref1;
  final double ref2;
  final double ref3;
  final double ref4;
  final String ref5;
  final double ref6;
  final int savestatus;
  final int recordstatus;
  final int syncStatus;
  final double syncBatch;
  final int transType;
  final String t1;
  final String t2;
  final String t3;
  final String t4;
  final String t5;
  final String t6;
  final String t7;
  final String t8;
  final String t9;
  final String t10;
  final String t11;
  final String n1;
  final double n2;
  final String n3;
  final double n4;
  double n5;
  final double n6;
  final double n7;
  final double n8;
  final double n9;
  double n10;
  final double n11;
  final double n12;
  final int n13;
  double n14;
  final double n15;
  final String n16;
  final int n17;
  final int n18;
   int n19;
   int n20;
  final String n21;
  final double n22;
  final String n23;
  final double n24;
  final double n25;
  final String n26;
  final double n27;
  final double n28;
  final String n29;
  final String t12;
  final String t13;
  final String t14;
  String t15;
  final String t16;
  final String t17;
  final String t18;
  final int n30;
  final String userSysKey;
  final double n31;
  final double n32;
  final double n33;
  final String n34;
  final double n35;
  final String t19;
  final String t20;
  final int n36;
  final Table table;
  final Counter counter;
  final String result;
  final String locid;

  CheckHeader({
    @required this.id,
    @required this.syskey,
    @required this.autokey,
    @required this.createddate,
    @required this.modifieddate,
    @required this.userid,
    @required this.username,
    @required this.territorycode,
    @required this.salescode,
    @required this.projectcode,
    @required this.ref1,
    @required this.ref2,
    @required this.ref3,
    @required this.ref4,
    @required this.ref5,
    @required this.ref6,
    @required this.savestatus,
    @required this.recordstatus,
    @required this.t1,
    @required this.t2,
    @required this.t3,
    @required this.t4,
    @required this.t5,
    @required this.t6,
    @required this.t7,
    @required this.t8,
    @required this.t9,
    @required this.t10,
    @required this.t11,
    @required this.n1,
    @required this.n2,
    @required this.n3,
    @required this.n4,
    @required this.n5,
    @required this.n6,
    @required this.n7,
    @required this.n8,
    @required this.n9,
    @required this.n10,
    @required this.n11,
    @required this.n12,
    @required this.n13,
    @required this.n14,
    @required this.n15,
    @required this.n16,
    @required this.n17,
    @required this.n18,
    @required this.n19,
    @required this.n20,
    @required this.n21,
    @required this.n22,
    @required this.n23,
    @required this.n24,
    @required this.n25,
    @required this.n26,
    @required this.n27,
    @required this.n28,
    @required this.n29,
    @required this.t12,
    @required this.t13,
    @required this.t14,
    @required this.t15,
    @required this.t16,
    @required this.t17,
    @required this.t18,
    @required this.n30,
    @required this.n31,
    @required this.n32,
    @required this.n33,
    @required this.n34,
    @required this.n35,
    @required this.t19,
    @required this.t20,
    @required this.n36,
    @required this.table,
    @required this.counter,
    @required this.result,
    @required this.locid,
    @required this.syncStatus,
    @required this.syncBatch,
    @required this.userSysKey,
    @required this.transType,
  });
  factory CheckHeader.fromJson(Map<String, dynamic> json) => CheckHeader(
      id: json['id'],
      syskey: json['syskey'],
      autokey: json['autokey'],
      createddate: json['createddate'],
      modifieddate: json['modifieddate'],
      userid: json['userid'],
      username: json['username'],
      territorycode: json['territorycode'],
      salescode: json['salescode'],
      projectcode: json['projectcode'],
      ref1: json['ref1'],
      ref2: json['ref2'],
      ref3: json['ref3'],
      ref4: json['ref4'],
      ref5: json['ref5'],
      ref6: json['ref6'],
      savestatus: json['savestatus'],
      recordstatus: json['recordstatus'],
      t1: json['t1'],
      t2: json['t2'],
      t3: json['t3'],
      t4: json['t4'],
      t5: json['t5'],
      t6: json['t6'],
      t7: json['t7'],
      t8: json['t8'],
      t9: json['t9'],
      t10: json['t10'],
      t11: json['t11'],
      n1: json['n1'],
      n2: json['n2'],
      n3: json['n3'],
      n4: json['n4'],
      n5: json['n5'],
      n6: json['n6'],
      n7: json['n7'],
      n8: json['n8'],
      n9: json['n9'],
      n10: json['n10'],
      n11: json['n11'],
      n12: json['n12'],
      n13: json['n13'],
      n14: json['n14'],
      n15: json['n15'],
      n16: json['n16'],
      n17: json['n17'],
      n18: json['n18'],
      n19: json['n19'],
      n20: json['n20'],
      n21: json['n21'],
      n22: json['n22'],
      n23: json['n23'],
      n24: json['n24'],
      n25: json['n25'],
      n26: json['n26'],
      n27: json['n27'],
      n28: json['n28'],
      n29: json['n29'],
      t12: json['t12'],
      t13: json['t13'],
      t14: json['t14'],
      t15: json['t15'],
      t16: json['t16'],
      t17: json['t17'],
      t18: json['t18'],
      n30: json['n30'],
      n31: json['n31'],
      n32: json['n32'],
      n33: json['n33'],
      n34: json['n34'],
      n35: json['n35'],
      t19: json['t19'],
      t20: json['t20'],
      n36: json['n36'],
      table: Table.fromJson(json['table']),
      counter: Counter.fromJson(json['counter']),
      // table: json['table']
      //     .map<Table>((value) => new Table.fromJson(value))
      //     .toList(),
      // counter: json['counter']
      //     .map<Counter>((value) => new Counter.fromJson(value))
      //     .toList(),
      result: json['result'],
      locid: json['locid'],
      syncStatus: json['syncStatus'],
      syncBatch: json['syncBatch'],
      userSysKey: json['userSysKey'],
      transType: json['transType']);
  Map<String, dynamic> toJson() => {
        'id': id,
        'syskey': syskey,
        'autokey': autokey,
        'createddate': createddate,
        'modifieddate': modifieddate,
        'userid': userid,
        'username': username,
        'territorycode': territorycode,
        'salescode': salescode,
        'projectcode': projectcode,
        'ref1': ref1,
        'ref2': ref2,
        'ref3': ref3,
        'ref4': ref4,
        'ref5': ref5,
        'ref6': ref6,
        'savestatus': savestatus,
        'recordstatus': recordstatus,
        't1': t1,
        't2': t2,
        't3': t3,
        't4': t4,
        't5': t5,
        't6': t6,
        't7': t7,
        't8': t8,
        't9': t9,
        't10': t10,
        't11': t11,
        'n1': n1,
        'n2': n2,
        'n3': n3,
        'n4': n4,
        'n5': n5,
        'n6': n6,
        'n7': n7,
        'n8': n8,
        'n9': n9,
        'n10': n10,
        'n11': n11,
        'n12': n12,
        'n13': n13,
        'n14': n14,
        'n15': n15,
        'n16': n16,
        'n17': n17,
        'n18': n18,
        'n19': n19,
        'n20': n20,
        'n21': n21,
        'n22': n22,
        'n23': n23,
        'n24': n24,
        'n25': n25,
        'n26': n26,
        'n27': n27,
        'n28': n28,
        'n29': n29,
        't12': t12,
        't13': t13,
        't14': t14,
        't15': t15,
        't16': t16,
        't17': t17,
        't18': t18,
        'n30': n30,
        'n31': n31,
        'n32': n32,
        'n33': n33,
        'n34': n34,
        'n35': n35,
        't19': t19,
        't20': t20,
        'n36': n36,
        'table': table,
        'counter': counter,
        'result': result,
        'locid': locid,
        'syncStatus': syncStatus,
        'syncBatch': syncBatch,
        'userSysKey': userSysKey,
        'transType': transType
      };
}

class Table {
  final String syskey;
  final double autokey;
  final String createddate;
  final String modifieddate;
  final String userid;
  final String username;
  final int recordStatus;
  final String t1;
  final String t2;
  final String t3;
  final String t4;
  final int n1;
  final int n2;
  final int n3;
  final int syncStatus;
  final double syncBatch;
  final double userSysKey;

  Table({
    @required this.syskey,
    @required this.autokey,
    @required this.createddate,
    @required this.modifieddate,
    @required this.userid,
    @required this.username,
    @required this.recordStatus,
    @required this.t1,
    @required this.t2,
    @required this.t3,
    @required this.t4,
    @required this.n1,
    @required this.n2,
    @required this.n3,
    @required this.syncStatus,
    @required this.syncBatch,
    @required this.userSysKey,
  });
  factory Table.fromJson(Map<String, dynamic> json) => Table(
      syskey: json['syskey'],
      autokey: json['autokey'],
      createddate: json['createddate'],
      modifieddate: json['modifieddate'],
      userid: json['userid'],
      username: json['username'],
      recordStatus: json['recordStatus'],
      t1: json['t1'],
      t2: json['t2'],
      t3: json['t3'],
      t4: json['t4'],
      n1: json['n1'],
      n2: json['n2'],
      n3: json['n3'],
      syncStatus: json['syncStatus'],
      syncBatch: json['syncBatch'],
      userSysKey: json['userSysKey']);
  Map<String, dynamic> toJson() => {
        'syskey': syskey,
        'autokey': autokey,
        'createddate': createddate,
        'modifieddate': modifieddate,
        'userid': userid,
        'username': username,
        'recordStatus': recordStatus,
        't1': t1,
        't2': t2,
        't3': t3,
        't4': t4,
        'n1': n1,
        'n2': n2,
        'n3': n3,
        'syncStatus': syncStatus,
        'syncBatch': syncBatch,
        'userSysKey': userSysKey
      };
}

class Counter {
  final String syskey;
  final double autokey;
  final String createddate;
  final String modifieddate;
  final String userid;
  final String username;
  final int recordStatus;
  final int syncStatus;
  final int syncBatch;
  final String t1;
  final String t2;
  final String t3;
  final int userSysKey;
  final int n1;
  final int n2;

  Counter({
    @required this.syskey,
    @required this.autokey,
    @required this.createddate,
    @required this.modifieddate,
    @required this.userid,
    @required this.username,
    @required this.recordStatus,
    @required this.syncStatus,
    @required this.syncBatch,
    @required this.t1,
    @required this.t2,
    @required this.t3,
    @required this.userSysKey,
    @required this.n1,
    @required this.n2,
  });
  factory Counter.fromJson(Map<String, dynamic> json) => Counter(
      syskey: json['syskey'],
      autokey: json['autokey'],
      createddate: json['createddate'],
      modifieddate: json['modifieddate'],
      userid: json['userid'],
      username: json['username'],
      recordStatus: json['recordStatus'],
      syncStatus: json['syncStatus'],
      syncBatch: json['syncBatch'],
      t1: json['t1'],
      t2: json['t2'],
      t3: json['t3'],
      userSysKey: json['userSysKey'],
      n1: json['n1'],
      n2: json['n2']);
  Map<String, dynamic> toJson() => {
        'syskey': syskey,
        'autokey': autokey,
        'createddate': createddate,
        'modifieddate': modifieddate,
        'userid': userid,
        'username': username,
        'recordStatus': recordStatus,
        'syncStatus': syncStatus,
        'syncBatch': syncBatch,
        't1': t1,
        't2': t2,
        't3': t3,
        'userSysKey': userSysKey,
        'n1': n1,
        'n2': n2
      };
}

class VoidCheckHeader {
  final bool state;
  final String msgCode;
  final String msgDesc;
  final List longResult;
  final List stringResult;
  VoidCheckHeader(
      {this.state,
      this.msgCode,
      this.msgDesc,
      this.longResult,
      this.stringResult});
  factory VoidCheckHeader.fromJson(Map<String, dynamic> json) =>
      VoidCheckHeader(
        state: json['state'],
        msgCode: json['msgCode'],
        msgDesc: json['msgDesc'],
        longResult: json['longResult'] as List,
        stringResult: json['stringResult'] as List,
      );
}
