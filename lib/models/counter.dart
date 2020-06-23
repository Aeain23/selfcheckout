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
      {this.syskey,
      this.autokey,
      this.createddate,
      this.modifieddate,
      this.userid,
      this.username,
      this.recordStatus,
      this.syncBatch,
      this.syncStatus,
      this.t1,
      this.t2,
      this.t3,
      this.userSysKey,
      this.n1,
      this.n2});
  factory Counter.fromJson(Map<String, dynamic> json) => Counter(
      syskey: json['syskey'],
      autokey: json['autokey'],
      createddate: json['createddate'],
      modifieddate: json['modifieddate'],
      userid: json['userid'],
      username: json['username'],
      recordStatus: json['recordStatus'],
      syncBatch: json['syncBatch'],
      syncStatus: json['syncStatus'],
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
        'syncBatch': syncBatch,
        'syncStatus': syncStatus,
        't1': t1,
        't2': t2,
        't3': t3,
        'userSysKey': userSysKey,
        'n1': n1,
        'n2': n2
      };
}
