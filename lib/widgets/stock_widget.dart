import 'dart:async';
import 'package:flutter/material.dart';
import '../screens/stock_list_screen.dart';
import '../models/stock_item.dart';
import '../screensize_reducer.dart';

class StockWidget extends StatefulWidget {
  final StockItem item;
  StockWidget(this.item);
  @override
  _StockWidgetState createState() => _StockWidgetState();
}

class _StockWidgetState extends State<StockWidget> {
  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBarWidget(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              width: screenWidth(context, dividedBy: 4),
              child: Card(
                child: Image.asset('assets/images/new1.png'),
              ),
            ),
            Text(
              widget.item.chkDtls[0].t3,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).buttonColor,
                  letterSpacing: 2),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Text(
                'Ks ${widget.item.chkDtls[0].n14.toString()}',
                style: TextStyle(
                    fontSize: 24,
                    color: Theme.of(context).buttonColor,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  startTime() async {
    var duration = new Duration(seconds: 2);
    return new Timer(duration, route);
  }

  route() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => StockListScreen()));
  }
}
