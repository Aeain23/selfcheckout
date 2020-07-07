class PromotionUse {
  final String resultCode;
  final String cardType;
  final String resultDesc;
  final String cardExpire;
  final String name;
  final String resultRef;
  final String cardStatus;
  final String cardNumber;
  List oupons;
  List<Reward> rewards;
  List<PromoUseValues> promotionvalue;
  AccountValues accountValue;
  OrderValue ordervalue;
  PromotionUse({
    this.cardExpire,
    this.cardNumber,
    this.cardStatus,
    this.cardType,
    this.name,
    this.oupons,
    this.resultCode,
    this.resultDesc,
    this.resultRef,
    this.rewards,
    this.promotionvalue,
    this.accountValue,
    this.ordervalue,
  });
  factory PromotionUse.fromJson(Map<String, dynamic> json) => PromotionUse(
      cardExpire: json['cardExpire'],
      cardNumber: json['cardNumber'],
      cardStatus: json['cardStatus'],
      cardType: json['cardType'],
      name: json['name'],
      oupons: json['oupons'] as List,
      resultCode: json['resultCode'],
      resultDesc: json['resultDesc'],
      resultRef: json['resultRef'],
      rewards:
          (json['rewards'] as List).map((i) => Reward.fromJson(i)).toList(),
      promotionvalue: (json['promoUseValues'] as List)
          .map((i) => PromoUseValues.fromJson(i))
          .toList(),
      accountValue: AccountValues.fromJson(json['accountValue']),
      ordervalue: OrderValue.fromJson(json['orderValue']));
}

class Reward {
 double rewardAmount;
  int rewardID;
  String rewardTitle;
  List subPromotions;
  String rewardType;
  String billDiscountUnit;
  double billDiscountRemain;
  String rewardApplyStatus;
  String rewardDescription;
  List promotionOrderItems;
  List coupons;
  Reward(
      {this.rewardAmount,
      this.rewardID,
      this.rewardTitle,
      this.subPromotions,
      this.rewardType,
      this.billDiscountUnit,
      this.billDiscountRemain,
      this.rewardApplyStatus,
      this.rewardDescription,
      this.promotionOrderItems,
      this.coupons});
  factory Reward.fromJson(Map<String, dynamic> json) => Reward(
        rewardAmount: json['rewardAmount'],
        rewardID: json['rewardID'],
        rewardTitle: json['rewardTitle'],
        subPromotions: json['subPromotions'] as List,
        rewardType: json['rewardType'],
        billDiscountUnit: json['billDiscountUnit'],
        billDiscountRemain: json['billDiscountRemain'],
        rewardApplyStatus: json['rewardApplyStatus'],
        rewardDescription: json['rewardDescription'],
        promotionOrderItems: json['promotionOrderItems'] as List,
        coupons: json['coupons'] as List,
      );
  Map<String, dynamic> toJson() => {
        'rewardAmount': rewardAmount,
        'rewardID': rewardID,
        'rewardTitle': rewardTitle,
        'subPromotions': subPromotions,
        'rewardType': rewardType,
        'billDiscountUnit': billDiscountUnit,
        'billDiscountRemain': billDiscountRemain,
        'rewardApplyStatus': rewardApplyStatus,
        'rewardDescription': rewardDescription,
        'promotionOrderItems': promotionOrderItems,
        'coupons': coupons
      };
}

