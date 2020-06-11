import 'package:flutter/foundation.dart';

class CheckDetailItem {
  final String id;
  final String syskey;
  final int autokey;
  final String createddate;
  final String modifieddate;
  String userid;
  String username;
  final int territorycode;
  final int salescode;
  final int projectcode;
  int ref1;
  int ref2;
  final String ref3;
  int ref4;
  final int ref5;
  final int ref6;
  final String parentid;
  int recordStatus;
  final String t1;
  final String t2;
  final String t3;
  final String t4;
  final String t5;
  final String t6;
  final String n1;
  final String n2;
  final int n3;
  final String n4;
  final int n5;
  final double n6;
  final String n7;
  double n8;
  final double n9;
  final double n10;
  final double n11;
  final double n12;
  final double n13;
  double n14;
  final double n15;
  final double n16;
  final double n17;
  final double n18;
  final double n19;
  final double n20;
  double n21;
  final double n22;
  final double n23;
  final String n24;
  final int n25;
  final String n26;
  final int n27;
  final String n28;
  final int n29;
  final int n30;
  final int n31;
  final int n32;
  final String n33;
  double n34;
  int n35;
  final int n36;
  final double n37;
  final double n38;
  final int n39;
  final int n40;
  final int n41;
  final int n42;
  final int n43;
  final double n44;
  String t7;
  final String n45;
  final double n46;
  final String t8;
  final double n47;
  final String t9;
  final double n48;
  final double n49;
  String t10;
  final String t11;
  final double n50;
  final double n51;
  final double n52;
  final String brandSysKey;
  final String categorySysKey;
  final String groupSysKey;
  final int constingMethod;
  final List<UnitData> unit;
  final String discount;
  final String returnMessage;
  final String discountAmount;
  final int pricetype;
  final double uomprice;
  final String hdrid;
  final int saveFlag;
  final int itemType;
  final int oldQty;
  final int syncStatus;
  final int syncBatch;
  String $$hashKey;
  String isSavedItem;
  String isChangedQty;

  CheckDetailItem({
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
    @required this.parentid,
    @required this.recordStatus,
    @required this.t1,
    @required this.t2,
    @required this.t3,
    @required this.t4,
    @required this.t5,
    @required this.t6,
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
    @required this.n30,
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
    @required this.t7,
    @required this.n45,
    @required this.n46,
    @required this.t8,
    @required this.n47,
    @required this.t9,
    @required this.n48,
    @required this.n49,
    @required this.t10,
    @required this.t11,
    @required this.n50,
    @required this.n51,
    @required this.n52,
    @required this.brandSysKey,
    @required this.categorySysKey,
    @required this.groupSysKey,
    @required this.constingMethod,
    @required this.unit,
    @required this.discount,
    @required this.returnMessage,
    @required this.discountAmount,
    @required this.pricetype,
    @required this.uomprice,
    @required this.hdrid,
    @required this.saveFlag,
    @required this.itemType,
    @required this.oldQty,
    @required this.syncStatus,
    @required this.syncBatch,
    @required this.$$hashKey,
    @required this.isSavedItem,
    @required this.isChangedQty,
  });
  factory CheckDetailItem.fromJson(Map<String, dynamic> json) =>
      CheckDetailItem(
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
        parentid: json['parentid'],
        recordStatus: json['recordStatus'],
        t1: json['t1'],
        t2: json['t2'],
        t3: json['t3'],
        t4: json['t4'],
        t5: json['t5'],
        t6: json['t6'],
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
        n30: json['n30'],
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
        t7: json['t7'],
        n45: json['n45'],
        n46: json['n46'],
        t8: json['t8'],
        n47: json['n47'],
        t9: json['t9'],
        n48: json['n48'],
        n49: json['n49'],
        t10: json['t10'],
        t11: json['t11'],
        n50: json['n50'],
        n51: json['n51'],
        n52: json['n52'],
        brandSysKey: json['brandSysKey'],
        categorySysKey: json['categorySysKey'],
        groupSysKey: json['groupSysKey'],
        constingMethod: json['constingMethod'],
        unit: json['unit']
            .map<UnitData>((value) => new UnitData.fromJson(value))
            .toList(),
        discount: json['discount'],
        returnMessage: json['returnMessage'],
        discountAmount: json['discountAmount'],
        pricetype: json['pricetype'],
        uomprice: json['uomprice'],
        hdrid: json['hdrid'],
        saveFlag: json['saveFlag'],
        itemType: json['itemType'],
        oldQty: json['oldQty'],
        syncStatus: json['syncStatus'],
        syncBatch: json['syncBatch'],
        $$hashKey: json['\$\$hashKey'],
        isSavedItem: json['isSavedItem'],
        isChangedQty: json['isChangedQty'],
      );
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
        'parentid': parentid,
        'recordStatus': recordStatus,
        't1': t1,
        't2': t2,
        't3': t3,
        't4': t4,
        't5': t5,
        't6': t6,
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
        'n30': n30,
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
        't7': t7,
        'n45': n45,
        'n46': n46,
        't8': t8,
        'n47': n47,
        't9': t9,
        'n48': n48,
        'n49': n49,
        't10': t10,
        't11': t11,
        'n50': n50,
        'n51': n51,
        'n52': n52,
        'brandSysKey': brandSysKey,
        'categorySysKey': categorySysKey,
        'groupSysKey': groupSysKey,
        'constingMethod': constingMethod,
        'unit': unit,
        'discount': discount,
        'returnMessage': returnMessage,
        'discountAmount': discountAmount,
        'pricetype': pricetype,
        'uomprice': uomprice,
        'hdrid': hdrid,
        'saveFlag': saveFlag,
        'itemType': itemType,
        'oldQty': oldQty,
        'syncStatus': syncStatus,
        'syncBatch': syncBatch,
        '\$\$hashKey': $$hashKey,
        'isSavedItem': isSavedItem,
        'isChangedQty': isChangedQty,
      };
}

class UnitData {
  final String uomSK;
  final String stkCode;
  final String stkUOMSK;
  final double uomRatio;
  final int priceType;
  final double price;
  final String uomDesc;
  final double orgPrice;
  UnitData({
    @required this.uomSK,
    @required this.stkCode,
    @required this.stkUOMSK,
    @required this.uomRatio,
    @required this.priceType,
    @required this.price,
    @required this.uomDesc,
    @required this.orgPrice,
  });
  factory UnitData.fromJson(Map<String, dynamic> json) => UnitData(
        uomSK: json['uomSK'],
        stkCode: json['stkCode'],
        stkUOMSK: json['stkUOMSK'],
        uomRatio: json['uomRatio'],
        priceType: json['priceType'],
        price: json['price'],
        uomDesc: json['uomDesc'],
        orgPrice: json['orgPrice'],
      );
  Map<String, dynamic> toJson() => {
        'uomSK': uomSK,
        'stkCode': stkCode,
        'stkUOMSK': stkUOMSK,
        'uomRatio': uomRatio,
        'priceType': priceType,
        'price': price,
        'uomDesc': uomDesc,
        'orgPrice': orgPrice
      };
}
