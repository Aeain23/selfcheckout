import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:number_display/number_display.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:self_check_out/models/login.dart';
import 'package:self_check_out/providers/member_scan_provider.dart';
import 'package:self_check_out/screens/splash_screen.dart';
import '../widgets/card_widget.dart';
import '../localization/language_constants.dart';
import '../models/check_detail_item.dart';
import '../providers/save_checkheader_provider.dart';
import '../providers/stock_provider.dart';
import '../screens/payment_screen.dart';
import '../widgets/app_bar_widget.dart';

class NonMemberWidget extends StatefulWidget {
  final String cash;
  final String point;
  final int couponCount;
  final String system;
  final String locationName;
  NonMemberWidget(
      {this.cash,
      this.point,
      this.couponCount,
      this.locationName,
      this.system});
  @override
  _NonMemberWidgetState createState() => _NonMemberWidgetState();
}

class _NonMemberWidgetState extends State<NonMemberWidget> {
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
      // height: 30,
      alignment: Alignment.centerRight,
      child: Text(
        label,
        textAlign: TextAlign.right,
        style: TextStyle(color: Colors.black),
      ),
    );
  }

  int couponCount = 0;
  var n19 = 0;
  var n20 = 0;
  var locFlag;
  var totalforcupon;

  @override
  void initState() {
    super.initState();
    final providerheader =
        Provider.of<SaveCheckHeaderProvider>(context, listen: false);
    final provider = Provider.of<StockProvider>(context, listen: false);
    totalforcupon = provider.totalAmount.round();
    print("Total for cupon: $totalforcupon");
    var systemforcupon = json.decode(widget.system);
    var systemsetup = SystemSetup.fromJson(systemforcupon);

    if (systemsetup.n52 != 0) {
      var location = systemsetup.t41;
      var locationList = [];
      locationList = location.split(',');
      locFlag = false;
      for (var i = 0; i < locationList.length; i++) {
        if (widget.locationName == locationList[i].toString()) {
          locFlag = true;
          print("Cupon in location locFlag $locFlag");
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
        if (totalforcupon >= systemsetup.n51) {
          couponCount = (totalforcupon / systemsetup.n51).floor();
          n19 = systemsetup.n51.toInt();
          n20 = 1;
          print(" cupon count is : $couponCount in else condition");
          print(" cupon n19 : $n19 in else condition");
          print(" cupon n20 : $n20 in else condition");
          providerheader.chkHeader.n19 = n19;
          providerheader.chkHeader.n20 = n20;
        } else {
          providerheader.chkHeader.n19 = 0;
          providerheader.chkHeader.n20 = 0;
        }
      }
    });
    // providerheader.chkHeader.n19 = n19;
    // providerheader.chkHeader.n20 = n20;
  }

  ProgressDialog dialog;
  var numSeparate;
  @override
  Widget build(BuildContext context) {
    numSeparate = createDisplay(length: 16, separator: ',', decimal: 0);
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
        child: CircularProgressIndicator(),
      ),
      insetAnimCurve: Curves.easeInOut,
    );
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CardWidget(),
          ),
        );
        // Navigator.of(context).pop();
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBarWidget(),
        body: WillPopScope(
          onWillPop: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => CardWidget(),
              ),
            );
            return Future.value(false);
          },
          child: SingleChildScrollView(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: <
                    Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    child: Column(
                      children: <Widget>[
                        Container(
                          color: Colors.grey[300],
                          child: Table(
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
                                for (var i = 0; i < chkdtls.length; i++)
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
                                for (var j = 0; j < chkdtls.length; j++)
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
                                TableRow(
                                  children: [
                                    TableCell(child: _createTableCell("")),
                                    TableCell(child: _createTableCell1("")),
                                    TableCell(child: _createTableCell1("")),
                                  ],
                                ),
                                // TableRow(
                                //   children: [
                                //     TableCell(
                                //         child: _createTableCell("Total Qty")),
                                //     TableCell(child: _createTableCell1("${provider.qty.round()}")),
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
                                            "${provider.totalAmount.round()}")),
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
                        ),
                      ],
                    )),
              ),
            ]),
          ),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(
              width: 30,
            ),
            Container(
              height: MediaQuery.of(context).size.height / 20,
              width: MediaQuery.of(context).size.width / 3,
              decoration: new BoxDecoration(
                color: Colors.grey[300],
                border: new Border.all(color: Colors.black, width: 1),
                borderRadius: new BorderRadius.circular(15.0),
              ),
              child: FlatButton(
                child: Text(getTranslated(context, "next")),
                onPressed: () {
                  dialog.show();
                  Provider.of<SaveCheckHeaderProvider>(context, listen: false)
                      .fetchSaveHeader(
                          provider.totalAmount, provider.chkdtlsList)
                      .catchError((onError) {
                    dialog.hide().whenComplete(() {
                      // Fluttertoast.showToast(
                      //     msg: "SavecheckHeader Error! $onError",
                      //     timeInSecForIosWeb: 4);
                    });
                  }).then((saveHeader) {
                    // print(
                    //     "Coupon function in n19 $n19 and n20 is $n20 in savecheck header");
                    print("result state ${saveHeader.result.state}");
                    if (saveHeader.result.state == true) {
                      Future.delayed(Duration(seconds: 3)).then((value) {
                        dialog.hide().whenComplete(() {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => PaymentTypeScreen(
                                cuponCount: couponCount,
                              ),
                            ),
                          );
                        });
                      });
                    } else {
                       Future.delayed(Duration(seconds: 3)).then((value) {
                      dialog.hide().whenComplete(() {
                          Fluttertoast.showToast(
                              msg: "${saveHeader.result.msgDesc}",
                              timeInSecForIosWeb: 4);
                              if (saveHeader.result.msgDesc ==
                              "This Slip is already paid!") {
                               provider.chkdtlsList = [];
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
});
                    }
                  });
                },
              ),
            ),
            FloatingActionButton(
              backgroundColor: Colors.white,
              onPressed: () {
                // Navigator.pushReplacement(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => CardWidget(),
                //   ),
                // );
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CardWidget(),
                  ),
                );
                //  Navigator.of(context).pop();
              },
              child: Container(
                child: Icon(
                  Icons.reply,
                  color: Colors.black,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
