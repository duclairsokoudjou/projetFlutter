class Purchase {
  final String productName;
  final double price;
  final DateTime date;
  final int quantity;
  final String purchaseId;

  Purchase({
    required this.productName,
    required this.price,
    required this.date,
    required this.quantity,
    required this.purchaseId,
  });

  Map<String, dynamic> toJson() => {
    'productName': productName,
    'price': price,
    'date': date.toIso8601String(),
    'quantity': quantity,
    'purchaseId': purchaseId,
  };

  factory Purchase.fromJson(Map<String, dynamic> json) {
    return Purchase(
      productName: json['productName'],
      price: json['price'],
      date: DateTime.parse(json['date']),
      quantity: json['quantity'],
      purchaseId: json['purchaseId'],
    );
  }
}
