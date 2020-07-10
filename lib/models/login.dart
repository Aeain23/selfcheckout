import 'package:flutter/foundation.dart';

class Login {
  final String syskey;
  final int autokey;
  final String createddate;
  final String modifieddate;
  final String userid;
  final String username;
  final String t1;
  final String t2;
  final String t3;
  final String t4;
  final String t5;
  final String t6;
  final String t7;
  final int n1;
  final int n2;
  final int n3;
  final String n4;
  final int n5;
  final int n6;
  final int n7;
  final int n8;
  final List<LvlAppItemList> lvlAppItemList;
  final String returnMessage;
  final SystemSetup systemSetup;
  final String o1;
  final int recordStatus;
  final int syncStatus;
  final int syncBatch;
  final int userSyskey;

  Login({
    @required this.syskey,
    @required this.autokey,
    @required this.createddate,
    @required this.modifieddate,
    @required this.userid,
    @required this.username,
    @required this.t1,
    @required this.t2,
    @required this.t3,
    @required this.t4,
    @required this.t5,
    @required this.t6,
    @required this.t7,
    @required this.n1,
    @required this.n2,
    @required this.n3,
    @required this.n4,
    @required this.n5,
    @required this.n6,
    @required this.n7,
    @required this.n8,
    @required this.lvlAppItemList,
    @required this.returnMessage,
    @required this.systemSetup,
    @required this.o1,
    @required this.recordStatus,
    @required this.syncStatus,
    @required this.syncBatch,
    @required this.userSyskey,
  });
  factory Login.fromJson(Map<String, dynamic> json) => Login(
      syskey: json['syskey'],
      autokey: json['autokey'],
      createddate: json['createddate'],
      modifieddate: json['modifieddate'],
      userid: json['userid'],
      username: json['username'],
      t1: json['t1'],
      t2: json['t2'],
      t3: json['t3'],
      t4: json['t4'],
      t5: json['t5'],
      t6: json['t6'],
      t7: json['t7'],
      n1: json['n1'],
      n2: json['n2'],
      n3: json['n3'],
      n4: json['n4'],
      n5: json['n5'],
      n6: json['n6'],
      n7: json['n7'],
      n8: json['n8'],
      lvlAppItemList: (json['lvlAppItemList'] as List)
          .map<LvlAppItemList>((value) => new LvlAppItemList.fromJson(value))
          .toList(),
      returnMessage: json['returnMessage'],
      systemSetup: SystemSetup.fromJson(json['systemSetup']),
      o1: json['o1'],
      recordStatus: json['recordStatus'],
      syncStatus: json['syncStatus'],
      syncBatch: json['syncBatch'],
      userSyskey: json['userSyskey']);
}

class LvlAppItemList {
  final String autokey;
  final String createddate;
  final String modifieddate;
  final String userid;
  final String username;
  final String t1;
  final String t2;
  final String t3;
  final String n1;
  final String n2;
  final String n3;
  final int n4;
  final int n5;
  final int n6;
  final String syskey;
  final String userSysKey;
  final int recordStatus;
  final int syncStatus;
  final String syncBatch;

  LvlAppItemList(
      {@required this.autokey,
      @required this.createddate,
      @required this.modifieddate,
      @required this.userid,
      @required this.username,
      @required this.t1,
      @required this.t2,
      @required this.t3,
      @required this.n1,
      @required this.n2,
      @required this.n3,
      @required this.n4,
      @required this.n5,
      @required this.n6,
      @required this.syskey,
      @required this.userSysKey,
      @required this.recordStatus,
      @required this.syncStatus,
      @required this.syncBatch});
  factory LvlAppItemList.fromJson(Map<String, dynamic> json) => LvlAppItemList(
      autokey: json['autokey'],
      createddate: json['createddate'],
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
      n5: json['n5'],
      n6: json['n6'],
      syskey: json['syskey'],
      userSysKey: json['userSysKey'],
      recordStatus: json['recordStatus'],
      syncStatus: json['syncStatus'],
      syncBatch: json['syncBatch']);
}

class SystemSetup {
  final String syskey;
  final int autokey;
  final String createddate;
  final String modifieddate;
  final String userid;
  final String username;
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
  final String t12;
  final String t13;
  final String t14;
  final String t15;
  final String t16;
  final String t17;
  final String t18;
  final String t19;
  final String t20;
  final String t21;
  final String t22;
  final String t23;
  final String t24;
  final String t25;
  final String t26;
  final String t27;
  final String t28;
  final String t29;
  final String t30;
  final int n1;
  final int n2;
  final int n3;
  final int n4;
  final int n5;
  final int n6;
  final int n7;
  final int n8;
  final int n9;
  final int n10;
  final int n11;
  final int n12;
  final int n13;
  final int n14;
  final int n15;
  final String t31;
  final double n16;
  final int n17;
  final int n18;
  final int n19;
  final int n20;
  final int n21;
  final int n22;
  final int n23;
  final int n24;
  final int n25;
  final int n26;
  final int n27;
  final int n28;
  final int n29;
  final int n30;
  final String t32;
  final int n31;
  final int n32;
  final int n33;
  final int n34;
  final int n35;
  final int n36;
  final int n37;
  final int n38;
  final int n39;
  final int n40;
  final int n41;
  final int n42;
  final double n43;
  final int n44;
  final int n45;
  final int n46;
  final int n47;
  final int n48;
  final int n49;
  final int n50;
  final String t33;
  final String t34;
  final String t35;
  final String t36;
  final double n51;
  final String t37;
  final String t38;
  final String t39;
  final String t40;
  final String t41;
  final int n52;
  final int n53;
  final int n54;
  final String o1;
  final int recordStatus;
  final int syncStatus;
  final int syncBatch;
  final int userSyskey;
final int n55;
final double n56;

