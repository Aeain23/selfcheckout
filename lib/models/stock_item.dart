import 'package:flutter/foundation.dart';
import '../models/topup_request_detail_data.dart';
import '../models/check_detail_item.dart';

class StockItem {
  final List<TopUpRequestDetailData> mobilestocklist;
  final List<CheckDetailItem> chkDtls;
  StockItem({
    @required this.mobilestocklist,
    @required this.chkDtls,
  });
  factory StockItem.fromJson(Map<String, dynamic> json) => StockItem(
        mobilestocklist: json['mobilestocklist']
            .map<TopUpRequestDetailData>(
                (value) => new TopUpRequestDetailData.fromJson(value))
            .toList(),
        chkDtls: json['chkDtls']
            .map<CheckDetailItem>(
                (value) => new CheckDetailItem.fromJson(value))
            .toList()
      );
}
