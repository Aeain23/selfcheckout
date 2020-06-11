import 'package:flutter/material.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/stock_list_widget.dart';

class StockListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(),
      body: StockListWidget(),
     
    );
  }
}