class AccountValues {
  final String gender;
  final String accountType;
  final String accountNumber;
  final String birthDate;
  final String emailAddress;
  final String firstName;
  final String lastName;
  final String accountLevel;
  final String titleName;
  final String accountStatus;
  final bool isSetAccountPIN;
  final String passportNumber;
  final String identityNumber;
  final String primaryPhoneType;
  final String primaryPhoneNumber;
  AccountValues({
    this.gender,
    this.accountType,
    this.accountNumber,
    this.birthDate,
    this.emailAddress,
    this.firstName,
    this.lastName,
    this.accountLevel,
    this.titleName,
    this.accountStatus,
    this.isSetAccountPIN,
    this.passportNumber,
    this.identityNumber,
    this.primaryPhoneType,
    this.primaryPhoneNumber,
  });
  factory AccountValues.fromJson(Map<String, dynamic> json) => AccountValues(
        gender: json['gender'],
        accountType: json['accountType'],
        accountNumber: json['accountNumber'],
        birthDate: json['birthDate'],
        emailAddress: json['emailAddress'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        accountLevel: json['accountLevel'],
        accountStatus: json['accountStatus'],
        isSetAccountPIN: json['isSetAccountPIN'],
        passportNumber: json['passportNumber'],
        identityNumber: json['identityNumber'],
        primaryPhoneNumber: json['primaryPhoneNumber'],
        primaryPhoneType: json['primaryPhoneType'],
        titleName: json['titleName'],
      );
}

class PromoUseValues {
  final String promotionType;
  final String promotionCode;
  final String promotionQuota;
  final String promotionPeriod;
  final int promotionCountRemain;
  final String promotionApplyStatus;
  final double promotionAmountRemain;
  final String promotionAmountUnit;
  final String promotionDetail;
  final String promotionTitle;
  List rewards;
  PromoUseValues(
      {this.promotionAmountRemain,
      this.promotionAmountUnit,
      this.promotionApplyStatus,
      this.promotionCode,
      this.promotionCountRemain,
      this.promotionDetail,
      this.promotionPeriod,
      this.promotionQuota,
      this.promotionTitle,
      this.promotionType,
      this.rewards});
  factory PromoUseValues.fromJson(Map<String, dynamic> json) => PromoUseValues(
        promotionAmountRemain: json['promotionAmountRemain'],
        promotionAmountUnit: json['promotionAmountUnit'],
        promotionApplyStatus: json['promotionApplyStatus'],
        promotionCode: json['promotionCode'],
        promotionCountRemain: json['promotionCountRemain'],
        promotionDetail: json['promotionDetail'],
        promotionPeriod: json['promotionPeriod'],
        promotionQuota: json['promotionQuota'],
        promotionTitle: json['promotionTitle'],
        promotionType: json['promotionType'],
        rewards: json['rewards'] as List,
      );
  Map<String, dynamic> toJson() => {
        "rewards": rewards,
        "promotionTitle": promotionTitle,
        "promotionDetail": promotionDetail,
        "promotionPeriod": promotionPeriod,
        "promotionCountRemain": promotionCountRemain,
        "promotionAmountRemain": promotionAmountRemain,
        "promotionQuota": promotionQuota,
        "promotionApplyStatus": promotionApplyStatus,
        "promotionAmountUnit": promotionAmountUnit,
        "promotionType": promotionType,
        "promotionCode": promotionCode,
      };
}

class OrderItems {
  final double taxAmount;
  final double unitPrice;
  final String itemListCode;
  final double totalPrice;
  final String itemTitle;
  final String itemCode;
  final String unitName;
  final bool isModified;
  final double taxRate;
  final double totalAmount;
  final String serialNumber;
  final bool isServiceChargeUsePriceAfterDiscount;
  final double unit;
  final String itemType;
  final double serviceChargeAmount;
  final String itemServiceType;
  final double unitDiscountExt;
  final double unitDiscountInt;
  final double totalPriceAfterDiscount;
  final String promotionItemTypeStatus;
  final double totalPriceAfterTax;
  final bool isAddServiceCharge;
  final bool isAllowDiscount;
  final double totalPriceDiscountInt;
  final double totalPriceDiscount;
  final double totalPriceDiscountExt;
  String promotionCodeRef;

  OrderItems(
      {this.isAddServiceCharge,
      this.isAllowDiscount,
      this.isModified,
      this.isServiceChargeUsePriceAfterDiscount,
      this.itemCode,
      this.itemListCode,
      this.itemServiceType,
      this.itemTitle,
      this.itemType,
      this.promotionCodeRef,
      this.promotionItemTypeStatus,
      this.serialNumber,
      this.serviceChargeAmount,
      this.taxAmount,
      this.taxRate,
      this.totalAmount,
      this.totalPrice,
      this.totalPriceAfterDiscount,
      this.totalPriceAfterTax,
      this.totalPriceDiscount,
      this.totalPriceDiscountExt,
      this.totalPriceDiscountInt,
      this.unit,
      this.unitDiscountExt,
      this.unitDiscountInt,
      this.unitName,
      this.unitPrice});
  factory OrderItems.fromJson(Map<String, dynamic> json) => OrderItems(
        taxAmount: json['taxAmount'],
        serialNumber: json['serialNumber'],
        isModified: json['isModified'],
        taxRate: json['taxRate'],
        unitName: json['unitName'],
        serviceChargeAmount: json['serviceChargeAmount'],
        promotionCodeRef: json['promotionCodeRef'],
        totalPriceAfterTax: json['totalPriceAfterTax'],
        promotionItemTypeStatus: json['promotionItemTypeStatus'],
        unit: json['unit'],
        itemType: json['itemType'],
        totalAmount: json['totalAmount'],
        isServiceChargeUsePriceAfterDiscount:
            json['isServiceChargeUsePriceAfterDiscount'],
        itemServiceType: json['itemServiceType'],
        unitDiscountExt: json['unitDiscountExt'],
        totalPriceAfterDiscount: json['totalPriceAfterDiscount'],
        totalPriceDiscountExt: json['totalPriceDiscountExt'],
        unitDiscountInt: json['unitDiscountInt'],
        totalPriceDiscount: json['totalPriceDiscount'],
        totalPriceDiscountInt: json['totalPriceDiscountInt'],
        isAddServiceCharge: json['isAddServiceCharge'],
        isAllowDiscount: json['isAllowDiscount'],
        itemListCode: json['itemListCode'],
        itemTitle: json['itemTitle'],
        unitPrice: json['unitPrice'],
        totalPrice: json['totalPrice'],
        itemCode: json['itemCode'],
      );
  Map<String, dynamic> toJson() => {
        "taxAmount": taxAmount,
        "serialNumber": serialNumber,
        "isModified": isModified,
        "taxRate": taxRate,
        "unitName": unitName,
        "serviceChargeAmount": serviceChargeAmount,
        "promotionCodeRef": promotionCodeRef,
        "totalPriceAfterTax": totalPriceAfterTax,
        "promotionItemTypeStatus": promotionItemTypeStatus,
        "unit": unit,
        "itemType": itemType,
        "totalAmount": totalAmount,
        "isServiceChargeUsePriceAfterDiscount":
            isServiceChargeUsePriceAfterDiscount,
        "itemServiceType": itemServiceType,
        "unitDiscountExt": unitDiscountExt,
        "totalPriceAfterDiscount": totalPriceAfterDiscount,
        "totalPriceDiscountExt": totalPriceDiscountExt,
        "unitDiscountInt": unitDiscountInt,
        "totalPriceDiscount": totalPriceDiscount,
        "totalPriceDiscountInt": totalPriceDiscountInt,
        "isAddServiceCharge": isAddServiceCharge,
        "isAllowDiscount": isAllowDiscount,
        "itemListCode": itemListCode,
        "itemTitle": itemTitle,
        "unitPrice": unitPrice,
        "totalPrice": totalPrice,
        "itemCode": itemCode,
      };
}

class OrderValue {
  final double totalAmount;
  final String orderNumber;
  final double vatamount;
  final double vatrate;
  final double totalBillDiscount;
  final String promotionStatus;
  final double totalBillDiscountExtResult;
  final double totalBillAmountResult;
  final bool isTotalAmountIncludeVAT;
  final double serviceChargeRate;
  final double totalBeforeBillDiscount;
  final double totalBillDiscountIntResult;
  final double serviceChargeAmount;

