class CounterData {
  final List<Counter> counter;
  CounterData({this.counter});
  factory CounterData.fromJson(Map<String, dynamic> json) => CounterData(
        counter:
            (json['counter'] as List).map((i) => Counter.fromJson(i)).toList(),
      );
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
  Counter(
      {this.autokey,
      this.createddate,
      this.modifieddate,
      this.n1,
      this.n2,
      this.recordStatus,
      this.syncBatch,
      this.syncStatus,
      this.syskey,
      this.t1,
      this.t2,
      this.t3,
      this.userSysKey,
      this.userid,
      this.username});
  factory Counter.fromJson(Map<String, dynamic> json) => Counter(
        autokey: json['autokey'],
        createddate: json['createddate'],
        modifieddate: json['modifieddate'],
        n1: json['n1'],
        n2: json['n2'],
        recordStatus: json['recordStatus'],
        syncBatch: json['syncBatch'],
        syncStatus: json['syncStatus'],
        syskey: json['syskey'],
        t1: json['t1'],
        t2: json['t2'],
        t3: json['t3'],
        userSysKey: json['userSysKey'],
        userid: json['userid'],
        username: json['username'],
      );
}
