class Purchase {
  final String productName;
  final double price;
  final DateTime date;
  final int quantity;  // Ajout de la quantité ici
  final String purchaseId;

  Purchase({
    required this.productName,
    required this.price,
    required this.date,
    required this.quantity,
    required this.purchaseId,
  });

  Map<String, dynamic> toMap() {
    return {
      'productName': productName,
      'price': price,
      'date': date.toIso8601String(),
      'quantity': quantity,
      'purchaseId': purchaseId,
    };
  }

  factory Purchase.fromMap(Map<String, dynamic> map) {
    return Purchase(
      productName: map['productName'],
      price: map['price'],
      date: DateTime.parse(map['date']),
      quantity: map['quantity'],
      purchaseId: map['purchaseId'],
    );
  }
}
