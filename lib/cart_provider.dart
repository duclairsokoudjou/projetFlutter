import 'package:flutter/material.dart';


class CartItem{
  String name;
  double price;
  int quantity;

  CartItem ({required this.name, required this.price, required this.quantity});
}

class CartProvider with ChangeNotifier {
  List<CartItem> cartitems = [];

  void addToCart(CartItem item){
    cartitems.add(item);
    notifyListeners();
  }
} 