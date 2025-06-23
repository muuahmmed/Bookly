// sale_info.dart
class ListPrice {
  final double? amount;
  final String? currencyCode;

  ListPrice({this.amount, this.currencyCode});

  factory ListPrice.fromJson(Map<String, dynamic> json) => ListPrice(
    amount: json['amount']?.toDouble(),
    currencyCode: json['currencyCode'],
  );
}

class SaleInfo {
  final String? country;
  final String? saleability;
  final bool? isEbook;
  final ListPrice? listPrice;  // Added this

  SaleInfo({
    this.country,
    this.saleability,
    this.isEbook,
    this.listPrice,  // Added
  });

  factory SaleInfo.fromJson(Map<String, dynamic> json) => SaleInfo(
    country: json['country'],
    saleability: json['saleability'],
    isEbook: json['isEbook'],
    listPrice: json['listPrice'] != null  // Added
        ? ListPrice.fromJson(json['listPrice'])
        : null,
  );
}