  List<PaymentValue> payment;
  List<OrderItems> orderItems;
  OrderValue({
    this.payment,
    this.isTotalAmountIncludeVAT,
    this.orderNumber,
    this.promotionStatus,
    this.serviceChargeAmount,
    this.serviceChargeRate,
    this.totalAmount,
    this.totalBeforeBillDiscount,
    this.totalBillAmountResult,
    this.totalBillDiscount,
    this.totalBillDiscountExtResult,
    this.totalBillDiscountIntResult,
    this.vatamount,
    this.vatrate,
    this.orderItems,
  });
  factory OrderValue.fromJson(Map<String, dynamic> json) => OrderValue(
        totalBeforeBillDiscount: json['totalBeforeBillDiscount'],
        totalBillDiscount: json['totalBillDiscount'],
        promotionStatus: json['promotionStatus'],
        serviceChargeRate: json['serviceChargeRate'],
        serviceChargeAmount: json['serviceChargeAmount'],
        totalBillAmountResult: json['totalBillAmountResult'],
        isTotalAmountIncludeVAT: json['isTotalAmountIncludeVAT'],
        totalBillDiscountExtResult: json['totalBillDiscountExtResult'],
        totalBillDiscountIntResult: json['totalBillDiscountIntResult'],
        orderNumber: json['orderNumber'],
        totalAmount: json['totalAmount'],
        orderItems: (json['orderItems'] as List)
            .map((i) => OrderItems.fromJson(i))
            .toList(),
        vatrate: json['vatrate'],
        payment: json['paymentValues']
            .map<PaymentValue>((i) => PaymentValue.fromJson(i))
            .toList(),
        vatamount: json['vatamount'],
      );

  Map<String, dynamic> toJson() => {
        'totalBeforeBillDiscount': totalBeforeBillDiscount,
        'totalBillDiscount': totalBillDiscount,
        'promotionStatus': promotionStatus,
        'serviceChargeRate': serviceChargeRate,
        'serviceChargeAmount': serviceChargeAmount,
        'totalBillAmountResult': totalBillAmountResult,
        'isTotalAmountIncludeVAT': isTotalAmountIncludeVAT,
        'totalBillDiscountExtResult': totalBillDiscountExtResult,
        'totalBillDiscountIntResult': totalBillDiscountIntResult,
        'orderNumber': orderNumber,
        'totalAmount': totalAmount,
        'orderItems': orderItems,
        'vatrate': vatrate,
        'paymentValues': payment,
        'vatamount': vatamount,
      };
}

class PaymentValue {
  List tenders;
  final double totalAmount;
  final double totalBillDiscount;
  final double totalBeforeBillDiscount;
  PaymentValue(
      {this.tenders,
      this.totalAmount,
      this.totalBeforeBillDiscount,
      this.totalBillDiscount});
  factory PaymentValue.fromJson(Map<String, dynamic> json) => PaymentValue(
        tenders: json['tenders'],
        totalBeforeBillDiscount: json['totalBeforeBillDiscount'],
        totalBillDiscount: json['totalBillDiscount'],
        totalAmount: json['totalAmount'],
      );
  Map<String, dynamic> toJson() => {
        'tenders': tenders,
        'totalBeforeBillDiscount': totalBeforeBillDiscount,
        'totalBillDiscount': totalBillDiscount,
        'totalAmount': totalAmount,
      };
}
