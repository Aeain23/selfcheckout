
class PaymentType {
  final String syskey;
  final String autokey;
  final String createdate;
  final String modifieddate;
  final String userid;
  final String username;
  final String t1;
  final String t2;
  final String t3;
  final int n1;
  final double n2;
  final int n3;
  final int n4;
  final int recordStatus;
  final int syncStatus;
  final double syncBatch;
  final double userSysKey;
  PaymentType(
      {this.syskey,
      this.autokey,
      this.createdate,
      this.modifieddate,
      this.userid,
      this.username,
      this.t1,
      this.t2,
      this.t3,
      this.n1,
      this.n2,
      this.n3,
      this.n4,
      this.recordStatus,
      this.syncStatus,
      this.syncBatch,
      this.userSysKey});
  factory PaymentType.fromJson(Map<String, dynamic> json) => PaymentType(
      syskey: json['syskey'],
      autokey: json['autokey'],
      createdate: json['createdate'],
      modifieddate: json['modifieddate'],
      userid: json['userid'],
      username: json['username'],
      t1: json['t1'],
      t2: json['t2'],
      t3: json['t3'],
      n1: json['n1'],
      n2: json['n2'],
      n3: json['n3'],
      n4: json['n4'],
      recordStatus: json['recordStatus'],
      syncStatus: json['syncStatus'],
      syncBatch: json['syncBatch'],
      userSysKey: json['userSysKey']);
}
