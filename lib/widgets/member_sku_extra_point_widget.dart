import 'package:flutter/material.dart';
import '../localization/language_constants.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/card_widget.dart';
import '../screens/payment_screen.dart';

class MemberSkuExtraPointWidget extends StatefulWidget {
  @override
  _MemberSkuExtraPointWidgetState createState() =>
      _MemberSkuExtraPointWidgetState();
}

class _MemberSkuExtraPointWidgetState extends State<MemberSkuExtraPointWidget> {
  Widget _createTableHeader(String label) {
    return Container(
      height: 30,
      alignment: Alignment.center,
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.black),
      ),
    );
  }

  Widget _createTableCell(String label) {
    return Container(
      margin: EdgeInsets.only(left: 5),
      height: 30,
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
      margin: EdgeInsets.only(right: 5),
      height: 30,
      alignment: Alignment.centerRight,
      child: Text(
        label,
        textAlign: TextAlign.right,
        style: TextStyle(color: Colors.black),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => CardWidget(),
          ),
        );
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBarWidget(),
        body: SingleChildScrollView(
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
                                  Text(getTranslated(context, "city_cash")),
                                  Text("Ks 20,000"),
                                ],
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                Text(getTranslated(context, "points")),
                                Text("500"),
                              ],
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
                                  TableRow(
                                    children: [
                                      TableCell(
                                          child: _createTableCell(
                                              "Coca Cola 330 ml")),
                                      TableCell(child: _createTableCell1("1")),
                                      TableCell(
                                          child: _createTableCell1("500")),
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      TableCell(
                                          child:
                                              _createTableCell(" Cola 330 ml")),
                                      TableCell(child: _createTableCell1("1")),
                                      TableCell(
                                          child: _createTableCell1("500")),
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      TableCell(child: _createTableCell("")),
                                      TableCell(child: _createTableCell1("")),
                                      TableCell(child: _createTableCell1("")),
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      TableCell(
                                          child: _createTableCell(getTranslated(
                                              context, "total_include_tax"))),
                                      TableCell(child: _createTableCell1("")),
                                      TableCell(child: _createTableCell1("")),
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      TableCell(
                                          child: _createTableCell(getTranslated(
                                              context, "commercial_tax"))),
                                      TableCell(child: _createTableCell1("")),
                                      TableCell(child: _createTableCell1("")),
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      TableCell(child: _createTableCell("")),
                                      TableCell(child: _createTableCell1("")),
                                      TableCell(child: _createTableCell1("")),
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      TableCell(
                                          child: _createTableCell(getTranslated(
                                              context, "point_earn"))),
                                      TableCell(child: _createTableCell1("")),
                                      TableCell(child: _createTableCell1("")),
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      TableCell(
                                          child: _createTableCell(
                                              "Get 1 point(s) @200 Ks")),
                                      TableCell(child: _createTableCell1("")),
                                      TableCell(child: _createTableCell1("")),
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      TableCell(
                                          child: _createTableCell(
                                              "Get  point(s) from Coca Cola")),
                                      TableCell(child: _createTableCell1("")),
                                      TableCell(child: _createTableCell1("")),
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      TableCell(
                                          child: _createTableCell(getTranslated(
                                              context, "points"))),
                                      TableCell(child: _createTableCell1("")),
                                      TableCell(child: _createTableCell1("")),
                                    ],
                                  ),
                                ]),
                          ],
                        )),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 16,
                  width: MediaQuery.of(context).size.width / 3,
                  decoration: new BoxDecoration(
                    color: Colors.grey[300],
                    border: new Border.all(color: Colors.black, width: 1),
                    borderRadius: new BorderRadius.circular(15.0),
                  ),
                  child: FlatButton(
                    child: Text(getTranslated(context, "next")),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => PaymentTypeScreen(),
                        ),
                      );
                    },
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}
