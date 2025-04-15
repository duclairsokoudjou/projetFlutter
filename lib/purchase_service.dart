import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'purchase.dart';

class PurchaseService {
  static const _purchasesKey = 'purchases';

  // Cette méthode simule la récupération des achats
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

  // Ajouter un achat dans l'historique
  static Future<void> addPurchase(Purchase purchase) async {
    final prefs = await SharedPreferences.getInstance();
    final purchasesData = prefs.getStringList(_purchasesKey) ?? [];

    // Ajouter le nouvel achat à la liste existante
    purchasesData.add(jsonEncode(purchase.toMap()));

    // Enregistrer la liste mise à jour dans SharedPreferences
    await prefs.setStringList(_purchasesKey, purchasesData);
    print('Achat ajouté: ${purchase.productName}');
  }
}