  SystemSetup(
      {@required this.syskey,
      @required this.autokey,
      @required this.createddate,
      @required this.modifieddate,
      @required this.userid,
      @required this.username,
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
      @required this.t12,
      @required this.t13,
      @required this.t14,
      @required this.t15,
      @required this.t16,
      @required this.t17,
      @required this.t18,
      @required this.t19,
      @required this.t20,
      @required this.t21,
      @required this.t22,
      @required this.t23,
      @required this.t24,
      @required this.t25,
      @required this.t26,
      @required this.t27,
      @required this.t28,
      @required this.t29,
      @required this.t30,
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
      @required this.t31,
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
      @required this.n30,
      @required this.t32,
      @required this.n31,
      @required this.n32,
      @required this.n33,
      @required this.n34,
      @required this.n35,
      @required this.n36,
      @required this.n37,
      @required this.n38,
      @required this.n39,
      @required this.n40,
      @required this.n41,
      @required this.n42,
      @required this.n43,
      @required this.n44,
      @required this.n45,
      @required this.n46,
      @required this.n47,
      @required this.n48,
      @required this.n49,
      @required this.n50,
      @required this.t33,
      @required this.t34,
      @required this.t35,
      @required this.t36,
      @required this.n51,
      @required this.t37,
      @required this.t38,
      @required this.t39,
      @required this.t40,
      @required this.t41,
      @required this.n52,
      @required this.n53,
      @required this.n54,
      @required this.o1,
      @required this.recordStatus,
      @required this.syncStatus,
      @required this.syncBatch,
      @required this.userSyskey,
       @required this.n55,
      @required this.n56});
  factory SystemSetup.fromJson(Map<String, dynamic> json) => SystemSetup(
        syskey: json['syskey'],
        autokey: json['autokey'],
        createddate: json['createddate'],
        modifieddate: json['modifieddate'],
        userid: json['userid'],
        username: json['username'],
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
        t12: json['t12'],
        t13: json['t13'],
        t14: json['t14'],
        t15: json['t15'],
        t16: json['t16'],
        t17: json['t17'],
        t18: json['t18'],
        t19: json['t19'],
        t20: json['t20'],
        t21: json['t21'],
        t22: json['t22'],
        t23: json['t23'],
        t24: json['t24'],
        t25: json['t25'],
        t26: json['t26'],
        t27: json['t27'],
        t28: json['t28'],
        t29: json['t29'],
        t30: json['t30'],
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
        t31: json['t31'],
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
        n30: json['n30'],
        t32: json['t32'],
        n31: json['n31'],
        n32: json['n32'],
        n33: json['n33'],
        n34: json['n34'],
        n35: json['n35'],
        n36: json['n36'],
        n37: json['n37'],
        n38: json['n38'],
        n39: json['n39'],
        n40: json['n40'],
        n41: json['n41'],
        n42: json['n42'],
        n43: json['n43'],
        n44: json['n44'],
        n45: json['n45'],
        n46: json['n46'],
        n47: json['n47'],
        n48: json['n48'],
        n49: json['n49'],
        n50: json['n50'],
        t33: json['t33'],
        t34: json['t34'],
        t35: json['t35'],
        t36: json['t36'],
        n51: json['n51'],
        t37: json['t37'],
        t38: json['t38'],
        t39: json['t39'],
        t40: json['t40'],
        t41: json['t41'],
        n52: json['n52'],
        n53: json['n53'],
        n54: json['n54'],
        o1: json['o1'],
        recordStatus: json['recordStatus'],
        syncStatus: json['syncStatus'],
        syncBatch: json['syncBatch'],
        userSyskey: json['userSyskey'],
         n55: json['n55'],
        n56: json['n56']
      );
  Map<String, dynamic> toJson() => {
        'syskey': syskey,
        'autokey': autokey,
        'createddate': createddate,
        'modifieddate': modifieddate,
        'userid': userid,
        'username': username,
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
        't12': t12,
        't13': t13,
        't14': t14,
        't15': t15,
        't16': t16,
        't17': t17,
        't18': t18,
        't19': t19,
        't20': t20,
        't21': t21,
        't22': t22,
        't23': t23,
        't24': t24,
        't25': t25,
        't26': t26,
        't27': t27,
        't28': t28,
        't29': t29,
        't30': t30,
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
        't31': t31,
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
        'n30': n30,
        't32': t32,
        'n31': n31,
        'n32': n32,
        'n33': n33,
        'n34': n34,
        'n35': n35,
        'n36': n36,
        'n37': n37,
        'n38': n38,
        'n39': n39,
        'n40': n40,
        'n41': n41,
        'n42': n42,
        'n43': n43,
        'n44': n44,
        'n45': n45,
        'n46': n46,
        'n47': n47,
        'n48': n48,
        'n49': n49,
        'n50': n50,
        't33': t33,
        't34': t34,
        't35': t35,
        't36': t36,
        'n51': n51,
        't37': t37,
        't38': t38,
        't39': t39,
        't40': t40,
        't41': t41,
        'n52': n52,
        'n53': n53,
        'n54': n54,
        'o1': o1,
        'recordStatus': recordStatus,
        'syncStatus': syncStatus,
        'syncBatch': syncBatch,
        'userSyskey': userSyskey,
         'n55': n55,
        'n56': n56,
      };
}
