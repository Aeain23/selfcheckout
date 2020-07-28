import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:number_display/number_display.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import '../models/card_usage.dart';
import '../models/login.dart';
import '../providers/card_usage_provider.dart';
import '../providers/connectionprovider.dart';
import '../providers/member_scan_provider.dart';
import '../screens/splash_screen.dart';
import '../screens/plastic_bag_screen.dart';
import '../localization/language_constants.dart';
import '../models/check_detail_item.dart';
import '../models/member_scan.dart';
import '../models/promotion_use.dart';
import '../providers/save_checkheader_provider.dart';
import '../providers/stock_provider.dart';
import '../screens/payment_screen.dart';
import '../screensize_reducer.dart';
import '../widgets/app_bar_widget.dart';
import 'package:button3d/button3d.dart';
class MemberSKUDiscount extends StatefulWidget {
  final String name;
  final String card;
  final String point;
  final double promotion;
  final MemberScan memberScan;
  final PromotionUse promotionUse;
  final int cuponCount;
  final String system;
  final String locationName;
  MemberSKUDiscount(
      {this.card,
      this.point,
      this.promotion,
      this.name,
      this.memberScan,
      this.promotionUse,
      this.cuponCount,
      this.system,
      this.locationName});
  @override
  _MemberSKUDiscountState createState() => _MemberSKUDiscountState();
}

