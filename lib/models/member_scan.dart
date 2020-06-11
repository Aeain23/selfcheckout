class MemberScan {
  final String resultCode;
  final String name;
  final String cardType;
  final String cardTypeID;
  final String resultDesc;
  final String cardNumber;
  final String cardStatus;
  AccountValue accountValue;
  RequestValue requestValue;
  List<CardBalances> cardBalance;
  MemberScan(
      {this.cardNumber,
      this.cardStatus,
      this.cardType,
      this.cardTypeID,
      this.name,
      this.resultCode,
      this.resultDesc,
      this.accountValue,
      this.requestValue,
      this.cardBalance});

  factory MemberScan.fromJson(Map<String, dynamic> json) => MemberScan(
        cardNumber: json['cardNumber'],
        cardStatus: json['cardStatus'],
        cardType: json['cardType'],
        cardTypeID: json['cardTypeID'],
        name: json['name'],
        resultCode: json['resultCode'],
        resultDesc: json['resultDesc'],
        accountValue: AccountValue.fromJson(json['accountValue']),
        requestValue: RequestValue.fromJson(json['requestValue']),
        cardBalance: (json['cardBalances'] as List)
            .map((i) => CardBalances.fromJson(i))
            .toList(),
      );
}

class AccountValue {
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
  AccountValue({
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
  factory AccountValue.fromJson(Map<String, dynamic> json) => AccountValue(
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

class RequestValue {
  final String rRequestNumber;
  final String rMerchantCode;
  final String rBusinessDate;
  final String rStaffID;
  final String rStaffName;
  final String rBrandName;
  final String rShopName;
  final String rShopArea;
  final String rTerminalID;
  final String rTerminalName;
  final String rTerminalGroup;
  final String rTerminalLocation;
  final String rTerminalRegion;
  final String rPaymentType;
  final String rPaymentChannel;
  final String rPaymentRef;
  final bool rIsMultiplePayment;
  final String rRef1;
  final String rRef2;
  final String terminalLocation;
  final bool isMultiplePayment;
  final String paymentChannel;
  final String terminalRegion;
  final String businessDate;
  final String staffID;
  final String merchantCode;
  final String staffName;
  final String shopArea;
  final String terminalName;
  final String shopName;
  final String ref2;
  final String ref1;
  final String brandName;
  final String terminalGroup;
  final String paymentRef;
  final String terminalID;
  final String requestNumber;
  final String paymentType;
  RequestValue(
      {this.terminalLocation,
      this.terminalRegion,
      this.staffID,
      this.staffName,
      this.shopArea,
      this.terminalName,
      this.shopName,
      this.ref2,
      this.ref1,
      this.terminalGroup,
      this.terminalID,
      this.requestNumber,
      this.rRequestNumber,
      this.merchantCode,
      this.rBrandName,
      this.rBusinessDate,
      this.rIsMultiplePayment,
      this.rMerchantCode,
      this.rPaymentChannel,
      this.rPaymentRef,
      this.rPaymentType,
      this.rRef1,
      this.rRef2,
      this.rShopArea,
      this.rShopName,
      this.rStaffID,
      this.rStaffName,
      this.rTerminalGroup,
      this.rTerminalID,
      this.rTerminalLocation,
      this.rTerminalName,
      this.rTerminalRegion,
      this.brandName,
      this.businessDate,
      this.isMultiplePayment,
      this.paymentChannel,
      this.paymentRef,
      this.paymentType});
  factory RequestValue.fromJson(Map<String, dynamic> json) => RequestValue(
        rRequestNumber: json['RequestNumber'],
        rMerchantCode: json['MerchantCode'],
        rBusinessDate: json['BusinessDate'],
        rStaffID: json['StaffID'],
        rStaffName: json['StaffName'],
        rBrandName: json['BrandName'],
        rShopName: json['ShopName'],
        rShopArea: json['ShopArea'],
        rTerminalID: json['TerminalID'],
        rTerminalName: json['TerminalName'],
        rTerminalGroup: json['TerminalGroup'],
        rTerminalLocation: json['TerminalLocation'],
        rTerminalRegion: json['TerminalRegion'],
        rPaymentType: json['PaymentType'],
        rPaymentChannel: json['PaymentChannel'],
        rPaymentRef: json['PaymentRef'],
        rIsMultiplePayment: json['IsMultiplePayment'],
        rRef1: json['Ref1'],
        rRef2: json['Ref2'],
        terminalLocation: json['terminalLocation'],
        isMultiplePayment: json['isMultiplePayment'],
        paymentChannel: json['paymentChannel'],
        terminalRegion: json['terminalRegion'],
        businessDate: json['businessDate'],
        staffID: json['staffID'],
        merchantCode: json['merchantCode'],
        staffName: json['staffName'],
        shopArea: json['shopArea'],
        terminalName: json['terminalName'],
        shopName: json['shopName'],
        ref2: json['ref2'],
        ref1: json['ref1'],
        brandName: json['brandName'],
        terminalGroup: json['terminalGroup'],
        paymentRef: json['paymentRef'],
        terminalID: json['terminalID'],
        requestNumber: json['requestNumber'],
        paymentType: json['paymentType'],
      );
}

class CardBalances {
  final String creditCode;
  final String creditName;
  final String creditAmount;
  final String creditType;
  final String creditExpireDate;
  var creditExpireAmount;

  CardBalances(
      {this.creditAmount,
      this.creditCode,
      this.creditExpireAmount,
      this.creditExpireDate,
      this.creditName,
      this.creditType});
  factory CardBalances.fromJson(Map<String, dynamic> json) => CardBalances(
        creditAmount: json['CreditAmount'],
        creditCode: json['CreditCode'],
        creditExpireAmount: json['CreditExpireAmount'],
        creditExpireDate: json['CreditExpireDate'],
        creditName: json['CreditName'],
        creditType: json['CreditType'],
      );
}
