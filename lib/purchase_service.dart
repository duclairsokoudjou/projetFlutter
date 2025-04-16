import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'purchase.dart';

class PurchaseService {
  static const _purchasesKey = 'purchases';

  static Future<List<Purchase>> getPurchases() async {
    final prefs = await SharedPreferences.getInstance();
    final purchasesData = prefs.getStringList(_purchasesKey);

    if (purchasesData == null || purchasesData.isEmpty) {
      return [];
    } else {
      return purchasesData
          .map((purchase) => Purchase.fromMap(jsonDecode(purchase)))
          .toList();
    }
  }

  static Future<void> addPurchase(Purchase purchase) async {
    final prefs = await SharedPreferences.getInstance();
    final purchasesData = prefs.getStringList(_purchasesKey) ?? [];

 
    purchasesData.add(jsonEncode(purchase.toMap()));

   
    await prefs.setStringList(_purchasesKey, purchasesData);
    print('Achat ajouté: ${purchase.productName}');
  }
}
