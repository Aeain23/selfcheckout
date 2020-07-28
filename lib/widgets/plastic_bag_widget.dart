import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import '../screens/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/stock_list_screen.dart';
import '../localization/language_constants.dart';
import '../providers/member_scan_provider.dart';
import '../screensize_reducer.dart';
import '../widgets/card_widget.dart';
import '../widgets/member_sku_discount_widget.dart';
import '../providers/connectionprovider.dart';
import '../models/check_detail_item.dart';
import '../providers/stock_provider.dart';
import '../providers/save_checkheader_provider.dart';

class PlasticBagWidget extends StatefulWidget {
  @override
  _PlasticBagWidgetState createState() => _PlasticBagWidgetState();
}

class _PlasticBagWidgetState extends State<PlasticBagWidget> {
  int bigPlasticQty, smallPlasticQty;
  double bigPrice, smallPrice;
  String userid;
  String password;
  String locationSyskey;
  String counterSyskey;
  String locationName;
  String system;
  String ref;
  void readLogin() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    // setState(() {
    userid = preferences.getString("username");
    password = preferences.getString("password");
    locationSyskey = preferences.getString("locationSyskey");
    counterSyskey = preferences.getString("counterSyskey");
    locationName = preferences.getString("locationName");
    system = preferences.getString("name");
    ref = preferences.getString("ref");
    // });
  }

  @override
  void initState() {
    bigPlasticQty = 0;
    smallPlasticQty = 0;
    bigPrice = 100;
    smallPrice = 50;
    readLogin();
    super.initState();
  }

  String formattedDate = DateFormat.yMMMd().format(DateTime.now());
  ProgressDialog dialog;
  @override
  Widget build(BuildContext context) {
    final provider =
        Provider.of<SaveCheckHeaderProvider>(context, listen: false);
    final connectionProvider = Provider.of<ConnectionProvider>(context);
    final stockProvider = Provider.of<StockProvider>(context, listen: true);
    final memberScanProvider =
        Provider.of<MemberScanProvider>(context, listen: false);
    dialog = new ProgressDialog(context, isDismissible: false);
    dialog.style(
      message: getTranslated(context, "please_wait"),
      progressWidget: Center(
        child: CircularProgressIndicator(
          valueColor:
              new AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
        ),
      ),
      insetAnimCurve: Curves.easeInOut,
    );

    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => StockListScreen(),
          ),
        );
        return Future.value(false);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 20),
            child: Center(
              child: Text(
                getTranslated(context, "do_you_need_a_plastic_bag"),
                style: TextStyle(fontSize: 18, color: Color(0xFF9B629B)),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                width: double.infinity,
                height: screenHeight(context, dividedBy: 7),
                child: Card(
                  color: Colors.grey[300],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          'assets/images/new1.png',
                          fit: BoxFit.contain,
                          width: screenWidth(context, dividedBy: 4),
                          height: screenHeight(context, dividedBy: 4),
                        ),
                      ),
                      Container(
                        width: screenWidth(context, dividedBy: 3),
                        height: screenHeight(context, dividedBy: 3),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text(
                              getTranslated(context, "large_plastic_bag"),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(Icons.remove_circle),
                                  iconSize: Theme.of(context).iconTheme.size,
                                  color: Color(0xFF6F51A1),
                                  onPressed: bigPlasticQty <= 0
                                      ? null
                                      : () {
                                          setState(() {
                                            bigPlasticQty--;
                                            if (bigPlasticQty == 0 ||
                                                bigPlasticQty == 1) {
                                              bigPrice = 100;
                                            } else {
                                              bigPrice -= 100;
                                            }
                                          });
                                        },
                                ),
                                Text(bigPlasticQty.toString()),
                                IconButton(
                                  icon: Icon(Icons.add_circle),
                                  iconSize: Theme.of(context).iconTheme.size,
                                  color: Color(0xFF6F51A1),
                                  onPressed: () {
                                    stockProvider
                                        .fetchStockbybarCode('250600220')
                                        .catchError((onError) {
                                      Fluttertoast.showToast(
                                          msg:
                                              "This stock can't avaliable $onError ");
                                    }).then((onValue) {
                                      setState(() {
                                        bigPlasticQty++;
                                        if (bigPlasticQty == 0 ||
                                            bigPlasticQty == 1) {
                                          bigPrice = 100;
                                        } else {
                                          bigPrice += 100;
                                        }
                                      });
                                      stockProvider
                                          .addstocktoList(onValue.chkDtls[0]);
                                    });
                                  },
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Container(
                        // width:screenWidth(context, dividedBy: 3),
                        height: screenHeight(context, dividedBy: 3),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(),
                            Text('Ks ${bigPrice.toString().split('.').first}'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: screenHeight(context, dividedBy: 7),
                child: Card(
                  margin: EdgeInsets.only(top: 8, left: 8, right: 8),
                  color: Colors.grey[300],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          'assets/images/new1.png',
                          fit: BoxFit.contain,
                          width: screenWidth(context, dividedBy: 4),
                          height: screenHeight(context, dividedBy: 4),
                        ),
                      ),
                      Container(
                        width: screenWidth(context, dividedBy: 3),
                        height: screenHeight(context, dividedBy: 3),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text(
                              getTranslated(context, "small_plastic_bag"),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(Icons.remove_circle),
                                  iconSize: Theme.of(context).iconTheme.size,
                                  color: Color(0xFF6F51A1),
                                  onPressed: smallPlasticQty <= 0
                                      ? null
                                      : () {
                                          setState(() {
                                            smallPlasticQty--;
                                            if (smallPlasticQty == 0 ||
                                                smallPlasticQty == 1) {
                                              smallPrice = 50;
                                            } else {
                                              smallPrice -= 50;
                                            }
                                          });
                                        },
                                ),
                                Text(smallPlasticQty.toString()),
                                IconButton(
                                  icon: Icon(Icons.add_circle),
                                  iconSize: Theme.of(context).iconTheme.size,
                                  color: Color(0xFF6F51A1),
                                  onPressed: () {
                                    stockProvider
                                        .fetchStockbybarCode('110100182')
                                        .catchError((onError) {
                                      Fluttertoast.showToast(
                                          msg:
                                              "This stock can't avaliable $onError ");
                                    }).then((onValue) {
                                      setState(() {
                                        smallPlasticQty++;
                                        if (smallPlasticQty == 0 ||
                                            smallPlasticQty == 1) {
                                          smallPrice = 50;
                                        } else {
                                          smallPrice += 50;
                                        }
                                      });
                                      stockProvider
                                          .addstocktoList(onValue.chkDtls[0]);
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: screenHeight(context, dividedBy: 3),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(),
                            Text(
                                'Ks ${smallPrice.toString().split('.').first}'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Container(
              width: screenSize(context).width,
              height: screenHeight(context, dividedBy: 10),
              child: Center(
                child: Text(
                  getTranslated(context, "thank_you_for_going_green"),
                  style: TextStyle(fontSize: 18, color: Color(0xFF9B629B)),
                ),
              )),
          Container(
            margin: EdgeInsets.only(bottom: 20),
            width: screenWidth(context, dividedBy: 2.4),
            height: screenHeight(context, dividedBy: 10),
            child: RaisedButton(
              elevation: 5,
              color: Theme.of(context).buttonColor,
              shape: Theme.of(context).buttonTheme.shape,
              child: Text(
                getTranslated(context, "checkout"),
                style:
                    TextStyle(color: Theme.of(context).textTheme.button.color),
              ),
              onPressed: () {
                // if (bigPlasticQty != 0) {
                //   stockProvider.addstocktoList(CheckDetailItem(
                //       id: "0",
                //       syskey: "0",
                //       autokey: 0,
                //       createddate: formattedDate,
                //       modifieddate: formattedDate,
                //       userid: "",
                //       username: "",
                //       territorycode: 0,
                //       salescode: 0,
                //       projectcode: 0,
                //       ref1: 0,
                //       ref2: 0,
                //       ref3: "0",
                //       ref4: 0,
                //       ref5: 0,
                //       ref6: 0,
                //       parentid: "0",
                //       recordStatus: 0,
                //       t1: "250600220",
                //       t2: "1000000011172",
                //       t3: "Large Plastic Bag",
                //       t4: "MMK",
                //       t5: "",
                //       t6: "MMK",
                //       n1: "1000000011172",
                //       n2: "1408200837330000078",
                //       n3: 0,
                //       n4: "0",
                //       n5: 0,
                //       n6: 0.0,
                //       n7: "100000001117201",
                //       n8: bigPlasticQty.toDouble(),
                //       n9: 0.0,
                //       n10: 0.0,
                //       n11: 0.0,
                //       n12: 0.0,
                //       n13: 0.0,
                //       n14: 100.0,
                //       n15: 1.0,
                //       n16: 0.0,
                //       n17: 1.0,
                //       n18: 1.0,
                //       n19: 0.0,
                //       n20: 0.0,
                //       n21: 0.0,
                //       n22: 0.0,
                //       n23: 5.0,
                //       n24: "2006081004304642033",
                //       n25: 0,
                //       n26: "2006081004214309019",
                //       n27: 0,
                //       n28: "2006081004340412040",
                //       n29: 0,
                //       n30: 0,
                //       n31: 0,
                //       n32: 0,
                //       n33: "0",
                //       n34: bigPrice,
                //       n35: 0,
                //       n36: 0,
                //       n37: 100.0,
                //       n38: 0.0,
                //       n39: 0,
                //       n40: 0,
                //       n41: 0,
                //       n42: 0,
                //       n43: 0,
                //       n44: 1.0,
                //       t7: "",
                //       n45: "100000001117201",
                //       n46: 0.0,
                //       t8: "",
                //       n47: 1.0,
                //       t9: "*",
                //       n48: 0.0,
                //       n49: 100.0,
                //       t10: "SU1",
                //       t11: "",
                //       n50: 5.0,
                //       n51: 0.0,
                //       n52: 0.0,
                //       brandSysKey: "800033",
                //       categorySysKey: "1208",
                //       groupSysKey: "0",
                //       constingMethod: 0,
                //       unit: [
                //         UnitData(
                //             uomSK: "83851",
                //             stkCode: "250600220",
                //             stkUOMSK: "100000001117201",
                //             uomRatio: 1.0,
                //             priceType: 2,
                //             price: 100.0,
                //             uomDesc: "SU1",
                //             orgPrice: 1.0),
                //         UnitData(
                //             uomSK: "83851",
                //             stkCode: "360600212",
                //             stkUOMSK: "100000001117201",
                //             uomRatio: 1.0,
                //             priceType: 2,
                //             price: 100.0,
                //             uomDesc: "SU1",
                //             orgPrice: 1.0),
                //         UnitData(
                //             uomSK: "83851",
                //             stkCode: "2000000255651",
                //             stkUOMSK: "100000001117201",
                //             uomRatio: 1.0,
                //             priceType: 2,
                //             price: 100.0,
                //             uomDesc: "SU1",
                //             orgPrice: 1.0),
                //         UnitData(
                //             uomSK: "83851",
                //             stkCode: "8834000003042",
                //             stkUOMSK: "100000001117201",
                //             uomRatio: 1.0,
                //             priceType: 2,
                //             price: 100.0,
                //             uomDesc: "SU1",
                //             orgPrice: 1.0)
                //       ],
                //       discount: "",
                //       returnMessage: null,
                //       discountAmount: null,
                //       pricetype: 2,
                //       uomprice: 100.0,
                //       hdrid: "",
                //       saveFlag: 0,
                //       itemType: 0,
                //       oldQty: 0,
                //       syncStatus: 0,
                //       syncBatch: 0,
                //       $$hashKey: "",
                //       isSavedItem: "",
                //       isChangedQty: ""));
                // }
                // if (smallPlasticQty != 0) {
                //   stockProvider.addstocktoList(CheckDetailItem(
                //       id: "0",
                //       syskey: "0",
                //       autokey: 0,
                //       createddate: formattedDate,
                //       modifieddate: formattedDate,
                //       userid: "",
                //       username: "",
                //       territorycode: 0,
                //       salescode: 0,
                //       projectcode: 0,
                //       ref1: 0,
                //       ref2: 0,
                //       ref3: "0",
                //       ref4: 0,
                //       ref5: 0,
                //       ref6: 0,
                //       parentid: "0",
                //       recordStatus: 0,
                //       t1: "110100280",
                //       t2: "1000000002247",
                //       t3: "Small Plastic Bag",
                //       t4: "MMK",
                //       t5: "",
                //       t6: "MMK",
                //       n1: "1000000002247",
                //       n2: "1408200837330000078",
                //       n3: 0,
                //       n4: "0",
                //       n5: 0,
                //       n6: 0.0,
                //       n7: "100000000224701",
                //       n8: smallPlasticQty.toDouble(),
                //       n9: 0.0,
                //       n10: 0.0,
                //       n11: 0.0,
                //       n12: 0.0,
                //       n13: 0.0,
                //       n14: 50.0,
                //       n15: 1.0,
                //       n16: 0.0,
                //       n17: 1.0,
                //       n18: 1.0,
                //       n19: 0.0,
                //       n20: 0.0,
                //       n21: 0.0,
                //       n22: 0.0,
                //       n23: 2.0,
                //       n24: "2006081004304642033",
                //       n25: 0,
                //       n26: "2006081004214309019",
                //       n27: 0,
                //       n28: "2006081004340412040",
                //       n29: 0,
                //       n30: 0,
                //       n31: 0,
                //       n32: 0,
                //       n33: "0",
                //       n34: smallPrice,
                //       n35: 0,
                //       n36: 0,
                //       n37: 50.0,
                //       n38: 0.0,
                //       n39: 0,
                //       n40: 0,
                //       n41: 0,
                //       n42: 0,
                //       n43: 0,
                //       n44: 1.0,
                //       t7: "",
                //       n45: "100000000224701",
                //       n46: 0.0,
                //       t8: "",
                //       n47: 1.0,
                //       t9: "*",
                //       n48: 0.0,
                //       n49: 50.0,
                //       t10: "SU1",
                //       t11: "",
                //       n50: 5.0,
                //       n51: 0.0,
                //       n52: 0.0,
                //       brandSysKey: "770025",
                //       categorySysKey: "1112",
                //       groupSysKey: "0",
                //       constingMethod: 0,
                //       unit: [
                //         UnitData(
                //             uomSK: "83851",
                //             stkCode: "11010028",
                //             stkUOMSK: "100000000224701",
                //             uomRatio: 1.0,
                //             priceType: 2,
                //             price: 50.0,
                //             uomDesc: "SU1",
                //             orgPrice: 1.0),
                //         UnitData(
                //             uomSK: "83851",
                //             stkCode: "110100280",
                //             stkUOMSK: "100000000224701",
                //             uomRatio: 1.0,
                //             priceType: 2,
                //             price: 50.0,
                //             uomDesc: "SU1",
                //             orgPrice: 1.0),
                //         UnitData(
                //             uomSK: "83851",
                //             stkCode: "051325115405",
                //             stkUOMSK: "100000000224701",
                //             uomRatio: 1.0,
                //             priceType: 2,
                //             price: 50.0,
                //             uomDesc: "SU1",
                //             orgPrice: 1.0),
                //         UnitData(
                //             uomSK: "83851",
                //             stkCode: "2000001699706",
                //             stkUOMSK: "100000000224701",
                //             uomRatio: 1.0,
                //             priceType: 2,
                //             price: 50.0,
                //             uomDesc: "SU1",
                //             orgPrice: 1.0),
                //         UnitData(
                //             uomSK: "83852",
                //             stkCode: "2000001429808",
                //             stkUOMSK: "100000000224702",
                //             uomRatio: 1.0,
                //             priceType: 2,
                //             price: 4000.0,
                //             uomDesc: "SU2",
                //             orgPrice: 1.0),
                //         UnitData(
                //             uomSK: "83852",
                //             stkCode: "110100281",
                //             stkUOMSK: "100000000224702",
                //             uomRatio: 1.0,
                //             priceType: 2,
                //             price: 4000.0,
                //             uomDesc: "SU2",
                //             orgPrice: 1.0),
                //         UnitData(
                //             uomSK: "83852",
                //             stkCode: "110100282",
                //             stkUOMSK: "100000000224702",
                //             uomRatio: 1.0,
                //             priceType: 2,
                //             price: 4000.0,
                //             uomDesc: "SU2",
                //             orgPrice: 1.0),
                //         UnitData(
                //             uomSK: "83852",
                //             stkCode: "11010030",
                //             stkUOMSK: "100000000224702",
                //             uomRatio: 1.0,
                //             priceType: 2,
                //             price: 4000.0,
                //             uomDesc: "SU2",
                //             orgPrice: 1.0)
                //       ],
                //       discount: "",
                //       returnMessage: null,
                //       discountAmount: null,
                //       pricetype: 2,
                //       uomprice: 50.0,
                //       hdrid: "",
                //       saveFlag: 0,
                //       itemType: 0,
                //       oldQty: 0,
                //       syncStatus: 0,
                //       syncBatch: 0,
                //       $$hashKey: "",
                //       isSavedItem: "",
                //       isChangedQty: "")
                // );
                // }

                connectionProvider.checkconnection().then((onValue) {
                  if (onValue) {
                    dialog.show();
                    double total = stockProvider.totalAmount;

                    List<CheckDetailItem> chkdtls =
                        stockProvider.getchkdtlsList();
                    print("check detail list: $chkdtls");

                    provider.fetchSaveHeader(total, chkdtls).then((result) {
                      setState(() {
                        stockProvider
                            .changeTotalForPromotion(result.checkDetailItem);
                      });

                      print("result state ${result.result.state}");
                      if (result.result.state == true) {
                        stockProvider
                            .prepareCheckDetail(result.checkDetailItem);
                        print(" provider header :${provider.chkHeader.t15}");
                        print("${result.checkDetailItem}>>>>>>>>>>>>");
                        if (provider.chkHeader.t15 == "") {
                          // Future.delayed(Duration(seconds: 3)).then((value) {
                          dialog.hide().whenComplete(() {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => CardWidget(),
                              ),
                            );
                          });
                          // });
                        } else {
                          dialog.show();
                          // Provider.of<MemberScanProvider>(context,
                          //         listen: false)
                          //     .fetchMemberScan('${provider.chkHeader.t15}')
                          //     .catchError((onError) {
                          //   Future.delayed(Duration(seconds: 3)).then((value) {
                          //     dialog.hide().whenComplete(() {
                          //       Fluttertoast.showToast(
                          //           msg: getTranslated(context, "$onError"),
                          //           timeInSecForIosWeb: 4);
                          //     });
                          //   });
                          // }).then((result) {
                          String cash = memberScanProvider
                              .reuseMemberScan.cardBalance[0].creditAmount;
                          String point = memberScanProvider
                              .reuseMemberScan.cardBalance[1].creditAmount;
                          String name = memberScanProvider
                              .reuseMemberScan.accountValue.firstName;
                          if ('${provider.chkHeader.t15}' ==
                              memberScanProvider.reuseMemberScan.cardNumber) {
                            Provider.of<MemberScanProvider>(context,
                                    listen: false)
                                .fetchPromotionUse(
                                    memberScanProvider
                                        .reuseMemberScan.accountValue,
                                    stockProvider.getchkdtlsList(),
                                    provider.chkHeader)
                                .catchError((onError) {
                              // Future.delayed(Duration(seconds: 3))
                              //     .then((value) {
                              dialog.hide().whenComplete(() {
                                Fluttertoast.showToast(
                                    msg: getTranslated(context, "$onError"),
                                    timeInSecForIosWeb: 4);
                              });
                              // });
                            }).then((onValue) {
                              for (int i = 0;
                                  i < onValue.ordervalue.orderItems.length;
                                  i++) {
                                var promotionCodeRef = "";
                                var itemVal = onValue.ordervalue.orderItems[i];
                                for (int j = 0;
                                    j < stockProvider.chkdtlsList.length;
                                    j++) {
                                  var tmpItemCode =
                                      stockProvider.chkdtlsList[j].t2 +
                                          "-" +
                                          stockProvider.chkdtlsList[j].t10;
                                  if (tmpItemCode == itemVal.itemCode) {
                                    int tmp =
                                        (itemVal.totalPriceDiscountInt).toInt();
                                    stockProvider.chkdtlsList[j].n35 = tmp;
                                    if (stockProvider.chkdtlsList[j].n21 == 0) {
                                      stockProvider.chkdtlsList[j].n34 =
                                          stockProvider.chkdtlsList[j].n34 -
                                              tmp;
                                    }
                                    stockProvider.chkdtlsList[j].n21 =
                                        stockProvider.chkdtlsList[j].n21 + tmp;
                                    stockProvider.chkdtlsList[j].ref4 = 1;
                                    stockProvider.chkdtlsList[j].t10 =
                                        itemVal.unitName;
                                    if (itemVal.promotionCodeRef != "") {
                                      var proCodes = [];
                                      proCodes =
                                          itemVal.promotionCodeRef.split(',');
                                      for (int pc = 0;
                                          pc < proCodes.length;
                                          pc++) {
                                        var proCode = proCodes[pc];
                                        for (int p = 0;
                                            p < onValue.promotionvalue.length;
                                            p++) {
                                          var pUse = onValue.promotionvalue[p];
                                          if (proCode.split(':')[0] ==
                                              pUse.promotionCode) {
                                            promotionCodeRef +=
                                                pUse.promotionDetail +
                                                    " - " +
                                                    proCode.split(':')[1];
                                            if (promotionCodeRef != "") {
                                              promotionCodeRef += ",";
                                            }
                                          }
                                        }
                                      }
                                    }
                                    stockProvider.chkdtlsList[j].t7 =
                                        promotionCodeRef;
                                  }
                                }
                              }
                              double cityDis = 0.0;
                              for (int i = 0;
                                  i < onValue.ordervalue.orderItems.length;
                                  i++) {
                                cityDis += onValue.ordervalue.orderItems[i]
                                    .totalPriceDiscountInt;
                              }
                              double jj = cityDis;
                              // Future.delayed(Duration(seconds: 3))
                              //     .then((value) {
                              dialog.hide().whenComplete(() {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => MemberSKUDiscount(
                                      card: cash,
                                      point: point,
                                      promotion: jj,
                                      name: name,
                                      memberScan:
                                          memberScanProvider.reuseMemberScan,
                                      promotionUse: onValue,
                                      // cuponCount: couponCount,
                                      system: system,
                                      locationName: locationName,
                                    ),
                                  ),
                                );
                              });
                              // });
                            });
                          } else {
                            Fluttertoast.showToast(
                                msg: getTranslated(context, "invalid_card_no"),
                                timeInSecForIosWeb: 4);
                          }
                          // });
                        }
                      } else {
                        // Future.delayed(Duration(seconds: 3)).then((value) {
                        dialog.hide().whenComplete(() {
                          Fluttertoast.showToast(
                              msg: "${result.result.msgDesc}",
                              timeInSecForIosWeb: 4);
                          if (result.result.msgDesc ==
                              "This Slip is already paid!") {
                            stockProvider.removeAll();
                            provider.chkHeader = null;
                            if (stockProvider.totalAmount == 0.0) {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => SplashsScreen(),
                                ),
                              );
                            }
                          }
                        });
                        // });
                      }
                    }).catchError((onError) {
                      dialog.hide().whenComplete(() {
                        Fluttertoast.showToast(
                            msg: "Save check Header Error $onError",
                            timeInSecForIosWeb: 4);
                      });
                    });
                  } else {
                    dialog.hide().whenComplete(() {
                      Fluttertoast.showToast(
                        timeInSecForIosWeb: 4,
                        msg: getTranslated(context, "no_internet_connection"),
                      );
                    });
                  }
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