class _MemberSKUDiscountState extends State<MemberSKUDiscount> {
  var numSeparate;
  Widget _createTableHeader(String label) {
    return Container(
      height: 30,
      alignment: Alignment.center,
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _createTableCell(String label) {
    return Container(
      margin: EdgeInsets.only(left: 5, top: 5, bottom: 5),
      // height: 30,
      alignment: Alignment.centerLeft,
      child: Text(
        label,
        textAlign: TextAlign.left,
        style: TextStyle(color: Colors.black),
      ),
    );
  }

  Widget _createTableCell1(String label) {
    return Container(
      margin: EdgeInsets.only(left: 5, top: 5, bottom: 5, right: 5),
      alignment: Alignment.centerRight,
      child: Text(
        label,
        textAlign: TextAlign.right,
        style: TextStyle(color: Colors.black),
      ),
    );
  }

  bool keyboard;
  int couponCount = 0;
  int n17 = 0;
  int n19 = 0;
  int n20 = 0;
  var locFlag;
  var memberFlag;
  int totalforcupon;
  List<CardTypeList> cardtypeList = [];
  @override
  void initState() {
    super.initState();
    final cardTypelistProvider =
        Provider.of<CardTypeListProvider>(context, listen: false);

    final providerheader =
        Provider.of<SaveCheckHeaderProvider>(context, listen: false);
    final provider = Provider.of<StockProvider>(context, listen: false);
    totalforcupon = provider.totalAmount.round();

    print("Total for cupon: $totalforcupon");

    var systemforcupon = json.decode(widget.system);
    var systemsetup = SystemSetup.fromJson(systemforcupon);

    print("object in system :${widget.locationName}");
    if (systemsetup.n50 != 0) {
      var location = systemsetup.t41;
      var locationList = [];
      locationList = location.split(',');
      locFlag = false;
      for (int i = 0; i < locationList.length; i++) {
        if (widget.locationName == locationList[i].toString()) {
          locFlag = true;
          print("Cupon in location locFlag $locFlag");
          print(
              "member $totalforcupon > ${systemsetup.n51}  ${systemsetup.n52}");
          print(
              "member $totalforcupon > ${systemsetup.n55}  ${systemsetup.n56}");
          break;
        }
      }
    }
    Provider.of<MemberScanProvider>(context, listen: false)
        .fetchBusinessData()
        .then((date) {
      if (systemsetup.n50 != 0 &&
          int.parse(systemsetup.t38) <= date &&
          int.parse(systemsetup.t39) >= date &&
          systemsetup.n51 != 0 &&
          locFlag == true) {
        if (widget.memberScan.cardNumber != "" &&
            widget.memberScan.cardNumber != "undefined" &&
            widget.memberScan.cardNumber != null) {
          print(
              "member $totalforcupon > ${systemsetup.n51}  ${systemsetup.n52}");

          if (totalforcupon >= systemsetup.n51 && systemsetup.n52 == 1) {
            print("object");
            cardTypelistProvider
                .fetchCardTypeList(widget.memberScan.cardTypeID)
                .then((result) {
              print(result);
              // cardtypeList = result;
              memberFlag = result;
              print("cardtypeList  result $result");
              // for (int j = 0; j < cardtypeList.length; j++) {
              //   print(
              //       "Member scan cardtypeList Id : ${cardtypeList[j].cardTypeId}");
              //   if ((widget.memberScan.cardTypeID.toString() ==
              //           cardtypeList[j].cardTypeId.toString()) &&
              //       cardtypeList[j].includeStatus == 1) {
              //     memberFlag = true;
              //     print("Cupon in member  memberflag $memberFlag");
              //     break;
              //   }
              // }

              if (memberFlag == true) {
                print(systemsetup.n55);
                if (systemsetup.n55 == 1) {
                  print(providerheader.chkHeader);
                  if (providerheader.chkHeader != null) {
                    var sumItemAmount = 0.0;
                    cardTypelistProvider
                        .getSumAmountofSelectedCouponItem(
                            providerheader.chkHeader)
                        .then((onValue) {
                      sumItemAmount = onValue;
                      if (sumItemAmount >= systemsetup.n56) {
                        couponCount =
                            ((totalforcupon / systemsetup.n51)).floor() *
                                systemsetup.n53;
                        n17 = systemsetup.n56.toInt();
                        n19 = systemsetup.n51.toInt();
                        n20 = systemsetup.n53;
                        print("cupon count is : $couponCount");
                        print("cupon n17 is: $n17");
                        print(" cupon n19 : $n19");
                        print(" cupon n20 : $n20");
                        providerheader.chkHeader.n17 = n17;
                        providerheader.chkHeader.n19 = n19;
                        providerheader.chkHeader.n20 = n20;
                      }
                    });
                  } else {
                    //Toast
                  }
                } else {
                  couponCount = ((totalforcupon / systemsetup.n51)).floor() *
                      systemsetup.n53;
                  providerheader.chkHeader.n17 = 1;
                  providerheader.chkHeader.n19 = systemsetup.n51.toInt();
                  providerheader.chkHeader.n20 = systemsetup.n53;
                }
              }
            });
          } else {
            providerheader.chkHeader.n17 = 0;
            providerheader.chkHeader.n19 = 0;
            providerheader.chkHeader.n20 = 0;
          }
          // }
          //  else {
          //   if (totalforcupon >= systemsetup.n51) {
          //     couponCount = (totalforcupon / systemsetup.n51).floor();
          //     n17 = 1;
          //     n19 = systemsetup.n51.toInt();
          //     n20 = systemsetup.n53;
          //     print(" cupon count is : $couponCount in else condition");
          //     print(" cupon n17 : $n17 in else condition");
          //     print(" cupon n19 : $n19 in else condition");
          //     print(" cupon n20 : $n20 in else condition");
          //     providerheader.chkHeader.n19 = n19;
          //     providerheader.chkHeader.n20 = n20;
          //   } else {
          //     couponCount = 0;
          //     providerheader.chkHeader.n19 = 0;
          //     providerheader.chkHeader.n20 = 0;
          //   }
        }
      }
    });
    // providerheader.chkHeader.n19 = n19;
    // providerheader.chkHeader.n20 = n20;
  }

  ProgressDialog dialog;
  @override
  Widget build(BuildContext context) {
    numSeparate = createDisplay(
      length: 16,
      separator: ',',
    );

    final provider = Provider.of<StockProvider>(context, listen: true);
    double comercial;
    List<CheckDetailItem> chkdtls =
        Provider.of<StockProvider>(context, listen: false).getchkdtlsList();
    var providerheader;
    try {
      providerheader =
          Provider.of<SaveCheckHeaderProvider>(context, listen: false);
      comercial = providerheader.chkHeader.n14;
    } catch (e) {}
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
    return Scaffold(
      appBar: AppBarWidget(),
      body: WillPopScope(
        onWillPop: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => PlasticBagScreen(),
            ),
          );
          return Future.value(false);
        },
        child: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Image.asset("assets/images/city_reward.jpg"),
                                Text(
                                  getTranslated(context, "welcome_back"),
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${widget.name}',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 18.0),
                              child: Text(getTranslated(context,
                                  "you_have_in_your_city_rewards_balance")),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 20.0,
                              ),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    getTranslated(context, "city_cash"),
                                    style: TextStyle(color: Color(0xFF9B629B)),
                                  ),
                                  Text(
                                    ": Ks ${numSeparate(double.parse(widget.card).round())}",
                                    style: TextStyle(color: Color(0xFF9B629B)),
                                  ), //{numSeparate(double.parse(widget.card))}
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    getTranslated(context, "points"),
                                    style: TextStyle(color: Color(0xFF9B629B)),
                                  ),
                                  Text(
                                    ": ${numSeparate(double.parse(widget.point).round())}",
                                    style: TextStyle(color: Color(0xFF9B629B)),
                                  ), //${numSeparate(double.parse(widget.point))}
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  child: SingleChildScrollView(
                    child: Container(
                        color: Colors.grey[300],
                        child: Column(
                          children: <Widget>[
                            Table(
                                columnWidths: {
                                  0: FlexColumnWidth(1.8),
                                  1: FlexColumnWidth(0.5),
                                  2: FlexColumnWidth(0.8),
                                },
                                border: TableBorder.all(),
                                children: [
                                  TableRow(
                                    children: [
                                      TableCell(
                                          child: _createTableHeader(
                                              getTranslated(context, "item"))),
                                      TableCell(
                                          child: _createTableHeader(
                                              getTranslated(context, "qty"))),
                                      TableCell(
                                          child: _createTableHeader(
                                              getTranslated(context, "ks"))),
                                    ],
                                  ),
                                  for (int i = 0; i < chkdtls.length; i++)
                                    (chkdtls.length > 0 &&
                                            chkdtls[i].recordStatus != 4)
                                        ? TableRow(
                                            children: [
                                              TableCell(
                                                  child: _createTableCell(
                                                      '${chkdtls[i].t3}')),
                                              TableCell(
                                                  child: _createTableCell1(
                                                      "${chkdtls[i].n8.round()}")),
                                              TableCell(
                                                  child: (chkdtls[i].n34 != 0.0)
                                                      ? _createTableCell1(
                                                          "${numSeparate(chkdtls[i].n34.round())}")
                                                      : _createTableCell1(
                                                          "-${numSeparate(chkdtls[i].n8.round() * chkdtls[i].n14.round())}")),
                                            ],
                                          )
                                        : TableRow(
                                            children: [
                                              TableCell(
                                                child: Container(height: 0.0),
                                              ),
                                              TableCell(
                                                child: Container(height: 0.0),
                                              ),
                                              TableCell(
                                                child: Container(height: 0.0),
                                              ),
                                            ],
                                          ),
                                  for (int j = 0; j < chkdtls.length; j++)
                                    (chkdtls[j].n19 != 0 &&
                                            chkdtls[j].n34 != 0.0 &&
                                            chkdtls[j].recordStatus != 4)
                                        ? TableRow(
                                            children: [
                                              TableCell(
                                                  child: _createTableCell(
                                                      "${chkdtls[j].t3}")),
                                              TableCell(
                                                  child: _createTableCell1(
                                                      "${chkdtls[j].n8.round()}")),
                                              TableCell(
                                                  child: _createTableCell1(
                                                      "-${(chkdtls[j].n8 * chkdtls[j].n19).round()}")),
                                            ],
                                          )
                                        : TableRow(
                                            children: [
                                              TableCell(
                                                child: Container(height: 0.0),
                                              ),
                                              TableCell(
                                                child: Container(height: 0.0),
                                              ),
                                              TableCell(
                                                child: Container(height: 0.0),
                                              ),
                                            ],
                                          ),
                                  (widget.promotion.round() != 0)
                                      ? TableRow(
                                          children: [
                                            TableCell(
                                                child: _createTableCell(
                                                    getTranslated(context,
                                                        "city_reward_discount"))),
                                            TableCell(
                                                child: _createTableCell1("")),
                                            TableCell(
                                                child: _createTableCell1(
                                                    "${widget.promotion.round()}")),
                                          ],
                                        )
                                      : TableRow(
                                          children: [
                                            TableCell(
                                              child: Container(height: 0.0),
                                            ),
                                            TableCell(
                                              child: Container(height: 0.0),
                                            ),
                                            TableCell(
                                              child: Container(height: 0.0),
                                            ),
                                          ],
                                        ),
                                  TableRow(
                                    children: [
                                      TableCell(child: _createTableCell("")),
                                      TableCell(child: _createTableCell1("")),
                                      TableCell(child: _createTableCell1("")),
                                    ],
                                  ),
                                  // TableRow(
                                  //   children: [
                                  //     TableCell(child: _createTableCell("Total Qty")),
                                  //     TableCell(
                                  //         child: _createTableCell1(
                                  //             "${provider.qty.round()}")),
                                  //     TableCell(child: _createTableCell1("")),
                                  //   ],
                                  // ),
                                  TableRow(
                                    children: [
                                      TableCell(
                                          child: _createTableCell(getTranslated(
                                              context, "total_include_tax"))),
                                      TableCell(
                                          child: _createTableCell1(
                                              "${provider.qty.round()}")),
                                      TableCell(
                                          child: _createTableCell1(
                                              "${numSeparate(provider.totalAmount.round())}")),
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      TableCell(
                                          child: _createTableCell(getTranslated(
                                              context, "commercial_tax"))),
                                      TableCell(child: _createTableCell1("")),
                                      (comercial != null)
                                          ? TableCell(
                                              child: _createTableCell1(
                                                  "${comercial.round()}"))
                                          : TableCell(
                                              child: _createTableCell1("0")),
                                    ],
                                  ),
                                ]),
                          ],
                        )),
                  ),
                ),
              ]),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            height: screenHeight(context, dividedBy: 10),
            width: screenWidth(context, dividedBy: 2.4),
            margin: EdgeInsets.only(left: 180),
            child:
            //  RaisedButton(
            //     elevation: 5,
            //     shape: Theme.of(context).buttonTheme.shape,
            //     color: Theme.of(context).buttonColor,
              Button3d(
                width: 120,
                height: 40,
                style: Button3dStyle(
                  topColor: Theme.of(context).textTheme.button.color,
                  // backColor: Theme.of(context).buttonColor,
                    backColor: Color(0xFFA7A7A7),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  getTranslated(context, "next"),
                  style: TextStyle(
                      color: Colors.black),
                ),
                onPressed: () {
                  Provider.of<ConnectionProvider>(context, listen: false)
                      .checkconnection()
                      .then((onValue) {
                    if (onValue) {
                      dialog.show();
                      String cash = widget.card;
                      String point = widget.point;
                      String name = widget.name;
                      Provider.of<SaveCheckHeaderProvider>(context,
                              listen: false)
                          .fetchSaveHeader(
                              provider.totalAmount, provider.chkdtlsList)
                          .catchError((onError) {
                        dialog.hide().whenComplete(() {
                          Fluttertoast.showToast(
                              msg: "SavecheckHeader Error! $onError",
                              timeInSecForIosWeb: 4);
                        });
                      }).then((saveHeader) {
                        // var ss = json.encode(saveHeader.checkHeader);
                        // print("Cdgkjgk Save header $ss");
                        print(
                            "Coupon function in n19 $n19 and n20 is $n20 in savecheck header");
                        print("result state ${saveHeader.result.state}");
                        if (saveHeader.result.state == true) {
                          // Future.delayed(Duration(seconds: 3)).then((value) {
                          dialog.hide().whenComplete(() {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => PaymentTypeScreen(
                                  cash: cash,
                                  point: point,
                                  name: name,
                                  memberScan: widget.memberScan,
                                  promotionUse: widget.promotionUse,
                                  cuponCount: couponCount,
                                ),
                              ),
                            );
                          });
                          // });
                        } else {
                          // Future.delayed(Duration(seconds: 3)).then((value) {
                          dialog.hide().whenComplete(() {
                            Fluttertoast.showToast(
                                msg: "${saveHeader.result.msgDesc}",
                                timeInSecForIosWeb: 4);
                            if (saveHeader.result.msgDesc ==
                                "This Slip is already paid!") {
                              provider.removeAll();
                              providerheader.chkHeader = null;
                              if (provider.totalAmount == 0.0) {
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
                      }); //
                    } else {
                      dialog.hide().whenComplete(() {
                        Fluttertoast.showToast(
                            msg: getTranslated(
                                context, "no_internet_connection"),
                            timeInSecForIosWeb: 4);
                      });
                    }
                  });
                }),
          ),
          FloatingActionButton(
            elevation: 5,
            backgroundColor: Color(0xFF6F51A1),
            onPressed: () async {
              // Navigator.of(context).pop();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => PlasticBagScreen(),
                ),
              );
            },
            child: Container(
              child: Icon(
                Icons.reply,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}
