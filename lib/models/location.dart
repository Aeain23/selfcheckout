class LocationData {
  final List<Location> location;
  LocationData({this.location});
  factory LocationData.fromJson(Map<String, dynamic> json) => LocationData(
        location: (json['location'] as List)
            .map((i) => Location.fromJson(i))
            .toList(),
      );
}

class Location {
  final int syskey;
  final String locId;
  final double autokey;
  final String createddate;
  final String modifieddate;
  final String userid;
  final String username;
  final String t1;
  final String t2;
  final int n1;
  final int n2;
  final int n3;
  final int n4;
  final int recordStatus;
  final int syncStatus;
  final int syncBatch;
  final double userSysKey;
  Location(
      {this.autokey,
      this.createddate,
      this.locId,
      this.modifieddate,
      this.n1,
      this.n2,
      this.n3,
      this.n4,
      this.recordStatus,
      this.syncBatch,
      this.syncStatus,
      this.syskey,
      this.t1,
      this.t2,
      this.userSysKey,
      this.userid,
      this.username});
  factory Location.fromJson(Map<String, dynamic> json) => Location(
        userSysKey: json['userSysKey'],
        syskey: json['syskey'],
        locId: json['locId'],
        autokey: json['autokey'],
        createddate: json['createddate'],
        modifieddate: json['modifieddate'],
        userid: json['userid'],
        username: json['username'],
        t1: json['t1'],
        t2: json['t2'],
        n1: json['n1'],
        n2: json['n2'],
        n3: json['n3'],
        n4: json['n4'],
        recordStatus: json['recordStatus'],
        syncStatus: json['syncStatus'],
        syncBatch: json['syncBatch'],
      );
}
