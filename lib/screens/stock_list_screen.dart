import 'package:flutter/material.dart';
import 'package:self_check_out/widgets/app_bar_widget.dart';
import '../widgets/stock_list_widget.dart';

class StockListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBarWidget(),
      body: StockListWidget(),
    );
  }
}
