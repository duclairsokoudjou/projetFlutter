import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'purchase.dart';

class PurchaseService {
  static const String _purchasesKey = 'purchases';

  static Future<List<Purchase>> getPurchases() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? jsonList = prefs.getStringList(_purchasesKey);

    if (jsonList == null) return [];

    return jsonList.map((jsonString) {
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      return Purchase.fromJson(jsonMap);
    }).toList();
  }

  static Future<void> addPurchase(Purchase purchase) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> jsonList = prefs.getStringList(_purchasesKey) ?? [];

    jsonList.add(json.encode(purchase.toJson()));

    await prefs.setStringList(_purchasesKey, jsonList);
  }

  static Future<void> clearPurchases() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_purchasesKey);
  }
}
