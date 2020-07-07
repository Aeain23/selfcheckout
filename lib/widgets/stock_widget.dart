import 'package:flutter/material.dart';
import '../screens/stock_list_screen.dart';
import '../models/stock_item.dart';
import '../screensize_reducer.dart';
import '../widgets/app_bar_widget.dart';

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
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => StockListScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(),
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
              style:const TextStyle(
                  fontSize: 20, color: Colors.black, letterSpacing: 2),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Text(
                'Ks ${widget.item.chkDtls[0].n14.toString()}',
                style: const TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
