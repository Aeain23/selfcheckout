
class CardUsage {
  final String requestNumber;
  List<CardData> dd;
  final String resultCode;
  final String resultDesc;
  final String resultRef;
  final List rewards;

  CardUsage(
      {this.requestNumber,
      this.dd,
      this.resultCode,
      this.resultDesc,
      this.resultRef,
      this.rewards});
  factory CardUsage.fromJson(Map<String, dynamic> json) => CardUsage(
        requestNumber: json['requestNumber'],
        dd: ((json['cardCreditChangeList']) as List)
            .map((value) => CardData.fromJson(value))
            .toList(),
        resultCode: json['resultCode'],
        resultDesc: json['resultDesc'],
        resultRef: json['resultRef'],
        rewards: json['rewards'],
      );
}

class CardData {
  var code;
  var permoney;
  var amountchange;
  var name;
  var amount;
  var type;
  var expdate;
  var experamout;

  CardData(
      {this.code,
      this.permoney,
      this.amountchange,
      this.name,
      this.amount,
      this.type,
      this.expdate,
      this.experamout});

  factory CardData.fromJson(Map<String, dynamic> json) => CardData(
      code: json['CreditCode'],
      permoney: json['CreditPerMoney'],
      amountchange: json['CreditAmountChange'],
      name: json['CreditName'],
      amount: json['CreditAmount'],
      type: json['CreditType'],
      expdate: json['CreditExpireDate'],
      experamout: json['CreditExpireAmount']);
}

class SavePayment {
  String result;
  SavePayment({this.result});
  factory SavePayment.fromJson(Map<String, dynamic> json) => SavePayment(
    result:json['result'],
  );
}