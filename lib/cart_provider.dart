import 'package:flutter/material.dart';

class CartItem {
  String name;
  double price;
  int quantity;

  CartItem({required this.name, required this.price, required this.quantity});
}

class CartProvider with ChangeNotifier {
  List<CartItem> cartitems = [];

  void addToCart(CartItem item) {
    final index = cartitems.indexWhere((cartItem) => cartItem.name == item.name);

    if (index != -1) {
     
      cartitems[index].quantity += item.quantity;
    } else {
     
      cartitems.add(item);
    }
    notifyListeners();
  }

  void removeFromCart(CartItem item) {
    cartitems.remove(item);
    notifyListeners();
  }

  void clearCart() {
    cartitems.clear();
    notifyListeners();
  }
  void removeByName(String name) {
  cartitems.removeWhere((item) => item.name == name);
  notifyListeners();
}
void updateQuantity(String name, int newQuantity) {
  final index = cartitems.indexWhere((item) => item.name == name);
  if (index != -1) {
    cartitems[index].quantity = newQuantity;
    if (newQuantity == 0) {
      cartitems.removeAt(index);
    }
    notifyListeners();
  }
}
}

