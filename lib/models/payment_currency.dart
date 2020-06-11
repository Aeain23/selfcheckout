import 'package:flutter/foundation.dart';

class Currency {
  final String id;
  final int syskey;
  final int autokey;
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
  final int n1;
  final double n2;
  final double n3;
  final int n4;
  final int n5;
  final int n6;
  final int userSyskey;
  final String t4;
  Currency(
      {@required this.id,
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
      @required this.n1,
      @required this.n2,
      @required this.n3,
      @required this.n4,
      @required this.n5,
      @required this.n6,
      @required this.userSyskey,
      @required this.t4});
  factory Currency.fromJson(Map<String, dynamic> json) => Currency(
      id: json['id'],
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
      n1: json['n1'],
      n2: json['n2'],
      n3: json['n3'],
      n4: json['n4'],
      n5: json['n5'],
      n6: json['n6'],
      userSyskey: json['userSyskey'],
      t4: json['t4']);
}
