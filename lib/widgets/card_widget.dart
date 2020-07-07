import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:number_display/number_display.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:self_check_out/screensize_reducer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../localization/language_constants.dart';
import '../providers/save_checkheader_provider.dart';
import '../providers/stock_provider.dart';
import '../screens/plastic_bag_screen.dart';
import '../widgets/non_member_widget.dart';
import '../providers/connectionprovider.dart';
import '../widgets/member_sku_discount_widget.dart';
import '../providers/member_scan_provider.dart';
import '../widgets/app_bar_widget.dart';

class CardWidget extends StatefulWidget {
  @override
  _CardWidgetState createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  TextEditingController controller = new TextEditingController();
  String cardNo;
  String no, cup;
  String userid;
  String password;
  String locationSyskey;
  String counterSyskey;
  String locationName;
  bool keyboard;
  String system;
  String ref;

  FocusNode _focusNode = new FocusNode();

  void readLogin() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      userid = preferences.getString("username");
      password = preferences.getString("password");
      keyboard = preferences.getBool("keyboard");
      locationSyskey = preferences.getString("locationSyskey");
      counterSyskey = preferences.getString("counterSyskey");
      locationName = preferences.getString("locationName");
      system = preferences.getString("name");
    });
    print(locationName);
    //  print("keyboard $keyboard");
  }

  void saveRef() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setString("ref", cup);
    });
  }

  void getRef() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      ref = preferences.getString("ref");
    });
    print("card widget screen new ref: $ref");
  }

  @override
  void initState() {
    super.initState();
    cardNo = '';
    no = '';
    cup = '';
    readLogin();
    getRef();

    if (keyboard == false) {
      hideKeyboard();
    }

    // print("keyboard $keyboard");
  }

  static const platform = const MethodChannel('flutter.native/helper');
  Future<Null> hideKeyboard() async {
    try {
      final String result = await platform.invokeMethod('hideKeyboard');
      print('hideKeyboard>>$result');
    } on PlatformException catch (e) {
      print("Failed to Invoke Printer: '${e.message}'.");
    }
  }

  @override
  void didChangeDependencies() {
    readLogin();

    if (keyboard == false) {
      hideKeyboard();
    }

    super.didChangeDependencies();
  }

  var numSeparate;
  ProgressDialog dialog;
  @override
  Widget build(BuildContext context) {
    final providerheader =
        Provider.of<SaveCheckHeaderProvider>(context, listen: false);
    final provider = Provider.of<StockProvider>(context, listen: true);
    final connectionProvider = Provider.of<ConnectionProvider>(context);
    numSeparate = createDisplay(
      length: 16,
      separator: ',',
    );
    dialog = new ProgressDialog(context, isDismissible: false);
    dialog.style(
      message: getTranslated(context, "please_wait"),
      progressWidget: Center(
        child: CircularProgressIndicator(),
      ),
      insetAnimCurve: Curves.easeInOut,
    );
    return Scaffold(
        appBar: AppBarWidget(),
        body: GestureDetector(
          onTap: () {
            // FocusNode currentFocus = FocusScope.of(context);

            // if (!currentFocus.hasPrimaryFocus) {
            //   currentFocus.unfocus();
            // }
          },
          child: WillPopScope(
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    height: screenHeightMultiply(context, multiplyBy: 0.2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          getTranslated(context, "scan_city_rewards"),
                          style: TextStyle(fontSize: 20, color: Colors.black),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              getTranslated(
                                  context, "qr_code_to_earn_point_or_pay"),
                              style: TextStyle(
                                fontSize: 20,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            // Text(
                            //   getTranslated(context, "earn"),
                            //   style: TextStyle(
                            //       fontSize: 20,
                            //       color: Colors.black,
                            //       // fontWeight: FontWeight.bold
                            //       ),
                            //   textAlign: TextAlign.center,
                            // ),
                            // Text(
                            //   getTranslated(context, "point or"),
                            //   style: TextStyle(fontSize: 20, color: Colors.black),
                            //   textAlign: TextAlign.center,
                            // ),
                            // Text(
                            //   getTranslated(context, "pay"),
                            //   style: TextStyle(
                            //       fontSize: 20,
                            //       color: Colors.black,
                            //       // fontWeight: FontWeight.bold
                            //       ),
                            //   textAlign: TextAlign.center,
                            // )
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: screenHeightMultiply(context, multiplyBy: 0.03),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          getTranslated(context, "you_can_earn_points"),
                          style: TextStyle(
                              fontSize: 17,
                              color: Colors.black,
                              fontStyle: FontStyle.italic),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          getTranslated(context, "from_this_transaction"),
                          style: TextStyle(
                              fontSize: 17,
                              color: Colors.black,
                              fontStyle: FontStyle.italic),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  Container(
                      height: screenHeightMultiply(context, multiplyBy: 0.4),
                      child: Image.asset("assets/images/qr_image.jpg")),
                  Container(
                      width: screenWidthMultiply(context, multiplyBy: 0.5),
                      height: screenHeightMultiply(context, multiplyBy: 0.1),
                      child: Opacity(
                          opacity: 0.0,
                          child: RawKeyboardListener(
                              focusNode: new FocusNode(),
                              autofocus: false,
                              onKey: (RawKeyEvent event) {
                                if (event.runtimeType == RawKeyDownEvent &&
                                    event.logicalKey ==
                                        LogicalKeyboardKey.enter) {
                                  no = controller.text.split("\|").first;
                                  cup = controller.text.split("\|")[1];

                                  saveRef();

                                  cardNo = no;
                                  print('cardno in memberscan $cardNo');
                                  connectionProvider
                                      .checkconnection()
                                      .then((onValue) {
                                    if (onValue) {
                                      dialog.show();
                                      Provider.of<MemberScanProvider>(context,
                                              listen: false)
                                          .fetchMemberScan(cardNo)
                                          .catchError((onError) {
                                        dialog.hide().whenComplete(() {
                                          print("Member scan error $onError");
                                          Fluttertoast.showToast(
                                              msg:
                                                  "Member1 Scan Error! $onError",
                                              timeInSecForIosWeb: 4);
                                          // Navigator.pop(context);
                                          controller.clear();
                                          FocusScope.of(context)
                                              .requestFocus(_focusNode);
                                        });
                                      }
                                              // member can scan and result return
                                              ).then((result) {
                                        if (result.resultCode == "200") {
                                          controller.clear();
                                          FocusScope.of(context)
                                              .requestFocus(FocusNode());
                                          String cash = result
                                              .cardBalance[0].creditAmount;
                                          String point = result
                                              .cardBalance[1].creditAmount;
                                          String name =
                                              result.accountValue.firstName;
                                          providerheader.getHeader.t15 =
                                              result.cardNumber;
                                          print(
                                              "Check header of t15:${providerheader.getHeader.t15}");
                                          providerheader.getHeader.ref1 =
                                              double.parse(result.cardTypeID);
                                          Provider.of<MemberScanProvider>(
                                                  context,
                                                  listen: false)
                                              .fetchPromotionUse(
                                            result.accountValue,
                                            provider.getchkdtlsList(),
                                            providerheader.getHeader,
                                          )
                                              .catchError((onError) {
                                            Future.delayed(Duration(seconds: 3))
                                                .then((onValue) {
                                              dialog.hide().whenComplete(() {
                                                // print(
                                                //     "Promotion error: $onError");
                                                Fluttertoast.showToast(
                                                    msg:
                                                        "Promotion Use Error! $onError",
                                                    timeInSecForIosWeb: 4);
                                                controller.clear();
                                                FocusScope.of(context)
                                                    .requestFocus(_focusNode);
                                              });
                                            });
                                          }).then((onValue) {
                                            if (onValue.resultCode == "200") {
                                              for (int i = 0;
                                                  i <
                                                      onValue.ordervalue
                                                          .orderItems.length;
                                                  i++) {
                                                var promotionCodeRef = "";
                                                var itemVal = onValue
                                                    .ordervalue.orderItems[i];
                                                for (int j = 0;
                                                    j <
                                                        provider
                                                            .chkdtlsList.length;
                                                    j++) {
                                                  var tmpItemCode = provider
                                                          .chkdtlsList[j].t2 +
                                                      "-" +
                                                      provider
                                                          .chkdtlsList[j].t10;

                                                  if (tmpItemCode ==
                                                      itemVal.itemCode) {
                                                    int tmp = (itemVal
                                                            .totalPriceDiscountInt)
                                                        .toInt();

                                                    provider.chkdtlsList[j]
                                                        .n35 = tmp;

                                                    if (provider.chkdtlsList[j]
                                                            .n21 ==
                                                        0) {
                                                      provider.chkdtlsList[j]
                                                          .n34 = provider
                                                              .chkdtlsList[j]
                                                              .n34 -
                                                          tmp;
                                                    }
                                                    provider.chkdtlsList[j]
                                                        .n21 = provider
                                                            .chkdtlsList[j]
                                                            .n21 +
                                                        tmp;

                                                    provider.chkdtlsList[j]
                                                        .ref4 = 1;
                                                    provider.chkdtlsList[j]
                                                        .t10 = itemVal.unitName;

                                                    if (itemVal
                                                            .promotionCodeRef !=
                                                        "") {
                                                      var proCodes = [];
                                                      proCodes = itemVal
                                                          .promotionCodeRef
                                                          .split(',');

                                                      for (int pc = 0;
                                                          pc < proCodes.length;
                                                          pc++) {
                                                        var proCode =
                                                            proCodes[pc];

                                                        for (int p = 0;
                                                            p <
                                                                onValue
                                                                    .promotionvalue
                                                                    .length;
                                                            p++) {
                                                          var pUse = onValue
                                                              .promotionvalue[p];
                                                          if (proCode.split(
                                                                  ':')[0] ==
                                                              pUse.promotionCode) {
                                                            promotionCodeRef +=
                                                                pUse.promotionDetail +
                                                                    " - " +
                                                                    proCode.split(
                                                                        ':')[1];

                                                            if (promotionCodeRef !=
                                                                "") {
                                                              promotionCodeRef +=
                                                                  ",";
                                                            }
                                                          }
                                                        }
                                                      }
                                                    }
                                                    provider.chkdtlsList[j].t7 =
                                                        promotionCodeRef;
                                                    print(
                                                        " t7 is :${provider.chkdtlsList[j].t7}");
                                                  }
                                                }
                                              }
                                              // providerheader.getHeader.t15 =
                                              //     result.cardNumber;
                                              // providerheader.getHeader.ref1 =
                                              //     double.parse(
                                              //         result.cardTypeID);
                                              Future.delayed(
                                                      Duration(seconds: 3))
                                                  .then((value) {
                                                dialog.hide().whenComplete(() {
                                                  var cityDis = 0.0;
                                                  for (int i = 0;
                                                      i <
                                                          onValue
                                                              .ordervalue
                                                              .orderItems
                                                              .length;
                                                      i++) {
                                                    cityDis += onValue
                                                        .ordervalue
                                                        .orderItems[i]
                                                        .totalPriceDiscountInt;
                                                  }
                                                  double jj = cityDis;

                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          MemberSKUDiscount(
                                                        card: cash,
                                                        point: point,
                                                        promotion: jj,
                                                        name: name,
                                                        memberScan: result,
                                                        promotionUse: onValue,
                                                        system: system,
                                                        locationName:
                                                            locationName,
                                                      ),
                                                    ),
                                                  );
                                                });
                                              });
                                            } else {
                                              providerheader.getHeader.t15 = '';

                                              providerheader.getHeader.ref1 = 0;

                                              Future.delayed(
                                                      Duration(seconds: 2))
                                                  .then((value) {
                                                dialog.hide().whenComplete(() {
                                                  print(
                                                      "member scan error not include promotion: ${onValue.resultDesc}");
                                                  Fluttertoast.showToast(
                                                      msg:
                                                          "member scan error not include promotion: ${onValue.resultDesc}",
                                                      timeInSecForIosWeb: 4);
                                                  controller.clear();
                                                  FocusScope.of(context)
                                                      .requestFocus(_focusNode);
                                                });
                                              });
                                            }
                                          });
                                        }
                                        // memeber scan has return error result
                                        else {
                                          Future.delayed(Duration(seconds: 2))
                                              .then((value) {
                                            dialog.hide().whenComplete(() {
                                              Fluttertoast.showToast(
                                                  msg:
                                                      "Member Scan Error:${result.resultDesc}",
                                                  timeInSecForIosWeb: 4);
                                              controller.clear();
                                              FocusScope.of(context)
                                                  .requestFocus(_focusNode);
                                            });
                                          });
                                          // controller.clear();
                                          // FocusScope.of(context)
                                          //     .requestFocus(_focusNode);
                                        }
                                      });
                                    }
                                    // No value return bcoz of connection
                                    else {
                                      Future.delayed(Duration(seconds: 2))
                                          .then((onValue) {
                                        dialog.hide().whenComplete(() {
                                          Fluttertoast.showToast(
                                            timeInSecForIosWeb: 4,
                                            msg: getTranslated(context,
                                                "no_internet_connection"),
                                          );
                                          controller.clear();
                                          FocusScope.of(context)
                                              .requestFocus(_focusNode);
                                        });
                                      });

                                      // controller.clear();
                                      // FocusScope.of(context)
                                      //     .requestFocus(_focusNode);
                                    }
                                  });
                                }
                              },
                              child: GestureDetector(
                                onTap: () {
                                  FocusScope.of(context)
                                      .requestFocus(new FocusNode());
                                },
                                child: TextFormField(
                                    //enabled: false,
                                    // readOnly: true,

                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.go,
                                    focusNode: _focusNode,
                                    autofocus: true,
                                    controller: controller,
                                    onChanged: (value) {
                                      setState(() {
                                        no = value.split("\|").first;
                                      });
                                    },
                                    onFieldSubmitted: (value1) {
                                      String no = value1.split("\|").first;
                                      String cu = value1.split("\|")[1];

                                      if (cu.isEmpty) {
                                        cup = null;
                                        print("Testing ref null:  $cup");

                                        saveRef();
                                      } else {
                                        cup = cu;
                                        print("Testing ref with value $cup");

                                        saveRef();
                                      }

                                      cardNo = no;
                                      connectionProvider
                                          .checkconnection()
                                          .then((onValue) {
                                        if (onValue) {
                                          dialog.show();
                                          Provider.of<MemberScanProvider>(
                                                  context,
                                                  listen: false)
                                              .fetchMemberScan(cardNo)
                                              .catchError((onError) {
                                            dialog.hide().whenComplete(() {
                                              print(
                                                  "Member scan error $onError");
                                              Fluttertoast.showToast(
                                                  msg:
                                                      "Member1 Scan Error! $onError",
                                                  timeInSecForIosWeb: 4);
                                              // Navigator.pop(context);
                                              controller.clear();
                                              FocusScope.of(context)
                                                  .requestFocus(_focusNode);
                                            });
                                          }
                                                  // member can scan and result return
                                                  ).then((result) {
                                            if (result.resultCode == "200") {
                                              controller.clear();
                                              FocusScope.of(context)
                                                  .requestFocus(FocusNode());
                                              String cash = result
                                                  .cardBalance[0].creditAmount;
                                              String point = result
                                                  .cardBalance[1].creditAmount;
                                              String name =
                                                  result.accountValue.firstName;
                                              providerheader.getHeader.t15 =
                                                  result.cardNumber;
                                              print(
                                                  "Check header of t15:${providerheader.getHeader.t15}");
                                              providerheader.getHeader.ref1 =
                                                  double.parse(
                                                      result.cardTypeID);
                                              Provider.of<MemberScanProvider>(
                                                      context,
                                                      listen: false)
                                                  .fetchPromotionUse(
                                                result.accountValue,
                                                provider.getchkdtlsList(),
                                                providerheader.getHeader,
                                              )
                                                  .catchError((onError) {
                                                Future.delayed(
                                                        Duration(seconds: 3))
                                                    .then((onValue) {
                                                  dialog
                                                      .hide()
                                                      .whenComplete(() {
                                                    // print(
                                                    //     "Promotion error: $onError");
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            "Promotion Use Error! $onError",
                                                        timeInSecForIosWeb: 4);
                                                    controller.clear();
                                                    FocusScope.of(context)
                                                        .requestFocus(
                                                            _focusNode);
                                                  });
                                                });
                                              }).then((onValue) {
                                                if (onValue.resultCode ==
                                                    "200") {
                                                  for (int i = 0;
                                                      i <
                                                          onValue
                                                              .ordervalue
                                                              .orderItems
                                                              .length;
                                                      i++) {
                                                    var promotionCodeRef = "";
                                                    var itemVal = onValue
                                                        .ordervalue
                                                        .orderItems[i];
                                                    for (int j = 0;
                                                        j <
                                                            provider.chkdtlsList
                                                                .length;
                                                        j++) {
                                                      var tmpItemCode = provider
                                                              .chkdtlsList[j]
                                                              .t2 +
                                                          "-" +
                                                          provider
                                                              .chkdtlsList[j]
                                                              .t10;

                                                      if (tmpItemCode ==
                                                          itemVal.itemCode) {
                                                        int tmp = (itemVal
                                                                .totalPriceDiscountInt)
                                                            .toInt();

                                                        provider.chkdtlsList[j]
                                                            .n35 = tmp;

                                                        if (provider
                                                                .chkdtlsList[j]
                                                                .n21 ==
                                                            0) {
                                                          provider
                                                              .chkdtlsList[j]
                                                              .n34 = provider
                                                                  .chkdtlsList[
                                                                      j]
                                                                  .n34 -
                                                              tmp;
                                                        }
                                                        provider.chkdtlsList[j]
                                                            .n21 = provider
                                                                .chkdtlsList[j]
                                                                .n21 +
                                                            tmp;

                                                        provider.chkdtlsList[j]
                                                            .ref4 = 1;
                                                        provider.chkdtlsList[j]
                                                                .t10 =
                                                            itemVal.unitName;

                                                        if (itemVal
                                                                .promotionCodeRef !=
                                                            "") {
                                                          var proCodes = [];
                                                          proCodes = itemVal
                                                              .promotionCodeRef
                                                              .split(',');

                                                          for (int pc = 0;
                                                              pc <
                                                                  proCodes
                                                                      .length;
                                                              pc++) {
                                                            var proCode =
                                                                proCodes[pc];

                                                            for (int p = 0;
                                                                p <
                                                                    onValue
                                                                        .promotionvalue
                                                                        .length;
                                                                p++) {
                                                              var pUse = onValue
                                                                  .promotionvalue[p];
                                                              if (proCode.split(
                                                                      ':')[0] ==
                                                                  pUse.promotionCode) {
                                                                promotionCodeRef += pUse
                                                                        .promotionDetail +
                                                                    " - " +
                                                                    proCode.split(
                                                                        ':')[1];

                                                                if (promotionCodeRef !=
                                                                    "") {
                                                                  promotionCodeRef +=
                                                                      ",";
                                                                }
                                                              }
                                                            }
                                                          }
                                                        }
                                                        provider.chkdtlsList[j]
                                                                .t7 =
                                                            promotionCodeRef;
                                                        print(
                                                            " t7 is :${provider.chkdtlsList[j].t7}");
                                                      }
                                                    }
                                                  }
                                                  // providerheader.getHeader.t15 =
                                                  //     result.cardNumber;
                                                  // providerheader.getHeader.ref1 =
                                                  //     double.parse(
                                                  //         result.cardTypeID);
                                                  Future.delayed(
                                                          Duration(seconds: 3))
                                                      .then((value) {
                                                    dialog
                                                        .hide()
                                                        .whenComplete(() {
                                                      var cityDis = 0.0;
                                                      for (int i = 0;
                                                          i <
                                                              onValue
                                                                  .ordervalue
                                                                  .orderItems
                                                                  .length;
                                                          i++) {
                                                        cityDis += onValue
                                                            .ordervalue
                                                            .orderItems[i]
                                                            .totalPriceDiscountInt;
                                                      }
                                                      double jj = cityDis;

                                                      Navigator.of(context)
                                                          .push(
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              MemberSKUDiscount(
                                                            card: cash,
                                                            point: point,
                                                            promotion: jj,
                                                            name: name,
                                                            memberScan: result,
                                                            promotionUse:
                                                                onValue,
                                                            system: system,
                                                            locationName:
                                                                locationName,
                                                          ),
                                                        ),
                                                      );
                                                    });
                                                  });
                                                } else {
                                                  providerheader.getHeader.t15 =
                                                      '';

                                                  providerheader
                                                      .getHeader.ref1 = 0;

                                                  Future.delayed(
                                                          Duration(seconds: 2))
                                                      .then((value) {
                                                    dialog
                                                        .hide()
                                                        .whenComplete(() {
                                                      print(
                                                          "member scan error not include promotion: ${onValue.resultDesc}");
                                                      Fluttertoast.showToast(
                                                          msg:
                                                              "member scan error not include promotion: ${onValue.resultDesc}",
                                                          timeInSecForIosWeb:
                                                              4);
                                                      controller.clear();
                                                      FocusScope.of(context)
                                                          .requestFocus(
                                                              _focusNode);
                                                    });
                                                  });
                                                }
                                              });
                                            }
                                            // memeber scan has return error result
                                            else {
                                              Future.delayed(
                                                      Duration(seconds: 2))
                                                  .then((value) {
                                                dialog.hide().whenComplete(() {
                                                  Fluttertoast.showToast(
                                                      msg:
                                                          "Member Scan Error:${result.resultDesc}",
                                                      timeInSecForIosWeb: 4);
                                                  controller.clear();
                                                  FocusScope.of(context)
                                                      .requestFocus(_focusNode);
                                                });
                                              });
                                              // controller.clear();
                                              // FocusScope.of(context)
                                              //     .requestFocus(_focusNode);
                                            }
                                          });
                                        }
                                        // No value return bcoz of connection
                                        else {
                                          Future.delayed(Duration(seconds: 2))
                                              .then((onValue) {
                                            dialog.hide().whenComplete(() {
                                              Fluttertoast.showToast(
                                                timeInSecForIosWeb: 4,
                                                msg: getTranslated(context,
                                                    "no_internet_connection"),
                                              );
                                              controller.clear();
                                              FocusScope.of(context)
                                                  .requestFocus(_focusNode);
                                            });
                                          });

                                          // controller.clear();
                                          // FocusScope.of(context)
                                          //     .requestFocus(_focusNode);
                                        }
                                      });
                                    }),
                              )))),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(
              width: 70,
            ),
            Container(
              height: screenHeightMultiply(context, multiplyBy: 0.1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: screenHeight(context, dividedBy: 16),
                    width: screenWidth(context,dividedBy:  2.5)  ,
                    decoration: new BoxDecoration(
                      color: Colors.grey[300],
                      border: new Border.all(color: Colors.black, width: 1),
                      borderRadius: new BorderRadius.circular(30.0),
                    ),
                    child: FlatButton(
                      onPressed: () {
                        connectionProvider.checkconnection().then((onValue) {
                          if (onValue) {
                            dialog.show();

                            if (providerheader.getHeader.t15.toString() != "") {
                              // Fluttertoast.showToast(msg: "skip onPress");
                              Provider.of<SaveCheckHeaderProvider>(context,
                                      listen: false)
                                  .skipMember(providerheader.getHeader)
                                  .catchError((onError) {
                                Future.delayed(Duration(seconds: 3))
                                    .then((value) {
                                  dialog.hide().whenComplete(() {
                                    Fluttertoast.showToast(
                                        msg:
                                            "void check header error $onError");
                                  });
                                });
                              }).then((onValue1) {
                                // if(onValue1=="")
                                providerheader.getHeader.t15 = "";
                                providerheader.getHeader.ref1 = 0.0;
                                // Fluttertoast.showToast(
                                // msg: "skip success $onValue1");

                                print(onValue1);
                                print('t15 >> ${providerheader.getHeader.t15}');
                                Future.delayed(Duration(seconds: 3))
                                    .then((value) {
                                  dialog.hide().whenComplete(() {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => NonMemberWidget(
                                          system: system,
                                          locationName: locationName,
                                          // couponCount: couponCount
                                        ),
                                      ),
                                    );
                                  });
                                });
                              });
                            } else {
                              Future.delayed(Duration(seconds: 3))
                                  .then((value) {
                                dialog.hide().whenComplete(() {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => NonMemberWidget(
                                        system: system,
                                        locationName: locationName,
                                      ),
                                    ),
                                  );
                                });
                              });
                            }
                          } else {
                            dialog.hide().whenComplete(() {
                              Fluttertoast.showToast(
                                timeInSecForIosWeb: 4,
                                msg: getTranslated(
                                    context, "no_internet_connection"),
                              );
                            });
                          }
                        });
                      },
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text(getTranslated(context, "skip")),
                            Row(
                              children: <Widget>[
                                Container(
                                  height: 20,
                                  width: 20,
                                  child: Image.asset("assets/images/skip.jpg"),
                                ),
                                Container(
                                  height: 20,
                                  width: 20,
                                  child: Image.asset("assets/images/skip.jpg"),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                ],
              ),
            ),
            FloatingActionButton(
              backgroundColor: Colors.white,
              onPressed: () {
                // Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => PlasticBagScreen(),
                  ),
                );
              },
              child: Container(
                child: Icon(
                  Icons.reply,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ));
  }
}
